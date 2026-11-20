import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace


SCRIPTS_DIR = Path(__file__).resolve().parents[1]
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

from error_helper import analyze_common_issues
from typst_diagnostics import classify_warning, deduplicate_diagnostics, gate_failed


class TypstDiagnosticTests(unittest.TestCase):
    def test_touying_empty_transport_is_review_not_font(self):
        warning = SimpleNamespace(
            message=(
                "unknown font family: "
                + "\b" * 4
                + "[touying] detecting slide content is empty at page 3 "
                "(slide 2, subslide 1, content height: 0pt)."
            ),
            diagnostic="warning\n@preview/uniwarn:0.1.1/internal.typ:71:17",
        )
        result = classify_warning(warning)
        self.assertEqual("EMPTY_SLIDE", result.code)
        self.assertEqual("advisory", result.severity)
        self.assertEqual("project-render", result.owner)
        self.assertEqual(3, result.page)
        self.assertEqual(2, result.slide)
        self.assertTrue(result.message.startswith("[touying]"))

    def test_overflow_and_nonconvergence_are_blockers(self):
        overflow = classify_warning(
            "[touying] detecting slide content overflow at page 5"
        )
        convergence = classify_warning(
            "warning: document did not converge within five attempts"
        )
        self.assertEqual(("CONTENT_OVERFLOW", "blocker"), (overflow.code, overflow.severity))
        self.assertEqual(
            ("LAYOUT_NONCONVERGENCE", "blocker"),
            (convergence.code, convergence.severity),
        )

    def test_nonconvergence_and_page_variants_are_extracted(self):
        for warning, expected_page in (
            ("warning: page 12 did not stabilize", 12),
            ("warning: page number: 13 did not stabilize", 13),
            ("warning: on page #14 did not stabilize", 14),
        ):
            result = classify_warning(warning)
            self.assertEqual("LAYOUT_NONCONVERGENCE", result.code)
            self.assertEqual(expected_page, result.page)
        self.assertEqual(15, classify_warning("warning: page: 15: detail").page)

    def test_missing_resource_and_decoder_failure_are_distinct_blockers(self):
        missing = classify_warning("warning: image not found: logo.svg")
        decoder = classify_warning("warning: failed to load image decoder plugin")
        self.assertEqual(("MISSING_RESOURCE", "blocker"), (missing.code, missing.severity))
        self.assertEqual(
            ("IMAGE_DECODER_FAILURE", "blocker"), (decoder.code, decoder.severity)
        )

    def test_near_miss_does_not_match_missing_resource_rule(self):
        result = classify_warning("warning: file-not-found marker is part of a label")
        self.assertEqual("OTHER_WARNING", result.code)

    def test_deduplicate_diagnostics_preserves_occurrence_count(self):
        repeated = classify_warning("warning: image not found: logo.svg")
        distinct_page = classify_warning("warning: [touying] detecting slide content overflow at page 2")
        deduplicated = deduplicate_diagnostics([repeated, repeated, distinct_page])
        self.assertEqual(2, len(deduplicated))
        self.assertEqual(2, deduplicated[0].occurrences)
        self.assertEqual(1, deduplicated[1].occurrences)
        self.assertEqual("MISSING_RESOURCE", deduplicated[0].code)
        self.assertEqual("CONTENT_OVERFLOW", deduplicated[1].code)

    def test_font_fallback_deduplicates_across_package_locations(self):
        first = classify_warning(
            SimpleNamespace(
                message="unknown font family: Roboto",
                diagnostic="@preview/theme:1.0.0/a.typ:10:2: unknown font family: Roboto",
            )
        )
        second = classify_warning(
            SimpleNamespace(
                message="unknown font family: Roboto",
                diagnostic="@preview/theme:1.0.0/b.typ:20:4: unknown font family: Roboto",
            )
        )
        deduplicated = deduplicate_diagnostics([first, second])
        self.assertEqual(1, len(deduplicated))
        self.assertEqual(2, deduplicated[0].occurrences)

    def test_external_font_warning_is_review_owned_by_package(self):
        warning = SimpleNamespace(
            message="unknown font family: Corporate Sans",
            diagnostic=(
                "warning: unknown font family: Corporate Sans\n"
                "   \u250c\u2500 @preview/vendor-theme:1.2.3/theme.typ:44:9"
            ),
        )
        result = classify_warning(warning)
        self.assertEqual("FONT_FALLBACK", result.code)
        self.assertEqual("review", result.severity)
        self.assertEqual("external-package", result.owner)

    def test_location_extraction_preserves_paths_with_spaces(self):
        posix = classify_warning(
            SimpleNamespace(
                message="unknown font family: Example",
                diagnostic=(
                    "warning: unknown font family: Example\n"
                    "   \u250c\u2500 /tmp/My Project/main.typ:12:7"
                ),
            )
        )
        windows = classify_warning(
            SimpleNamespace(
                message="unknown font family: Example",
                diagnostic=(
                    "warning: unknown font family: Example\n"
                    "  --> C:\\Work Area\\deck\\main.typ:8:3"
                ),
            )
        )
        self.assertEqual("/tmp/My Project/main.typ:12:7", posix.location)
        self.assertEqual("C:\\Work Area\\deck\\main.typ:8:3", windows.location)

    def test_raw_future_syntax_is_advisory(self):
        result = classify_warning("template.typ:10:3: warning: no whitespace before raw text")
        self.assertEqual("RAW_TEXT_FUTURE_SYNTAX", result.code)
        self.assertEqual("advisory", result.severity)

    def test_gate_thresholds(self):
        review = classify_warning("warning: unknown font family: Missing")
        self.assertFalse(gate_failed([review], "blocker"))
        self.assertTrue(gate_failed([review], "review"))
        self.assertFalse(gate_failed([review], "none"))


class CommonIssueTests(unittest.TestCase):
    def _analyze(self, name, content):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / name
            path.write_text(content, encoding="utf-8")
            return analyze_common_issues(str(path))

    def test_static_analysis_does_not_count_brackets(self):
        issues = self._analyze(
            "demo.typ",
            '#import "template.typ": *\n#show: theme\n```text\n[[[\n```\n',
        )
        self.assertNotIn("UNMATCHED_BRACKETS", {item.code for item in issues})

    def test_package_wrapper_does_not_get_breakable_version_rule(self):
        issues = self._analyze(
            "demo.typ",
            '#import "@preview/vendor-theme:0.2.0": *\n#show: vendor-theme\n',
        )
        self.assertNotIn("AUTO_BREAK_REVIEW", {item.code for item in issues})

    def test_direct_touying_07_gets_page_break_advisory(self):
        issues = self._analyze(
            "demo.typ",
            '#import "@preview/touying:0.7.4": *\n#show: touying-slides\n',
        )
        self.assertIn("AUTO_BREAK_REVIEW", {item.code for item in issues})

    def test_commented_string_and_raw_touying_imports_do_not_trigger_version_rule(self):
        issues = self._analyze(
            "demo.typ",
            '// #import "@preview/touying:0.5.3": *\n'
            '#let example = "#import \\"@preview/touying:0.5.3\\": *"\n'
            '```typst\n#import "@preview/touying:0.5.3": *\n```\n'
            '#import "@preview/touying:0.7.4": *\n',
        )
        self.assertNotIn("DIRECT_TOUYING_PRE_0_6", {item.code for item in issues})

    def test_real_pre_06_direct_import_is_advisory(self):
        issues = self._analyze(
            "demo.typ", '#import "@preview/touying:0.5.3": *\n#show: slides\n'
        )
        matching = [item for item in issues if item.code == "DIRECT_TOUYING_PRE_0_6"]
        self.assertEqual(1, len(matching))
        self.assertEqual("advisory", matching[0].severity)

    def test_main_tcs_findings_are_review_level(self):
        issues = self._analyze(
            "main.typ",
            '#import "template.typ": *\n#show: theme\n#let red = rgb("#f00")\n',
        )
        matching = [item for item in issues if item.code == "TCS_INLINE_COLOR"]
        self.assertEqual(1, len(matching))
        self.assertEqual("review", matching[0].severity)

    def test_canvas_legal_blocks_and_primitives_do_not_trigger_tcs(self):
        issues = self._analyze(
            "main.typ",
            '#import "template.typ": *\n#show: theme\n'
            '#block(fill: palette.panel)[Canvas card]\n'
            '#rect(fill: palette.accent)\n#circle(fill: palette.accent)\n',
        )
        codes = {item.code for item in issues}
        self.assertNotIn("TCS_STYLED_BLOCK", codes)
        self.assertNotIn("TCS_DECORATIVE_PRIMITIVE", codes)

    def test_positive_stack_spacing_has_no_global_minimum(self):
        issues = self._analyze(
            "template.typ",
            "#stack(\n  dir: ttb,\n  spacing: .4em,\n  [A],\n  [B],\n)\n"
            "#stack([Label (2026)], spacing: .4em, [B])\n",
        )
        self.assertFalse(any(item.code.startswith("STACK_") for item in issues))

    def test_zero_spacing_stack_is_advisory_but_horizontal_is_ignored(self):
        issues = self._analyze(
            "template.typ",
            "#stack(spacing: 0pt, [bar], [body])\n"
            "#stack(dir: ltr, spacing: 0pt, [one], [two])\n"
            "#stack(spacing: .8em, [comfortable], [group])\n",
        )
        matching = [item for item in issues if item.code == "STACK_ZERO_SPACING_REVIEW"]
        self.assertEqual(1, len(matching))
        self.assertEqual("advisory", matching[0].severity)

    def test_positive_pt_and_em_spacing_are_left_to_rendered_review(self):
        issues = self._analyze(
            "template.typ",
            "#stack(spacing: 2pt, [A], [B])\n"
            "#stack(dir: direction, spacing: .3em, [A], [B])\n"
            "#stack(dir: ttb, spacing: .3em, [A], [B])\n",
        )
        self.assertFalse(any(item.code.startswith("STACK_") for item in issues))

    def test_negative_literal_spacing_is_reviewed(self):
        issues = self._analyze(
            "template.typ",
            "#stack(dir: btt, spacing: -1pt, [A], [B])\n"
            "#stack(spacing: -2mm, [A], [B])\n",
        )
        matching = [item for item in issues if item.code == "STACK_NEGATIVE_SPACING_REVIEW"]
        self.assertEqual(2, len(matching))
        self.assertTrue(all(item.severity == "review" for item in matching))

    def test_stack_spacing_ignores_comments_strings_and_raw(self):
        issues = self._analyze(
            "template.typ",
            '// #stack(spacing: .3em, [A], [B])\n'
            '#let example = "#stack(spacing: .3em, [A], [B])"\n'
            '```typst\n#stack(spacing: .3em, [A], [B])\n```\n',
        )
        self.assertFalse(any(item.code.startswith("STACK_") for item in issues))

    def test_metric_component_internal_v_is_not_a_static_finding(self):
        issues = self._analyze(
            "template.typ",
            "#let raw-stat(value, label) = {\n"
            "  align(center)[#value]\n"
            "  v(4pt)\n"
            "  align(center)[#label]\n"
            "}\n"
            "#let status-card(body) = { v(2pt); body }\n"
            "#let metric-card(value, label) = stack(\n"
            "  spacing: .8em, value, label,\n"
            ")\n",
        )
        self.assertNotIn("KPI_INTERNAL_V_SPACING", {item.code for item in issues})

    def test_metric_component_examples_do_not_produce_static_findings(self):
        issues = self._analyze(
            "template.typ",
            "// #let fake-stat() = v(1pt)\n"
            '#let example = "#let fake-kpi() = v(1pt)"\n'
            "#let metric-card(value) = { value; lazy-v(1fr) }\n",
        )
        self.assertNotIn(
            "KPI_INTERNAL_V_SPACING", {item.code for item in issues}
        )

    def test_raw_code_and_comments_do_not_trigger_tcs(self):
        issues = self._analyze(
            "main.typ",
            '#import "template.typ": *\n#show: theme\n'
            '// rgb("#f00") is shown below\n'
            '```typst\n#let red = rgb("#f00")\n```\n',
        )
        self.assertNotIn("TCS_INLINE_COLOR", {item.code for item in issues})

    def test_commented_breakable_does_not_satisfy_advisory(self):
        issues = self._analyze(
            "demo.typ",
            '#import "@preview/touying:0.7.4": *\n'
            '#show: touying-slides\n'
            '// breakable: false\n',
        )
        self.assertIn("AUTO_BREAK_REVIEW", {item.code for item in issues})


if __name__ == "__main__":
    unittest.main()

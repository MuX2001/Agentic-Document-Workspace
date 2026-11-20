import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path


SCRIPTS_DIR = Path(__file__).resolve().parents[1]
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

from validate_project import (
    check_component_usage,
    check_image_usage,
    check_inline_mitex,
    check_lazy_layout_cols,
    check_layout_diversity,
    check_theme_selection,
    check_touying_version,
    validate_project,
)
ANALYZER_SPEC = importlib.util.spec_from_file_location(
    "seaslides_typst_test_analyze_images", SCRIPTS_DIR / "analyze_images.py"
)
if ANALYZER_SPEC is None or ANALYZER_SPEC.loader is None:
    raise RuntimeError("Could not load analyze_images.py")
image_analyzer = importlib.util.module_from_spec(ANALYZER_SPEC)
ANALYZER_SPEC.loader.exec_module(image_analyzer)


class ValidateProjectTests(unittest.TestCase):
    def test_image_analyzer_includes_viewbox_only_svg_assets(self):
        with tempfile.TemporaryDirectory() as directory:
            images = Path(directory)
            (images / "dashboard.svg").write_text(
                '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1280 720"/>',
                encoding="utf-8",
            )

            results = image_analyzer.analyze_images(str(images))

            self.assertEqual(1, len(results))
            self.assertEqual((1280, 720), (results[0]["width"], results[0]["height"]))

    def test_image_usage_finds_bare_calls_after_commas_and_newlines(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            assets = project / "assets"
            assets.mkdir()
            (assets / "dashboard.svg").write_text(
                '<svg viewBox="0 0 100 50"/>', encoding="utf-8"
            )
            (project / "main.typ").write_text(
                '#stack(\n  spacing: 1em,\n  image("assets/dashboard.svg"),\n)\n',
                encoding="utf-8",
            )

            errors, warnings = check_image_usage(project)

            self.assertEqual([], errors)
            self.assertEqual([], warnings)

    def test_image_usage_ignores_calls_only_shown_in_comments_or_raw_text(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            assets = project / "assets"
            assets.mkdir()
            (assets / "dashboard.svg").write_text(
                '<svg viewBox="0 0 100 50"/>', encoding="utf-8"
            )
            (project / "main.typ").write_text(
                '// #image("assets/dashboard.svg")\n'
                '```typ\nimage("assets/dashboard.svg")\n```\n'
                '#let example = "image(assets/dashboard.svg)"\n',
                encoding="utf-8",
            )

            _, warnings = check_image_usage(project)

            self.assertEqual(1, len(warnings))
            self.assertIn("no image() calls", warnings[0])

    def test_lazy_checker_separates_definite_errors_from_reviews(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            (project / "main.typ").write_text(
                "#cols(lazy-layout: true)[#a() #b()][#card()]\n",
                encoding="utf-8",
            )
            (project / "template.typ").write_text(
                "#cols(lazy-layout: true, ..items.map(item => card(item)))\n",
                encoding="utf-8",
            )
            errors, warnings = check_lazy_layout_cols(project)
            self.assertEqual(1, len(errors))
            self.assertEqual(1, len(warnings))
            self.assertIn("ordinary cols", errors[0])
            self.assertNotIn("wrap the column contents into one stack", errors[0])

    def test_universe_old_touying_version_is_review_not_error(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory) / "templates" / "themes" / "universe" / "legacy"
            project.mkdir(parents=True)
            (project / "demo.typ").write_text(
                '#import "@preview/touying:0.5.3": *\n', encoding="utf-8"
            )
            errors, warnings = check_touying_version(project)
            self.assertEqual([], errors)
            self.assertTrue(any("UNIVERSE VERSION REVIEW" in item for item in warnings))

    def test_owned_old_touying_version_is_error(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            (project / "main.typ").write_text(
                '#import "@preview/touying:0.5.3": *\n', encoding="utf-8"
            )
            errors, _ = check_touying_version(project)
            self.assertTrue(any("WRONG VERSION" in item for item in errors))

    def test_inline_mitex_is_review_not_automatic_failure(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            (project / "main.typ").write_text(
                "A formula #mitex(`x`) appears here.\n", encoding="utf-8"
            )
            errors, warnings = check_inline_mitex(project)
            self.assertEqual([], errors)
            self.assertEqual(1, len(warnings))

    def test_layout_wrapped_mitex_is_display_content(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            (project / "main.typ").write_text(
                '#align(center)[#mitex(`x^2 + y^2`)]\n', encoding="utf-8"
            )

            errors, warnings = check_inline_mitex(project)

            self.assertEqual([], errors)
            self.assertEqual([], warnings)

    def test_theme_mode_does_not_require_delivery_outputs_or_spec(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            (project / "demo.typ").write_text(
                '#import "template.typ": *\n#show: theme\n', encoding="utf-8"
            )
            (project / "template.typ").write_text(
                '#import "@preview/touying:0.7.4": *\n#let theme = it => it\n',
                encoding="utf-8",
            )
            passed, result = validate_project(str(project), mode="theme")
            self.assertTrue(passed, result["errors"])
            self.assertNotIn("Output Files", result["checks"])
            self.assertNotIn("Design Spec", result["checks"])

    def test_quick_mode_requires_delivery_outputs_but_not_spec(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            (project / "main.typ").write_text(
                '#import "template.typ": *\n#show: theme\n== Intro\n#speaker-note[Intro.]\n',
                encoding="utf-8",
            )
            (project / "template.typ").write_text(
                '#import "@preview/touying:0.7.4": *\n#let theme = it => it\n',
                encoding="utf-8",
            )

            passed, result = validate_project(str(project), mode="quick")
            self.assertFalse(passed)
            self.assertIn("Output Files", result["checks"])
            self.assertNotIn("Design Spec", result["checks"])

            output = project / "output"
            pngs = output / "pngs"
            pngs.mkdir(parents=True)
            (output / "slides.pdf").write_bytes(b"%PDF-1.4\n%%EOF\n")
            (output / "overview.png").write_bytes(b"png")
            (pngs / "slide_01.png").write_bytes(b"png")

            passed, result = validate_project(str(project), mode="quick")
            self.assertFalse(passed)
            self.assertTrue(
                any("compile-manifest.json" in error for error in result["errors"])
            )

            (output / "compile-manifest.json").write_text("{}", encoding="utf-8")

            passed, result = validate_project(str(project), mode="quick", strict=True)
            self.assertTrue(passed, result["errors"])

    def test_quick_mode_does_not_assume_rich_without_spec(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            (project / "main.typ").write_text(
                "== One\n#speaker-note[One.]\n"
                "== Two\n#speaker-note[Two.]\n"
                "== Three\n#speaker-note[Three.]\n",
                encoding="utf-8",
            )

            _, component_warnings = check_component_usage(project, mode="quick")
            _, layout_warnings = check_layout_diversity(project, mode="quick")

            self.assertFalse(
                any("COMPONENT REVIEW" in warning for warning in component_warnings)
            )
            self.assertFalse(any("DENSITY REVIEW" in warning for warning in layout_warnings))

    def test_quick_mode_requires_slide_pngs(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            (project / "main.typ").write_text(
                '#import "template.typ": *\n#show: theme\n== Intro\n#speaker-note[Intro.]\n',
                encoding="utf-8",
            )
            (project / "template.typ").write_text(
                '#import "@preview/touying:0.7.4": *\n#let theme = it => it\n',
                encoding="utf-8",
            )
            output = project / "output"
            output.mkdir()
            (output / "slides.pdf").write_bytes(b"%PDF-1.4\n%%EOF\n")
            (output / "overview.png").write_bytes(b"png")
            (output / "compile-manifest.json").write_text("{}", encoding="utf-8")

            passed, result = validate_project(str(project), mode="quick")

            self.assertFalse(passed)
            self.assertTrue(any("output/pngs/" in error for error in result["errors"]))

    def test_quick_builtin_warning_does_not_require_design_spec(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            (project / "main.typ").write_text(
                "#show: themes.simple\n", encoding="utf-8"
            )

            _, warnings = check_theme_selection(project, mode="quick")

            self.assertTrue(any("THEME REVIEW" in warning for warning in warnings))
            self.assertFalse(any("design spec" in warning.lower() for warning in warnings))

    def test_nested_workspace_entry_is_used_by_all_entry_checks(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            entry = project / "slides" / "deck.typ"
            entry.parent.mkdir()
            entry.write_text(
                '#import "../template.typ": *\n#show: theme\n',
                encoding="utf-8",
            )
            (project / "template.typ").write_text(
                '#import "@preview/touying:0.7.4": *\n#let theme = it => it\n',
                encoding="utf-8",
            )

            passed, result = validate_project(
                str(project),
                mode="theme",
                entry="slides/deck.typ",
            )

            self.assertTrue(passed, result["errors"])
            self.assertEqual("slides/deck.typ", result["entry"])
            self.assertFalse(any("Neither main.typ" in item for item in result["errors"]))

    def test_validation_entry_cannot_escape_workspace(self):
        with tempfile.TemporaryDirectory() as directory:
            parent = Path(directory)
            project = parent / "workspace"
            project.mkdir()
            (parent / "outside.typ").write_text("= Outside\n", encoding="utf-8")

            with self.assertRaisesRegex(ValueError, "stay inside the workspace"):
                validate_project(str(project), mode="theme", entry="../outside.typ")


if __name__ == "__main__":
    unittest.main()

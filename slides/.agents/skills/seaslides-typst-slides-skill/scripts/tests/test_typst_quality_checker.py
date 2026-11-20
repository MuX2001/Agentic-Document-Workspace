import sys
import tempfile
import hashlib
import json
import os
import time
import unittest
from io import BytesIO
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

from PIL import Image


SCRIPTS_DIR = Path(__file__).resolve().parents[1]
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

import typst_quality_checker as checker


class FakeTypst:
    def __init__(self, warnings=None, pages=2, compile_error=None):
        self.warnings = warnings or []
        self.pages = pages
        self.compile_error = compile_error

    def compile_with_warnings(self, input, format):
        if self.compile_error:
            raise self.compile_error
        return b"%PDF-test", self.warnings

    def compile(self, input, format, ppi=None):
        if self.compile_error:
            raise self.compile_error
        if format == "png":
            return [b"png"] * self.pages
        return b"%PDF-test"


class QualityCheckerTests(unittest.TestCase):
    def _project(self):
        temporary = tempfile.TemporaryDirectory()
        project = Path(temporary.name)
        (project / "main.typ").write_text(
            '#import "template.typ": *\n#show: theme\n', encoding="utf-8"
        )
        return temporary, project

    def _rendered_artifacts(self, project, pages=2, entry="main.typ"):
        output = project / "output"
        pngs = output / "pngs"
        pngs.mkdir(parents=True)
        image_bytes = BytesIO()
        Image.new("RGB", (2, 2), "white").save(image_bytes, format="PNG")
        png_bytes = image_bytes.getvalue()
        (output / "slides.pdf").write_bytes(b"%PDF-1.4\n%%EOF\n")
        (output / "overview.png").write_bytes(png_bytes)
        for number in range(1, pages + 1):
            (pngs / ("slide_%d.png" % number)).write_bytes(png_bytes)
        self._refresh_manifest(project, pages, entry=entry)

    def _refresh_manifest(self, project, pages, entry="main.typ"):
        def record(path):
            return {
                "path": str(path.relative_to(project)),
                "size": path.stat().st_size,
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }

        artifacts = [project / "output" / "slides.pdf", project / "output" / "overview.png"]
        artifacts.extend(
            project / "output" / "pngs" / ("slide_%d.png" % number)
            for number in range(1, pages + 1)
        )
        entry_path = project / entry
        payload = {
            "schema_version": 1,
            "tool": "typst_compiler.py",
            "completed_at": "test",
            "entry": entry,
            "entry_sha256": hashlib.sha256(entry_path.read_bytes()).hexdigest(),
            "page_count": pages,
            "artifacts": [record(path) for path in artifacts],
        }
        (project / "output" / "compile-manifest.json").write_text(
            json.dumps(payload), encoding="utf-8"
        )

    def test_review_warning_passes_default_gate(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        self._rendered_artifacts(project)
        warning = SimpleNamespace(
            message="unknown font family: Missing",
            diagnostic="main.typ:1:1: warning: unknown font family: Missing",
        )
        with patch.object(checker, "typst", FakeTypst(warnings=[warning], pages=2)):
            result = checker.audit_project(str(project), expected_pages=2)
        self.assertEqual("review", result["status"])
        self.assertFalse(result["quality_gate"]["failed"])
        self.assertEqual(
            b"%PDF-1.4\n%%EOF\n",
            (project / "output" / "slides.pdf").read_bytes(),
        )

    def test_duplicate_compiler_warnings_are_aggregated(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        self._rendered_artifacts(project)
        warning = SimpleNamespace(
            message="unknown font family: Missing",
            diagnostic="main.typ:1:1: warning: unknown font family: Missing",
        )
        with patch.object(checker, "typst", FakeTypst(warnings=[warning, warning], pages=2)):
            result = checker.audit_project(str(project))
        findings = [item for item in result["diagnostics"] if item.code == "FONT_FALLBACK"]
        self.assertEqual(1, len(findings))
        self.assertEqual(2, findings[0].occurrences)
        self.assertEqual(
            result["unique_diagnostic_count"] + 1,
            result["diagnostic_occurrence_count"],
        )

    def test_expected_page_mismatch_is_blocker(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        self._rendered_artifacts(project, pages=3)
        with patch.object(checker, "typst", FakeTypst(pages=3)):
            result = checker.audit_project(str(project), expected_pages=2)
        self.assertEqual("fail", result["status"])
        self.assertFalse(result["incomplete"])
        self.assertTrue(result["quality_gate"]["failed"])
        self.assertIn("EXPECTED_PAGE_COUNT_MISMATCH", result["code_counts"])

    def test_compile_error_marks_audit_incomplete(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        with patch.object(
            checker,
            "typst",
            FakeTypst(compile_error=RuntimeError("synthetic compile failure")),
        ):
            result = checker.audit_project(str(project))
        self.assertEqual("incomplete", result["status"])
        self.assertTrue(result["incomplete"])
        self.assertIn("COMPILE_ERROR", result["code_counts"])

    def test_page_count_never_falls_back_to_stale_pngs(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        stale = project / "output" / "pngs"
        stale.mkdir(parents=True)
        (stale / "slide-01.png").write_bytes(b"stale")
        fake = FakeTypst(pages=2)

        def fail_png(input, format, ppi=None):
            if format == "png":
                raise RuntimeError("png probe failed")
            return b"%PDF-test"

        fake.compile = fail_png
        with patch.object(checker, "typst", fake):
            result = checker.audit_project(str(project))
        self.assertIsNone(result["page_count"])
        self.assertTrue(result["incomplete"])
        self.assertIn("PAGE_COUNT_UNAVAILABLE", result["code_counts"])

    def test_missing_overview_fails_output_contract(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        self._rendered_artifacts(project)
        (project / "output" / "overview.png").unlink()
        with patch.object(checker, "typst", FakeTypst(pages=2)):
            result = checker.audit_project(str(project))
        self.assertEqual("fail", result["status"])
        self.assertFalse(result["incomplete"])
        self.assertTrue(result["quality_gate"]["failed"])
        self.assertIn("MISSING_OVERVIEW_OUTPUT", result["code_counts"])

    def test_stale_png_set_or_count_mismatch_fails_output_contract(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        self._rendered_artifacts(project, pages=1)
        with patch.object(checker, "typst", FakeTypst(pages=2)):
            result = checker.audit_project(str(project))
        self.assertEqual("fail", result["status"])
        self.assertIn("PNG_PAGE_COUNT_MISMATCH", result["code_counts"])

    def test_artifacts_older_than_entry_fail_output_contract(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        self._rendered_artifacts(project)
        future = time.time() + 10
        os.utime(project / "main.typ", (future, future))
        with patch.object(checker, "typst", FakeTypst(pages=2)):
            result = checker.audit_project(str(project))
        self.assertEqual("fail", result["status"])
        self.assertIn("STALE_RENDER_OUTPUT", result["code_counts"])

    def test_artifacts_older_than_recursive_import_or_asset_fail_contract(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        (project / "template.typ").write_text('#import "parts.typ": *\n', encoding="utf-8")
        (project / "parts.typ").write_text('#let logo = image("assets/logo.png")\n', encoding="utf-8")
        (project / "assets").mkdir()
        asset = project / "assets" / "logo.png"
        asset.write_bytes(b"asset")
        self._rendered_artifacts(project)
        future = time.time() + 10
        os.utime(asset, (future, future))
        with patch.object(checker, "typst", FakeTypst(pages=2)):
            result = checker.audit_project(str(project))
        self.assertEqual("fail", result["status"])
        self.assertIn("STALE_RENDER_OUTPUT", result["code_counts"])

    def test_png_names_must_be_contiguous_and_unique(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        self._rendered_artifacts(project)
        pngs = project / "output" / "pngs"
        (pngs / "slide_2.png").unlink()
        (pngs / "slide_99.png").write_bytes(b"png")
        with patch.object(checker, "typst", FakeTypst(pages=2)):
            result = checker.audit_project(str(project))
        self.assertIn("PNG_PAGE_SEQUENCE_MISMATCH", result["code_counts"])

    def test_corrupt_existing_render_artifact_is_blocker(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        self._rendered_artifacts(project)
        (project / "output" / "pngs" / "slide_1.png").write_bytes(b"not a png")
        with patch.object(checker, "typst", FakeTypst(pages=2)):
            result = checker.audit_project(str(project))
        self.assertEqual("fail", result["status"])
        self.assertIn("CORRUPT_RENDER_OUTPUT", result["code_counts"])

    def test_missing_compile_manifest_is_blocker(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        self._rendered_artifacts(project)
        (project / "output" / "compile-manifest.json").unlink()
        with patch.object(checker, "typst", FakeTypst(pages=2)):
            result = checker.audit_project(str(project))
        self.assertEqual("fail", result["status"])
        self.assertIn("MISSING_COMPILE_MANIFEST", result["code_counts"])

    def test_checker_never_overwrites_existing_pdf(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        self._rendered_artifacts(project)
        pdf = project / "output" / "slides.pdf"
        existing_pdf = b"%PDF-1.4\n% existing\n%%EOF\n"
        pdf.write_bytes(existing_pdf)
        self._refresh_manifest(project, 2)
        with patch.object(checker, "typst", FakeTypst(pages=2)):
            result = checker.audit_project(str(project))
        self.assertFalse(result["quality_gate"]["failed"])
        self.assertEqual(existing_pdf, pdf.read_bytes())

    def test_missing_warning_capture_is_complete_review(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        self._rendered_artifacts(project)

        class NoWarningCaptureTypst:
            def compile(self, input, format, ppi=None):
                return [b"png"] * 2 if format == "png" else b"%PDF-test"

        with patch.object(checker, "typst", NoWarningCaptureTypst()):
            result = checker.audit_project(str(project))
        self.assertEqual("review", result["status"])
        self.assertFalse(result["incomplete"])
        self.assertFalse(result["quality_gate"]["failed"])
        self.assertEqual("review", next(
            item.severity for item in result["diagnostics"]
            if item.code == "WARNING_CAPTURE_UNAVAILABLE"
        ))

    def test_demo_does_not_apply_global_positive_stack_minimum(self):
        temporary, project = self._project()
        self.addCleanup(temporary.cleanup)
        (project / "demo.typ").write_text(
            '#import "template.typ": *\n#show: theme\n', encoding="utf-8"
        )
        (project / "template.typ").write_text(
            '#let metric = stack(spacing: .4em, [value], [label])\n'
            '#let stat-card(value, label) = { value; v(3pt); label }\n',
            encoding="utf-8",
        )
        self._rendered_artifacts(project, entry="demo.typ")
        with patch.object(checker, "typst", FakeTypst(pages=2)):
            result = checker.audit_project(str(project), entry="demo.typ")
        self.assertFalse(any(code.startswith("STACK_") for code in result["code_counts"]))
        self.assertNotIn("NO_IMPORT_DIRECTIVE", result["code_counts"])
        self.assertNotIn("NO_SHOW_DIRECTIVE", result["code_counts"])

    def test_nested_entry_uses_workspace_root_artifacts(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        project = Path(temporary.name)
        entry = project / "slides" / "deck.typ"
        entry.parent.mkdir()
        entry.write_text("= Deck\n", encoding="utf-8")
        self._rendered_artifacts(project, entry="slides/deck.typ")

        with patch.object(checker, "typst", FakeTypst(pages=2)):
            result = checker.audit_project(
                str(project),
                entry="slides/deck.typ",
                include_static=False,
            )

        self.assertFalse(result["incomplete"])
        self.assertFalse(result["quality_gate"]["failed"])
        self.assertEqual(
            str(project.resolve() / "output" / "slides.pdf"),
            result["output_pdf"],
        )

    def test_entry_cannot_escape_workspace(self):
        with tempfile.TemporaryDirectory() as directory:
            parent = Path(directory)
            workspace = parent / "workspace"
            workspace.mkdir()
            (parent / "outside.typ").write_text("= Outside\n", encoding="utf-8")

            with self.assertRaisesRegex(ValueError, "stay inside the workspace"):
                checker.audit_project(str(workspace), entry="../outside.typ")


if __name__ == "__main__":
    unittest.main()

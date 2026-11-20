import sys
import tempfile
import types
import unittest
import math
import json
from pathlib import Path
from unittest.mock import patch


SCRIPTS_DIR = Path(__file__).resolve().parents[1]
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

import typst_compiler as compiler


class FakeTypstError(Exception):
    def __init__(self, message):
        super().__init__(message)
        self.message = message
        self.diagnostic = message
        self.hints = None
        self.trace = None


class FakeTypst:
    TypstError = FakeTypstError

    def __init__(self, fail=False, pages=2):
        self.fail = fail
        self.pages = pages

    def compile(self, input, output=None, format=None, ppi=None):
        if self.fail:
            raise FakeTypstError("synthetic failure")
        if format == "pdf":
            return b"%PDF-1.4\n%%EOF\n"
        for number in range(1, self.pages + 1):
            Path(output.replace("{n}", str(number))).write_bytes(b"png-%d" % number)
        return None


class TypstCompilerTests(unittest.TestCase):
    @staticmethod
    def fake_typ2pptx_modules(run, convert):
        converter = types.ModuleType("typ2pptx.core.converter")
        converter.subprocess = types.SimpleNamespace(run=run)
        converter.convert_typst_to_pptx = convert
        core = types.ModuleType("typ2pptx.core")
        core.converter = converter
        package = types.ModuleType("typ2pptx")
        package.core = core
        return converter, {
            "typ2pptx": package,
            "typ2pptx.core": core,
            "typ2pptx.core.converter": converter,
        }

    def test_numeric_collector_ignores_user_named_pngs(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in ("slide_10.png", "slide_2.png", "slide_notes.png", "notes.png"):
                (root / name).write_bytes(b"x")
            collected = compiler._collect_generated_pngs(root / "slide_{n}.png")
            self.assertEqual(["slide_2.png", "slide_10.png"], [item.name for item in collected])

    def test_failed_png_compile_preserves_existing_outputs(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "main.typ"
            source.write_text("= Test\n", encoding="utf-8")
            output = root / "output" / "pngs" / "slide_{n}.png"
            output.parent.mkdir(parents=True)
            (output.parent / "slide_1.png").write_bytes(b"old")
            (output.parent / "notes.png").write_bytes(b"user")
            with patch.object(compiler, "typst", FakeTypst(fail=True)):
                with self.assertRaises(SystemExit):
                    compiler.compile_to_png(source, output)
            self.assertEqual(b"old", (output.parent / "slide_1.png").read_bytes())
            self.assertEqual(b"user", (output.parent / "notes.png").read_bytes())

    def test_successful_png_publish_replaces_only_numbered_pages(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "main.typ"
            source.write_text("= Test\n", encoding="utf-8")
            output = root / "output" / "pngs" / "slide_{n}.png"
            output.parent.mkdir(parents=True)
            (output.parent / "slide_1.png").write_bytes(b"old")
            (output.parent / "slide_notes.png").write_bytes(b"user")
            with patch.object(compiler, "typst", FakeTypst(pages=2)):
                result = compiler.compile_to_png(source, output)
            self.assertEqual(2, len(result))
            self.assertEqual(b"png-1", (output.parent / "slide_1.png").read_bytes())
            self.assertEqual(b"png-2", (output.parent / "slide_2.png").read_bytes())
            self.assertEqual(b"user", (output.parent / "slide_notes.png").read_bytes())

    def test_pdf_publish_uses_in_memory_bytes(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "main.typ"
            source.write_text("= Test\n", encoding="utf-8")
            output = root / "output" / "slides.pdf"
            with patch.object(compiler, "typst", FakeTypst()):
                compiler.compile_to_pdf(source, output)
            self.assertTrue(output.read_bytes().startswith(b"%PDF-"))

    def test_pptx_overwrite_guard_does_not_patch_subprocess(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "main.typ"
            output = root / "slides.pptx"
            source.write_text("= Test\n", encoding="utf-8")
            output.write_bytes(b"user-owned")

            def original_run(*args, **kwargs):
                return None

            converter, modules = self.fake_typ2pptx_modules(
                original_run,
                lambda *args, **kwargs: None,
            )
            original_subprocess = converter.subprocess
            with patch.dict(sys.modules, modules):
                with self.assertRaises(SystemExit):
                    compiler.compile_to_pptx(source, output)

            self.assertIs(original_subprocess, converter.subprocess)

    def test_pptx_subprocess_patch_is_scoped_and_uses_utf8(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "main.typ"
            output = root / "slides.pptx"
            source.write_text("= Test\n", encoding="utf-8")
            captured = {}

            def original_run(*args, **kwargs):
                captured.update(kwargs)
                return types.SimpleNamespace(returncode=0, stdout="", stderr="")

            converter = None

            def convert(_source, destination, root=None):
                converter.subprocess.run(["typst-ts-cli"], text=True)
                Path(destination).write_bytes(b"pptx")

            converter, modules = self.fake_typ2pptx_modules(original_run, convert)
            original_subprocess = converter.subprocess
            with patch.dict(sys.modules, modules):
                compiler.compile_to_pptx(source, output)

            self.assertEqual("utf-8", captured["encoding"])
            self.assertEqual("replace", captured["errors"])
            self.assertIs(original_subprocess, converter.subprocess)
            self.assertEqual(b"pptx", output.read_bytes())

    def test_overview_grid_scale_respects_requested_bounds(self):
        columns, scale = compiler._find_best_grid_layout(
            total_pages=80,
            probe_page_w=640,
            probe_page_h=360,
            gutter=8,
            max_width=600,
            max_height=400,
        )
        rows = math.ceil(80 / columns)
        self.assertLessEqual(columns * 640 * scale + (columns + 1) * 8, 600)
        self.assertLessEqual(rows * 360 * scale + (rows + 1) * 8, 400)

    def test_compile_manifest_records_one_canonical_artifact_set(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory)
            output = project / "output"
            pngs = output / "pngs"
            pngs.mkdir(parents=True)
            entry = project / "demo.typ"
            entry.write_text("= Test\n", encoding="utf-8")
            pdf = output / "slides.pdf"
            overview = output / "overview.png"
            slide = pngs / "slide_1.png"
            pdf.write_bytes(b"%PDF-test")
            overview.write_bytes(b"overview")
            slide.write_bytes(b"slide")
            manifest = compiler._write_compile_manifest(
                project,
                entry,
                {"pdf": str(pdf), "overview": str(overview), "png": [str(slide)]},
            )
            payload = json.loads(Path(manifest).read_text(encoding="utf-8"))
            self.assertEqual("demo.typ", payload["entry"])
            self.assertEqual(1, payload["page_count"])
            self.assertEqual(3, len(payload["artifacts"]))

    def test_nested_entry_keeps_outputs_at_workspace_root(self):
        with tempfile.TemporaryDirectory() as directory:
            workspace = Path(directory)
            entry = workspace / "slides" / "deck.typ"
            entry.parent.mkdir()
            entry.write_text("= Test\n", encoding="utf-8")
            with patch.object(
                compiler,
                "compile_to_pdf",
                return_value=str(workspace / "output" / "slides.pdf"),
            ) as compile_pdf:
                compiler.compile_project(
                    workspace,
                    output_format="pdf",
                    entry="slides/deck.typ",
                )

            compile_pdf.assert_called_once_with(
                entry.resolve(),
                workspace.resolve() / "output" / "slides.pdf",
            )

    def test_entry_cannot_escape_workspace(self):
        with tempfile.TemporaryDirectory() as directory:
            parent = Path(directory)
            workspace = parent / "workspace"
            workspace.mkdir()
            (parent / "outside.typ").write_text("= Outside\n", encoding="utf-8")

            with self.assertRaisesRegex(ValueError, "stay inside the workspace"):
                compiler.compile_project(workspace, entry="../outside.typ")


if __name__ == "__main__":
    unittest.main()

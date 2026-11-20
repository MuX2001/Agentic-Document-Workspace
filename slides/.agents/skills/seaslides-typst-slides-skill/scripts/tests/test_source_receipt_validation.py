"""Regression coverage for Typst source-conversion receipt consumption."""

import hashlib
import importlib.util
import json
import sys
import tempfile
import types
import unittest
from pathlib import Path


SCRIPTS_DIR = Path(__file__).resolve().parents[1]
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))


def load_script(module_name: str, filename: str):
    spec = importlib.util.spec_from_file_location(module_name, SCRIPTS_DIR / filename)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Could not load {filename}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[module_name] = module
    spec.loader.exec_module(module)
    return module


validator = load_script("typst_source_receipt_validator", "validate_project.py")
if "analyze_images" not in sys.modules:
    image_module = types.ModuleType("analyze_images")
    image_module.analyze_images = lambda *_args, **_kwargs: []
    sys.modules["analyze_images"] = image_module
inventory = load_script("typst_source_receipt_inventory", "source_inventory.py")
project_utils = load_script("typst_source_receipt_project_utils", "project_utils.py")


def fingerprint(path: Path) -> dict:
    data = path.read_bytes()
    return {
        "kind": "file",
        "path": path.name,
        "sha256": hashlib.sha256(data).hexdigest(),
        "size_bytes": len(data),
    }


class SourceReceiptValidationTests(unittest.TestCase):
    def make_receipt(self, root: Path, *, source_kind: str = "file") -> tuple[Path, dict]:
        sources = root / "sources"
        sources.mkdir(parents=True)
        output = sources / "converted.md"
        output.write_text("# Converted\n", encoding="utf-8")
        payload = {
            "schema": "seaslides-source-conversion/v1",
            "status": "pass",
            "converter": {"name": "doc_to_md", "version": "1.0"},
            "warnings": [],
            "output": fingerprint(output),
        }
        if source_kind == "file":
            source = sources / "original.txt"
            source.write_text("original", encoding="utf-8")
            payload["source"] = fingerprint(source)
        else:
            payload["source"] = {
                "kind": "url",
                "uri": "https://example.com/article",
                "sha256": "a" * 64,
                "size_bytes": 42,
            }
        receipt = sources / "converted.md.receipt.json"
        receipt.write_text(json.dumps(payload), encoding="utf-8")
        return receipt, payload

    def receipt_errors(self, root: Path) -> list[str]:
        return validator.check_source_conversion_receipts(root)[0]

    def test_receipts_are_optional_and_valid_local_or_url_receipts_pass(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "sources").mkdir()
            self.assertEqual([], self.receipt_errors(root))
            self.make_receipt(root / "local")
            self.assertEqual([], self.receipt_errors(root / "local"))
            self.make_receipt(root / "url", source_kind="url")
            self.assertEqual([], self.receipt_errors(root / "url"))

    def test_bad_fingerprint_has_no_stale_duplicate_and_empty_output_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            receipt, payload = self.make_receipt(root)
            payload["output"]["sha256"] = "bad"
            receipt.write_text(json.dumps(payload), encoding="utf-8")
            errors = self.receipt_errors(root)
            self.assertEqual(1, sum("output.sha256" in error for error in errors))
            self.assertFalse(any("output changed" in error for error in errors))

            output = root / "sources" / "converted.md"
            output.write_text("", encoding="utf-8")
            payload["output"] = fingerprint(output)
            receipt.write_text(json.dumps(payload), encoding="utf-8")
            self.assertTrue(any("output is empty" in error for error in self.receipt_errors(root)))

    def test_schema_status_warnings_paths_and_symlinks_are_checked(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            receipt, payload = self.make_receipt(root)
            payload.update({"schema": "wrong", "status": "pass_with_warnings", "warnings": []})
            payload["source"]["path"] = "../../outside.txt"
            receipt.write_text(json.dumps(payload), encoding="utf-8")
            errors = self.receipt_errors(root)
            self.assertTrue(any("unsupported schema" in error for error in errors))
            self.assertTrue(any("requires at least one warning" in error for error in errors))
            self.assertTrue(any("escapes sources" in error for error in errors))

            external = root / "outside.txt"
            external.write_text("outside", encoding="utf-8")
            link = root / "sources" / "linked.txt"
            try:
                link.symlink_to(external)
            except OSError as error:  # pragma: no cover - unavailable on constrained platforms
                self.skipTest(f"symlinks unavailable: {error}")
            payload["source"] = fingerprint(link)
            receipt.write_text(json.dumps(payload), encoding="utf-8")
            self.assertTrue(any("escapes sources" in error for error in self.receipt_errors(root)))

    def test_inventory_and_source_count_ignore_receipts_hidden_temporary_and_lock_files(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory) / "deck"
            sources = project / "sources"
            (sources / ".cache").mkdir(parents=True)
            (sources / "notes.md").write_text("Useful source", encoding="utf-8")
            (sources / "compile.receipt.json").write_text("{}", encoding="utf-8")
            (sources / "partial.md.tmp").write_text("partial", encoding="utf-8")
            (sources / "~$lock.md").write_text("lock", encoding="utf-8")
            (sources / ".cache" / "hidden.md").write_text("hidden", encoding="utf-8")

            self.assertEqual(1, project_utils.get_project_info(str(project))["source_count"])
            report = inventory.build_inventory(sources)
            self.assertIn("notes.md", report)
            for unwanted in ("receipt.json", "partial.md.tmp", "~$lock.md", "hidden.md"):
                self.assertNotIn(unwanted, report)

    def test_theme_mode_receipt_check_does_not_require_sources(self):
        with tempfile.TemporaryDirectory() as directory:
            _, result = validator.validate_project(directory, mode="theme")
            self.assertEqual([], result["checks"]["Source Conversion Receipts"]["errors"])


if __name__ == "__main__":
    unittest.main()

import io
import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from contextlib import redirect_stdout
from unittest.mock import patch


SCRIPTS_DIR = Path(__file__).resolve().parents[1]
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

import batch_validate


class BatchValidateTests(unittest.TestCase):
    def _project(self, root):
        project = root / "sample_20260801"
        project.mkdir()
        (project / "main.typ").write_text("#import \"template.typ\": *\n", encoding="utf-8")
        (project / "template.typ").write_text("#let theme = it => it\n", encoding="utf-8")
        (project / "content_design_spec.md").write_text("# Spec\n", encoding="utf-8")
        (project / "assets").mkdir()
        (project / "output").mkdir()
        return project

    def test_no_compile_is_explicitly_not_applicable(self):
        with tempfile.TemporaryDirectory() as directory:
            project = self._project(Path(directory))
            validator = batch_validate.BatchValidator(directory, do_compile=False)
            result = validator.validate_single(project)
            self.assertTrue(result["structure_valid"])
            self.assertFalse(result["compile_requested"])
            self.assertIsNone(result["semantic_valid"])
            self.assertIn("--no-compile", result["compile_message"])
            validator.results = [result]
            output = io.StringIO()
            with redirect_stdout(output):
                validator.print_summary()
            self.assertIn("◌ N/A", output.getvalue())
            self.assertIn("1 not fully validated", output.getvalue())

    def test_compile_delegates_to_public_all_pipeline(self):
        with tempfile.TemporaryDirectory() as directory:
            project = self._project(Path(directory))
            validator = batch_validate.BatchValidator(directory)
            completed = SimpleNamespace(returncode=0, stdout="ok", stderr="")
            with patch.object(batch_validate.subprocess, "run", return_value=completed) as run:
                success, _ = validator.compile_project(project)
            self.assertTrue(success)
            command = run.call_args.args[0]
            self.assertEqual(sys.executable, command[0])
            self.assertEqual(str(batch_validate.COMPILER_SCRIPT), command[1])
            self.assertEqual("--all", command[-1])

    def test_successful_compile_runs_default_blocker_quality_gate(self):
        with tempfile.TemporaryDirectory() as directory:
            project = self._project(Path(directory))
            validator = batch_validate.BatchValidator(directory)
            quality = {
                "status": "review",
                "quality_gate": {"failed": False},
                "code_counts": {"FONT_FALLBACK": 1},
                "severity_counts": {"blocker": 0, "review": 1, "advisory": 0},
            }
            semantic = (True, {"errors": [], "warnings": []})
            with patch.object(validator, "compile_project", return_value=(True, "ok")), \
                    patch.object(batch_validate, "validate_delivery_project", return_value=semantic), \
                    patch.object(batch_validate, "run_quality_audit", return_value=quality) as audit:
                result = validator.validate_single(project)
            audit.assert_called_once_with(project)
            self.assertEqual("review", result["quality_status"])
            self.assertFalse(result["quality_failed"])
            self.assertEqual({"FONT_FALLBACK": 1}, result["quality_code_counts"])

    def test_quality_exception_is_isolated_to_the_project(self):
        with tempfile.TemporaryDirectory() as directory:
            project = self._project(Path(directory))
            validator = batch_validate.BatchValidator(directory)
            semantic = (True, {"errors": [], "warnings": []})
            with patch.object(validator, "compile_project", return_value=(True, "ok")), \
                    patch.object(batch_validate, "validate_delivery_project", return_value=semantic), \
                    patch.object(batch_validate, "run_quality_audit", side_effect=RuntimeError("boom")):
                result = validator.validate_single(project)
            self.assertTrue(result["quality_failed"])
            self.assertEqual("incomplete", result["quality_status"])
            self.assertEqual({"QUALITY_AUDIT_EXCEPTION": 1}, result["quality_code_counts"])
            self.assertIn("boom", result["quality_message"])

    def test_delivery_validation_exception_is_isolated_to_the_project(self):
        with tempfile.TemporaryDirectory() as directory:
            project = self._project(Path(directory))
            validator = batch_validate.BatchValidator(directory)
            quality = {
                "status": "pass",
                "quality_gate": {"failed": False},
                "code_counts": {},
                "severity_counts": {"blocker": 0, "review": 0, "advisory": 0},
            }
            with patch.object(validator, "compile_project", return_value=(True, "ok")), \
                    patch.object(batch_validate, "validate_delivery_project", side_effect=RuntimeError("bad spec")), \
                    patch.object(batch_validate, "run_quality_audit", return_value=quality):
                result = validator.validate_single(project)
            self.assertFalse(result["semantic_valid"])
            self.assertIn("bad spec", result["semantic_errors"][0])
            self.assertFalse(result["quality_failed"])

    def test_quality_blocker_is_a_batch_failure(self):
        result = {
            "structure_valid": True,
            "compile_success": True,
            "compile_requested": True,
            "semantic_valid": True,
            "quality_failed": True,
        }
        self.assertFalse(batch_validate.result_gate_passed(result))


if __name__ == "__main__":
    unittest.main()

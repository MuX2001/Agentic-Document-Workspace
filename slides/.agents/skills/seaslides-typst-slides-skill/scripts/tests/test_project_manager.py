import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock


SCRIPT = Path(__file__).resolve().parents[1] / "project_manager.py"
SPEC = importlib.util.spec_from_file_location("seaslides_typst_project_manager", SCRIPT)
if SPEC is None or SPEC.loader is None:
    raise RuntimeError("Could not load project_manager.py")
project_manager = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(project_manager)


class ProjectManagerImportTests(unittest.TestCase):
    def test_attach_existing_workspace_does_not_create_a_child_project(self):
        with tempfile.TemporaryDirectory() as directory:
            workspace = Path(directory)
            entry = workspace / "slides" / "deck.typ"
            entry.parent.mkdir()
            entry.write_text("= Deck\n", encoding="utf-8")

            summary = project_manager.ProjectManager().attach_workspace(
                str(workspace),
                entry="slides/deck.typ",
                prepare=True,
            )

            self.assertEqual(str(workspace.resolve()), summary["workspace"])
            self.assertEqual("slides/deck.typ", summary["entry"])
            self.assertTrue(summary["prepared"])
            self.assertFalse((workspace / "projects").exists())

    def test_workspace_cli_reports_machine_readable_context(self):
        with tempfile.TemporaryDirectory() as directory:
            workspace = Path(directory)
            (workspace / "deck.typ").write_text("= Deck\n", encoding="utf-8")

            result = subprocess.run(
                [
                    sys.executable,
                    str(SCRIPT),
                    "workspace",
                    str(workspace),
                    "--entry",
                    "deck.typ",
                    "--prepare",
                    "--json",
                ],
                capture_output=True,
                text=True,
                check=False,
            )

            self.assertEqual(0, result.returncode, result.stdout + result.stderr)
            payload = json.loads(result.stdout)
            self.assertEqual(str(workspace.resolve()), payload["workspace"])
            self.assertEqual("deck.typ", payload["entry"])
            self.assertTrue(payload["prepared"])

    def test_exact_name_omits_date_and_stays_inside_base_directory(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory) / "projects"
            manager = project_manager.ProjectManager(str(base))

            project = Path(manager.init_project("../../audit deck", exact_name=True))

            self.assertEqual(base.resolve(), project.parent.resolve())
            self.assertEqual("audit_deck", project.name)

    def test_cli_help_and_exact_name(self):
        help_result = subprocess.run(
            [sys.executable, str(SCRIPT), "--help"],
            capture_output=True,
            text=True,
            check=False,
        )
        self.assertEqual(0, help_result.returncode)
        self.assertIn("--exact-name", help_result.stdout)

        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory) / "projects"
            result = subprocess.run(
                [
                    sys.executable, str(SCRIPT), "init", "stable-deck",
                    "--dir", str(base), "--exact-name",
                ],
                capture_output=True,
                text=True,
                check=False,
            )
            self.assertEqual(0, result.returncode, result.stdout + result.stderr)
            self.assertTrue((base / "stable-deck").is_dir())

    def test_import_defaults_to_copy(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            project = root / "deck"
            project.mkdir()
            source = root / "source.md"
            source.write_text("Source", encoding="utf-8")

            summary = project_manager.ProjectManager().import_sources(
                str(project), [str(source)]
            )

            self.assertTrue(source.is_file())
            self.assertEqual(
                [str(project / "sources" / "source.md")], summary["archived"]
            )

    def test_wechat_import_uses_the_receipt_aware_python_converter(self):
        manager = project_manager.ProjectManager()
        with mock.patch.object(manager, "_run_tool") as run_tool:
            manager._import_url(
                "https://mp.weixin.qq.com/s/example",
                Path("article.md"),
                Path("/workspace"),
            )

        command = run_tool.call_args.args[0]
        self.assertEqual(sys.executable, command[0])
        self.assertEqual("web_to_md.py", Path(command[1]).name)
        self.assertNotIn("web_to_md.cjs", " ".join(command))
        self.assertEqual(Path("/workspace"), run_tool.call_args.kwargs["cwd"])

    def test_import_cli_returns_nonzero_for_skipped_source(self):
        with tempfile.TemporaryDirectory() as directory:
            project = Path(directory) / "deck"
            project.mkdir()
            result = subprocess.run(
                [
                    sys.executable,
                    str(SCRIPT),
                    "import-sources",
                    str(project),
                    str(project / "missing.md"),
                ],
                capture_output=True,
                text=True,
                check=False,
            )

        self.assertEqual(1, result.returncode)
        self.assertIn("[WARN] Imported sources with failures", result.stdout)
        self.assertIn("[ERROR] One or more requested sources", result.stdout)


if __name__ == "__main__":
    unittest.main()

import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / "workspace_context.py"
SPEC = importlib.util.spec_from_file_location("seaslides_workspace_context", SCRIPT)
if SPEC is None or SPEC.loader is None:
    raise RuntimeError("Could not load workspace_context.py")
workspace_context = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = workspace_context
SPEC.loader.exec_module(workspace_context)


class WorkspaceContextTests(unittest.TestCase):
    def test_resolves_nested_workspace_relative_entry(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            entry = root / "slides" / "deck.typ"
            entry.parent.mkdir()
            entry.write_text("= Deck\n", encoding="utf-8")

            context = workspace_context.resolve_workspace_context(
                root,
                entry="slides/deck.typ",
            )

            self.assertEqual(root.resolve(), context.root)
            self.assertEqual(entry.resolve(), context.entry_path)
            self.assertEqual("slides/deck.typ", context.entry)
            self.assertEqual(root.resolve() / "output", context.output_dir)

    def test_rejects_entry_outside_workspace(self):
        with tempfile.TemporaryDirectory() as directory:
            parent = Path(directory)
            root = parent / "workspace"
            root.mkdir()
            outside = parent / "outside.typ"
            outside.write_text("= Outside\n", encoding="utf-8")

            with self.assertRaisesRegex(ValueError, "stay inside the workspace"):
                workspace_context.resolve_workspace_context(
                    root,
                    entry="../outside.typ",
                )

    def test_rejects_absolute_entry_even_when_it_is_inside_workspace(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            entry = root / "main.typ"
            entry.write_text("= Deck\n", encoding="utf-8")

            with self.assertRaisesRegex(ValueError, "workspace-relative"):
                workspace_context.resolve_workspace_context(root, entry=str(entry))

    def test_prepare_creates_only_workspace_support_directories(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "deck.typ").write_text("= Deck\n", encoding="utf-8")

            context = workspace_context.resolve_workspace_context(
                root,
                entry="deck.typ",
                prepare=True,
            )

            self.assertTrue(context.assets_dir.is_dir())
            self.assertTrue(context.output_dir.is_dir())
            self.assertTrue(context.sources_dir.is_dir())
            self.assertFalse((root / "README.md").exists())
            self.assertEqual(
                {"assets", "deck.typ", "output", "sources"},
                {path.name for path in root.iterdir()},
            )


if __name__ == "__main__":
    unittest.main()

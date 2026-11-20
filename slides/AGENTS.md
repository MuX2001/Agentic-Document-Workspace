# Research slides workspace

For research slides in this workspace, read `slide-style.md` and
`.agents/skills/research-slides/SKILL.md` before authoring.

- Workflow: independent project creation, Content Preparation, and Slide Rendering stages.
  Use the project commands in `README.md`; output PDF and editable Typst source.
- Active presets are the complete original A (Quarto Clean) and B (Metropolis) themes.
  Use the user's choice; preserve native typography, headers, page numbers and progress bars.
  Do not replace them with Simple or approximate style dictionaries.
  The default is A.
- Use the selected theme's native elements and defaults. Choose title, section,
  evidence, comparison and discussion layouts to fit the material.
- Keep reusable styling in `template.typ`. For Markdown decks, the authoritative
  content is the `markdown_source` in `deck.json` plus referenced `assets/`.
  Edit that Markdown; `main.typ` is generated during `slides.cmd build`.
  `scripts/markdown_to_typst.py` adapts content to the project's template.
  The local renderer compiles one PDF and derives PNG and HTML from its pages.
  Use `slides.cmd build PROJECT` as the sole rendering entry.
  Typst-only projects continue to use `main.typ` as their content source.
- Create new decks under `projects/`. Each receives a template, preset, complete upstream package and font snapshot. Do not
  replace an existing project's template during a routine build.
- No invented scientific evidence. Retain source diagrams and videos separately.
- New project and Content Preparation requests end with Markdown. Do not run
  rendering, doctor, preview, or checks during those two stages.
- Render only on an explicit rendering request or visual feedback. Inspect the
  first draft, affected pages after local changes, and all pages for final export.
  User approval is separate from agent inspection and mechanical success.
- Do not mutate the vendored SeaSlides implementation. Keep workspace-specific
  behavior in `scripts/`, the local template, and the research-slides skill.

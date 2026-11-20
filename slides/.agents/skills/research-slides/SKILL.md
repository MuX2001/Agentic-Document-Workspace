---
name: research-slides
description: Create research-slide projects, prepare self-contained Markdown content, or render slides in the NebulisLab Meeting workspace. Execute the requested stage independently.
---

# Research slides

Execute only the requested stage. Creating a project and organizing content end
at their Markdown deliverables. Start rendering when the user requests it or
gives visual feedback on a rendered deck. For an ambiguous request such as
"make slides from these notes", prepare Markdown and report it ready to render.

Read the project slides.md and deck.json when present. Read
template/research-slides/content-format.md for the content contract.
Read slide-style.md for scientific and language requirements. Its visual rules
apply in stage 3. For specific Typst questions during stage 3, consult the optional
SeaSlides reference at `vendor/seaslides/skills/seaslides-typst-slides-skill/SKILL.md`
(relative to the slides workspace). If absent, initialize the pinned submodule
using the workspace README instructions when needed. Routine new/build uses the
local scripts and does not require SeaSlides. An explicit request to use the full
SeaSlides workflow should read that upstream skill and follow the requested scope.

## 1. New slide project

Run `slides.cmd new NAME --template A --language zh` using the selected A/B
preset and language. Use the established default A when none is selected.
Populate slides.md from the input with audience, purpose, raw sources, and an
initial slide sequence. Templates are independent project snapshots.

Deliver the Markdown path and material gaps, then stop. Do not run doctor,
build, preview, checks, asset conversion, or visual inspection in this stage.

## 2. Content Preparation

This stage may repeat. Edit slides.md and preserve source material in its
background sections or sources/. Decide narrative, importance, evidence and the
message of each slide. Assign stable IDs and retain them through reordering.

Make slides.md plus referenced assets self-contained. Resolve definitions,
conditions, units, provenance, caveats and missing evidence. Write concise,
actual display content in Present / 上屏内容. Put explanation and editing
instructions in Context, Evidence and Missing. Identify expendable display
material in Optional / 可选上屏内容. Reference existing images with their intended
meaning, without designing them.

Do not design layouts, edit layout.json, transform images, generate Typst,
render, or run visual checks. Report meaningful edits and remaining questions,
then stop. Content preparation itself needs no CLI command.

## 3. Slide Rendering

Read the content contract, project theme.md, layout.json if present, and
slide-style.md. Run `slides.cmd build PROJECT` for the initial preview.
The compiler displays Present and Optional only. Store visual overrides in
layout.json by stable slide ID. main.typ is generated for Markdown projects.

Inspect the rendered pages for visual defects and deliver the result. For local
feedback, adjust the relevant layout or content and run
`slides.cmd build PROJECT --pages 2,3`. PDF and overview cover the whole deck.
Inspect affected pages and warnings. Global typography, template or sequence
changes warrant broader inspection. Do not fully review every local revision.

Try layout adjustments first. For space constraints, set include_optional=false
while retaining the original content. Concise wording and necessary slide splits
belong in slides.md. Preserve data, conditions, caveats and scientific meaning.
Report material content reductions. Refer changes in scientific claims to the user.

Use `--final` only for 144 ppi previews. Review is limited to build errors/warnings
and looking at rendered pages for clipping, overlap, typography and image layout.
Inspect changed pages; broaden to the deck when a global change affects it.
Do not create approval records, hash audits, or repeat inspection of unchanged pages.

## Implementation

Keep reusable styling in template.typ and project choices in preset.typ and
layout.json. Native Typst projects keep main.typ. Markdown decks without
content_format keep their existing parser. Migrate their content only when
requested, preserving sources.

The local renderer compiles once and reports errors. Chinese uses Source Han Sans;
keep each theme's original Latin fonts, including in Beamer. Environment diagnostics
and regression tests are for setup or workflow maintenance, not routine slide work.

Preserve original figures, videos and the pinned upstream SeaSlides submodule.
Commands and the three-stage workflow are documented in the workspace README.md.

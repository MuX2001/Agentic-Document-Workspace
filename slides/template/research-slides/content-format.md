# Research content Markdown v2

`deck.json` selects this contract with `"content_format": "research-slides-v2"`
and `"markdown_source": "slides.md"`. Language and template selection belong in
the project configuration.

## Content preparation

Before the first slide, write the audience, purpose, time budget, decisions to
discuss, and raw input. Each `## S01 · Title` starts a slide. Keep the ID when
reordering. IDs are unique S followed by digits. The title appears on the slide.

Use these named `###` sections. English and Chinese names are equivalent.

| Chinese | English | Purpose |
|---|---|---|
| 本页目的 | Purpose | Intended conclusion or question |
| 上屏内容 | Present | Actual text, tables, equations and asset references to display |
| 讲述背景 | Context | Definitions, reasoning and background |
| 证据与约束 | Evidence | Source paths, experimental conditions, units and qualifications |
| 可选上屏内容 | Optional | Additional display content that may be omitted for space |
| 待补充项 | Missing | Missing evidence and how to handle it |

Present must contain content to render. Other sections are optional. Rendering
includes Present and Optional by default. All other sections and the introduction
stay in the Markdown. Read them when choosing visuals or shortening content.
Unresolved gaps may remain when the user requests a draft.

Use `####` for headings within displayed content. Standard Markdown text,
lists, tables, links, images, and code blocks are supported. Image paths are
relative to slides.md and must exist inside the project. Image alt text becomes
the caption. Keep original media and provenance in assets/ and sources/.

For a native Typst equation, use a fenced block labelled `typst-math`.

````markdown
## S01 · Evaluation question

### Purpose
State the controlled comparison.

### Present
```typst-math
Delta_T (t, tau) = L_0 (t, tau) - L_T (t, tau)
```

Hold observation and action target fixed.

### Context
Explain the state variable and flow time here.

### Evidence
Describe where the definition came from and its assumptions.

### Optional
One additional explanation that can be omitted.
````

The typst-math block uses Typst math syntax. Ordinary dollar-delimited Markdown
math is not supported by this parser. Use actual values and explicit missing
evidence labels when preparing scientific content.

## Rendering controls

Create layout.json only when a slide needs a visual override. Its keys are slide
IDs. Reordering Markdown keeps overrides attached to the intended slide.

```json
{
  "S01": {
    "layout": "flow",
    "image_height": 260,
    "show_title": true,
    "include_optional": false
  },
  "S02": {
    "layout": "columns",
    "columns": [3, 2]
  }
}
```

- `flow` and `auto` lay out blocks vertically. This is the default.
- `discussion` vertically centers a short question.
- `columns` uses a single `---` between two groups in Present. The two values
  in `columns` control relative widths. Both groups must have content.
- `image_height` sets a maximum image box height in points. Aspect ratio and
  all image edges are preserved. Default is 308 for a single image, otherwise 200.
- `show_title` defaults to true.
- `include_optional` defaults to true. Set false to omit the Optional section.

Only stage 3 chooses these controls. Keep shortening decisions in Markdown or
include_optional selection so regenerating main.typ reproduces the result.

## Compatibility

Older Markdown projects without content_format keep their existing syntax and
layout rules. To migrate one, restructure its content into the sections above,
retain original notes and evidence, add stable IDs, and set content_format in
deck.json. Its template needs the markdown-slide, markdown-table and
markdown-figure helpers already used by the Markdown pipeline.

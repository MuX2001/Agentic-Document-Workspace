# Pritzker Theme for Touying 0.7.4

## I. Project Information

| Item | Value |
| ---- | ----- |
| **Theme Name** | pritzker |
| **Best For** | Architecture, luxury brands, award ceremonies, cultural institutions, real estate, museums |
| **Style Objective** | Architectural / Editorial Luxury |
| **Complexity Level** | Canvas |

An architectural editorial luxury presentation theme inspired by the Pritzker Architecture Prize. Features warm cream backgrounds with gold accents, italic serif editorial numbers, dark info cards, scrim overlays for image compositions, and a restrained yet sophisticated palette. Building-block architecture with small composable components.

## Design Philosophy

- **Architectural Restraint**: Warm cream paper with gold accents creates a high-end architectural publication feel
- **Editorial Numbering**: Large italic Georgia numbers serve as decorative chapter/card elements
- **Gold Accent System**: Single gold color drives all borders, rules, and accent elements
- **Image + Scrim Composition**: Full-bleed imagery with dark gradient scrims for text legibility over photographs

## Color Palette

| Color | Hex | Role |
|-------|-----|------|
| Cream | `#F5F2EC` | Primary background |
| Cream Alt | `#EDE8DE` | Alternative background for cards |
| Near Black | `#1C1C1C` | Primary text, dark backgrounds |
| Bronze Gold | `#85673F` | Accessible primary accent (borders, rules, labels on cream) |
| Gold Light | `#E8C788` | Light gold for dark card text |
| Secondary Gray | `#5C5852` | Body text on cream |
| Tertiary Gray | `#8B8680` | Metadata, footer text |
| Border | `#D4CFC4` | Light borders, dividers |
| Dark | `#1C1C1C` | Dark card/slide backgrounds |
| Scrim | `#0A0A0A` | Image overlay base color |

## Theme Entry Point

```typst
#import "@preview/touying:0.7.4": *
#import "template.typ": *

#show: pritzker-theme.with(
  aspect-ratio: "16-9",
  config-common(breakable: false),
  config-info(
    title: [Pritzker Prize 2026],
    subtitle: [Architecture of Light],
    author: [Jury Panel],
    date: datetime.today(),
  ),
)

#set text(font: ("Georgia", "Songti SC"), size: 12pt)
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `aspect-ratio` | `string` | `"16-9"` | Slide aspect ratio |

## Slide Functions

### `title-slide(bg-image: none, title: auto, subtitle: auto, info-line1: none, info-line2: none, quote-text: none, source: none)`
Full-bleed cover with optional background image (or dark gray fallback), left+bottom gradient scrims, gold eyebrow label "PRITZKER PRIZE . 2026", large white title (40pt), gold italic subtitle (22pt), gold-bordered info lines, optional italic quote text, and source/PPT MASTER footer.

### `slide(title: auto, ..args)`
Standard cream-background slide with bold title (1.2em), 40pt gold rule below, and footer with border-topped page counter.

### `focus-slide(brackets: false, footer-left: none, footer-right: none, body)`
Centered statement slide with optional gold corner brackets (L-shaped decorations top-left and bottom-right), centered text (14pt), and optional footer labels.

### `ending-slide(body)`
Simple centered ending slide with 14pt text, no header/footer, 2em margin.

## Reusable Components

### `gold-rule(width: 40pt, thickness: 2pt)`
Decorative gold horizontal rule.

```typst
#gold-rule(width: 60pt, thickness: 3pt)
```

### `editorial-num(n, size: 48pt, opacity: 50%, color: palette.gold)`
Large italic serif number (Georgia) for decorative numbering. Gold with configurable opacity and an overridable color for dark imagery.

```typst
#editorial-num([1], size: 64pt, opacity: 80%)
```

### `eyebrow(dark: false, body)`
Small tracked uppercase gold label (9pt). Use `dark: true` over dark images.

```typst
#eyebrow[ARCHITECTURE OF LIGHT]
```

### `master-card(num, name, project, location)`
Numbered architect card with gold left border (2pt), editorial number, bold name, project description, and location.

```typst
#master-card([01], [Ando Tadao], [H+ Art Museum], [Suzhou, China 2026.1])
```

### `info-card(title, body)`
Dark card (near-black background) with gold title and gold-light body text.

```typst
#info-card([Key Insight], [The jury praised the use of natural light...])
```

### `insight-card(title, body)`
Light card with gold left border and cream background.

```typst
#insight-card([Design Principle], [Integration with landscape and context...])
```

### `stat-box(value, desc, variant: "dark", value-size: 14pt)`
Single stat/KPI box. Variants: `"dark"` (black bg, gold text), `"light"` (cream alt bg), `"gold"` (gold-tinted bg).

```typst
#stat-box(variant: "dark")[$724M][Annual prize fund]
```

### `stat-row(..boxes)`
Horizontal row of stat-box elements with 8pt gutter.

```typst
#stat-row(
  stat-box[$724M][Prize fund],
  stat-box[48][Laureates],
  stat-box[47][Years],
)
```

### `image-frame(path, label: none, height: auto, frame: false)`
Framed image with optional gold-border frame and caption.

```typst
#image-frame("museum.jpg", label: [Fig. 1: Exterior view], height: 160pt, frame: true)
```

### `scrim-overlay(height: 100%, body)`
Dark gradient scrim overlay for text on images.

```typst
#scrim-overlay(height: 60%)[
  #text(fill: white, size: 1.5em)[Title over image]
]
```

### `comparison-arrow(body)`
Gold italic arrow with label text for comparison layouts.

```typst
#comparison-arrow[EVOLUTION]
```

### `labeled-card(label-text, title, body, variant: "light")`
Card with tracked uppercase gold label, bold title, gold rule accent, and body. Variants: `"light"` (cream bg, gold left border), `"dark"` (dark bg, no border).

```typst
#labeled-card("CORE CONCEPT", [Material Honesty], [Expressing the true nature of materials...])
```

### `stat-column(label-text, value, desc)`
Stat with category label, gold left border, large value, and description.

```typst
#stat-column("SCALE", [$724M], [Annual infrastructure investment])
```

### `quote-block(body, attribution)`
Dark background quote with gold left border, italic gold-light text, and attribution.

```typst
#quote-block([Architecture is frozen music.], [Goethe])
```

### `manifesto-block(label-text, title, desc, tag: none)`
Vertical gold accent + labeled statement with optional italic gold tag.

```typst
#manifesto-block("PRINCIPLE 01", [Light as Material], [Natural light becomes...], tag: [Core thesis])
```

## File Structure

```
pritzker/
  template.typ   -- Theme definition (palette, components, slides)
  demo.typ       -- Full demonstration presentation
```

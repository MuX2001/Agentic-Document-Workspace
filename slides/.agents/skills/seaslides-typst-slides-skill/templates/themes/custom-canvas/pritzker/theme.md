# Pritzker Theme

**Type**: Custom (local template)
**Touying version**: 0.7.4
**Entry function**: `pritzker-theme`
**Style**: Architectural editorial luxury -- warm cream with gold accents, serif editorial numbers
**Primary color**: `#85673F` (Accessible architectural bronze-gold)
**Best For**: Architecture, luxury brands, award ceremonies, cultural institutions, real estate, museums
**Style Objective**: Architectural / Editorial Luxury
**Complexity Level**: Canvas

## Description

An architectural editorial luxury presentation theme inspired by the Pritzker Architecture Prize. Features warm cream backgrounds with accessible bronze-gold accents, large italic Georgia editorial numbers, dark info cards, full-bleed image compositions with scrim overlays, and a restrained yet sophisticated palette. Building-block architecture with composable components including master-cards, stat-boxes, labeled-cards, and quote-blocks.

## Quick Start

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

#title-slide(
  bg-image: "cover.jpg",
  info-line1: [The 48th Pritzker Architecture Prize],
  info-line2: [Awarded for lifetime contribution],
)

== Laureate Overview

Content with master-card, stat-box components.
```

## Theme Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `aspect-ratio` | string | `"16-9"` | Slide aspect ratio |

## Available Slide Types

### `#title-slide(bg-image: none, title: auto, subtitle: auto, info-line1: none, info-line2: none, quote-text: none, source: none)`
Full-bleed cover with scrims, gold eyebrow, large white title, gold italic subtitle, gold-bordered info lines, and optional quote.

### `#slide(title: auto)`
Standard cream slide with bold title, gold rule, and footer with page counter.

### `#focus-slide(brackets: false, footer-left: none, footer-right: none)[...]`
Centered statement with optional gold corner brackets.

### `#ending-slide[...]`
Simple centered ending slide.

## Reusable Components

### `#gold-rule(width: 40pt, thickness: 2pt)`
Decorative gold horizontal rule.
```typst
#gold-rule(width: 60pt)
```

### `#editorial-num(n, size: 48pt, opacity: 50%, color: palette.gold)`
Large italic serif number (Georgia). Override `color` for numbers placed on dark imagery.
```typst
#editorial-num([1], size: 64pt, opacity: 80%)
```

### `#eyebrow(dark: false, body)`
Small tracked uppercase gold label. Pass `dark: true` on dark images or dark page fills.
```typst
#eyebrow[ARCHITECTURE OF LIGHT]
#eyebrow(dark: true)[MASTERWORK]
```

### `#master-card(num, name, project, location)`
Numbered architect card with gold left border.
```typst
#master-card([01], [Ando Tadao], [H+ Art Museum], [Suzhou 2026])
```

### `#info-card(title, body)`
Dark card with gold title and light gold body text.
```typst
#info-card([Key Insight], [Natural light integration...])
```

### `#insight-card(title, body)`
Light card with gold left border.
```typst
#insight-card([Principle], [Material honesty in design...])
```

### `#stat-box(value, desc, variant: "dark", value-size: 14pt)`
KPI box. Variants: `"dark"`, `"light"`, `"gold"`.
```typst
#stat-box(variant: "dark")[$724M][Prize fund]
```

### `#stat-row(..boxes)`
Horizontal row of stat boxes.
```typst
#stat-row(
  stat-box([\$724M], [Fund], variant: "dark"),
  stat-box([48], [Laureates], variant: "light"),
)
```

### `#image-frame(path, label: none, height: auto, frame: false)`
Framed image with optional gold border and caption.
```typst
#image-frame("museum.jpg", height: 160pt, frame: true)
```

### `#scrim-overlay(height: 100%)[...]`
Padding container for text placed inside an already-rendered image scrim. Use it only inside `place()` or another explicitly fixed-height container.

### `#labeled-card(label-text, title, body, variant: "light")`
Card with gold label, title, rule accent, and body.
```typst
#labeled-card("CONCEPT", [Material Honesty], [Expressing true nature...])
```

### `#stat-column(label-text, value, desc)`
Stat with category label and gold left border.
```typst
#stat-column("SCALE", [$724M], [Annual investment])
```

### `#quote-block(body, attribution)`
Dark quote with gold left border.
```typst
#quote-block([Architecture is frozen music.], [Goethe])
```

### `#manifesto-block(label-text, title, desc, tag: none)`
Vertical gold accent + labeled statement.
```typst
#manifesto-block("PRINCIPLE", [Light as Material], [Description...])
```

### `#comparison-arrow(body)`
Gold italic arrow with label.
```typst
#comparison-arrow[EVOLUTION]
```

## Color Scheme

| Color | Hex | Role |
|-------|-----|------|
| Cream | `#F5F2EC` | Page background |
| Cream Alt | `#EDE8DE` | Card alt background |
| Near Black | `#1C1C1C` | Primary text, dark cards |
| Bronze Gold | `#85673F` | Accessible primary accent on cream |
| Gold Light | `#E8C788` | Dark card body text |
| Secondary | `#5C5852` | Body text |
| Tertiary | `#8B8680` | Metadata, footer |
| Border | `#D4CFC4` | Light borders |
| Scrim | `#0A0A0A` | Image overlay |

### Touying Color Mapping

`config-colors` maps primary to bronze gold, primary-dark to near black, neutral-lightest to cream, and neutral-darkest to near black.

## Files

- `template.typ` -- Theme definition (palette, components, slides, entry point)
- `demo.typ` -- Compilable showcase (architecture prize topic)

## Demo

See `demo.typ` for a compilable example.

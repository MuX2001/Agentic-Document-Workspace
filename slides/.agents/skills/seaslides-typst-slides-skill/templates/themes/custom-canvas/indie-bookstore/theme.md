# Indie Bookstore Theme

**Type**: Custom (local template)
**Touying version**: 0.7.4
**Entry function**: `zine-theme`
**Style**: Risograph zine aesthetic -- Federal Blue + Fluorescent Pink duotone on kraft cream paper
**Primary color**: `#1E4DBC` (Federal Blue)
**Best For**: Indie bookstores, zine culture, risograph art, creative communities, publishing, cultural guides
**Style Objective**: Risograph Zine Aesthetic
**Complexity Level**: Canvas

## Description

A risograph zine aesthetic presentation theme with warm cream paper backgrounds, Federal Blue and Fluorescent Pink duotone colors, hard-edge cards (zero border-radius), misregistered shadow effects, and monospace annotations. Features a large collection of composable components including riso-squares, zine-cards, step-circles, rich-numbered-rows, pillar-cards, and info-cards. The overall feel is warm, tactile, and reminiscent of hand-printed independent zines.

## Quick Start

```typst
#import "@preview/touying:0.7.4": *
#import "template.typ": *

#set text(font: ("Arial", "Heiti SC"), size: 11pt)

#show: zine-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Indie Bookstore Guide],
    subtitle: [Zine Culture Map 2026],
    author: [PPT Master],
    date: datetime.today(),
  ),
)

#title-slide(info-text: [A curated guide to the world's best indie bookstores])

== Store Selection

Content using zine-card, pillar-card, etc.
```

## Theme Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `aspect-ratio` | string | `"16-9"` | Slide aspect ratio |

## Available Slide Types

### `#title-slide(bg-image: none, title: auto, subtitle: auto, info-text: none)`
Full-bleed cover with gradient scrims, pink misregistered title shadow, and monospace annotations.

### `#slide(title: auto)`
Standard slide with blue accent bar + bold title, near-black footer with page counter.

### `#focus-slide[...]`
Centered statement slide with padded content.

### `#hero-slide(bg-image, body)`
Full-bleed background image slide with overlay content.

### `#ending-slide(bg-image: none, body)`
Outro slide with optional background image and left scrim.

## Reusable Components

### `#riso-square(size: 50pt, fill-color: palette.blue, body)`
Misregistered block with offset pink shadow.
```typst
#riso-square(size: 50pt)[#text(fill: white, weight: "bold")[01]]
```

### `#eyebrow(body)`
Monospace tracked uppercase label.
```typst
#eyebrow[SECTION ONE]
```

### `#zine-card(variant: "cream", body)`
Hard-edge card. Variants: `"cream"`, `"blue"`, `"pink"`, `"mustard"`, `"dark"`.
```typst
#zine-card(variant: "blue")[Blue card content]
```

### `#step-circle(num, size: 60pt, variant: "blue")`
Numbered circle for process flows.
```typst
#step-circle(1) #step-arrow() #step-circle(2)
```

### `#halftone-bar(width: 100%, height: 4pt, color: palette.blue)`
Decorative translucent bar simulating halftone.
```typst
#halftone-bar(width: 80%, color: palette.pink)
```

### `#mono-caption(body)`
Monospace annotation (7.5pt uppercase tracked).
```typst
#mono-caption[SOURCE: FIELD RESEARCH 2026]
```

### `#zine-image(path, height: auto, width: 100%)`
Hard-edge image frame with cover fit.
```typst
#zine-image("store.jpg", height: 180pt)
```

### `#table-row(store, city, character, zine-level, is-header: false, stripe: false)`
Bookstore map table row.
```typst
#table-row([STORE], [CITY], [CHARACTER], [LEVEL], is-header: true)
#table-row([City Lights], [SF], [Beat Generation landmark], [***])
```

### `#info-card(label-text, title-text, body, variant: "blue")`
Labeled card with colored left border.
```typst
#info-card("EVENT", [Tokyo Art Book Fair], [Annual publisher gathering...])
```

### `#pillar-card(city, store-name, body, accent: palette.blue)`
Vertical city card with colored top border.
```typst
#pillar-card([TOKYO], [Shibuya Publishing], [Art book selection...])
```

### `#numbered-item(num, title-text, body, accent: palette.pink)`
Numbered list item with large colored number.
```typst
#numbered-item([01], [Find Your Store], [Research local shops...])
```

### `#rich-numbered-row(num, title-text, desc, accent: palette.blue, icon-symbol: none)`
Rich card-based numbered row with square + connector + card.
```typst
#rich-numbered-row([01], [Enter], [Look for zine rack], icon-symbol: [B])
```

### `#vlist-item(num, title-text, desc, accent: palette.blue)`
Vertical list item with accent left border.
```typst
#vlist-item([01], [Selection], [Owner-curated picks])
```

## Color Scheme

| Color | Hex | Role |
|-------|-----|------|
| Warm Cream | `#F5EFE0` | Page background |
| Darker Cream | `#EAE2CC` | Card backgrounds |
| Federal Blue | `#1E4DBC` | Primary Riso color |
| Fluorescent Pink | `#FF5C8A` | Accent, shadows |
| Mustard | `#E8A02E` | Highlight (< 5%) |
| Near Black | `#1A1A1A` | Body text, borders |
| Gray | `#5A5A5A` | Annotation text |
| Tertiary | `#8C8275` | Faint text |

### Touying Color Mapping

Default config-colors not explicitly set; uses page fill `#F5EFE0` and text fill `#1A1A1A`.

## Files

- `template.typ` -- Theme definition (palette, components, slides, entry point)
- `demo.typ` -- Compilable showcase (indie bookstore guide topic)

## Demo

See `demo.typ` for a compilable example.

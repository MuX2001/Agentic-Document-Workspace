# Indie Bookstore Theme for Touying 0.7.4

## I. Project Information

| Item | Value |
| ---- | ----- |
| **Theme Name** | indie-bookstore |
| **Best For** | Indie bookstores, zine culture, risograph art, creative communities, publishing, cultural guides |
| **Style Objective** | Risograph Zine Aesthetic |
| **Complexity Level** | Canvas |

A risograph zine aesthetic presentation theme with warm cream paper backgrounds, Federal Blue and Fluorescent Pink duotone colors, hard-edge cards, misregistered shadow effects, and monospace annotations. Features a building-block architecture with many composable components including riso-squares, zine-cards, step-circles, timeline-ticks, halftone-bars, and table rows.

## Design Philosophy

- **Riso Duotone**: Federal Blue primary + Fluorescent Pink accent create authentic risograph print vibes
- **Hard-Edge Aesthetic**: Zero border-radius everywhere; all elements are sharp-cornered rectangles and squares
- **Kraft Paper Warmth**: Warm cream backgrounds evoke zine paper stock and independent print culture
- **Misregistered Layering**: Offset shadow effects (pink behind blue) simulate risograph print misregistration

## Color Palette

| Color | Hex | Role |
|-------|-----|------|
| Warm Cream | `#F5EFE0` | Primary background (kraft paper) |
| Darker Cream | `#EAE2CC` | Card backgrounds, stripe rows |
| Federal Blue | `#1E4DBC` | Primary Riso color, titles, borders |
| Fluorescent Pink | `#FF5C8A` | Accent, misregistration shadow |
| Mustard | `#E8A02E` | Highlight accent (< 5% usage) |
| Near Black | `#1A1A1A` | Body text, borders, dividers |
| Gray | `#5A5A5A` | Annotation/secondary text |
| Tertiary | `#8C8275` | Faint/tertiary text |

## Theme Entry Point

```typst
#import "@preview/touying:0.7.4": *
#import "template.typ": *

#show: zine-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Zine Guide],
    subtitle: [Indie Bookstore Map],
    author: [Author],
    date: datetime.today(),
  ),
)
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `aspect-ratio` | `string` | `"16-9"` | Slide aspect ratio |

## Slide Functions

### `title-slide(bg-image: none, title: auto, subtitle: auto, info-text: none)`
Full-bleed cover with optional background image, left gradient scrim (cream to transparent), bottom scrim, pink misregistered title shadow (72pt), Federal Blue main title, monospace annotations (ISSUE No1, PPT MASTER), subtitle at right area, and optional info text.

### `slide(title: auto, ..args)`
Standard slide with blue accent bar + bold title header, near-black rule footer with monospace page counter, and cream background.

### `focus-slide(body)`
Centered statement slide with padded content area (8% horizontal padding), no header/footer.

### `hero-slide(bg-image, body)`
Full-bleed background image slide with no margins, header, or footer. Body is overlaid.

### `ending-slide(bg-image: none, body)`
Outro slide with optional background image and left gradient scrim overlay.

## Reusable Components

### `riso-square(size: 50pt, fill-color: palette.blue, body)`
Risograph-style misregistered block -- colored square with offset pink shadow behind. For TOC numbers, icon backgrounds.

```typst
#riso-square(size: 50pt, fill-color: palette.blue)[
  #text(fill: white, size: 20pt, weight: "bold")[01]
]
```

### `eyebrow(body)`
Monospace tracked uppercase label (8pt, gray).

```typst
#eyebrow[SECTION ONE]
```

### `title-bar(color: palette.blue, width: 10pt, height: 44pt)`
Vertical colored stripe for title decoration.

```typst
#title-bar(color: palette.pink)
```

### `zine-card(variant: "cream", body)`
Hard-edge card with variant fill. Variants: `"cream"`, `"blue"`, `"pink"`, `"mustard"`, `"dark"`. Auto-sets text color.

```typst
#zine-card(variant: "blue")[
  White text on Federal Blue background.
]
```

### `step-circle(num, size: 60pt, variant: "blue")`
Numbered circle for process flows. Variants: `"blue"`, `"pink"`, `"mustard"`, `"dark"`.

```typst
#step-circle(1) #step-arrow() #step-circle(2) #step-arrow() #step-circle(3)
```

### `step-arrow(size: 18pt)`
Arrow connector between step circles.

```typst
#step-arrow(size: 18pt)
```

### `timeline-tick()`
Vertical tick marker (3pt wide, 12pt tall) for timeline axes.

```typst
#timeline-tick()
```

### `halftone-bar(width: 100%, height: 4pt, color: palette.blue)`
Decorative bar simulating risograph halftone pattern (60% transparent).

```typst
#halftone-bar(width: 80%, color: palette.pink)
```

### `mono-caption(body)`
Monospace annotation text (7.5pt, tracked uppercase).

```typst
#mono-caption[SOURCE: PPT MASTER 2026]
```

### `icon-block(symbol, size: 28pt, color: palette.bg)`
Bold character as icon stand-in.

```typst
#icon-block("B", size: 28pt, color: palette.bg)
```

### `zine-image(path, height: auto, width: 100%)`
Image frame with hard edge (no border-radius), cover fit.

```typst
#zine-image("photo.jpg", height: 200pt)
```

### `scrim-gradient(angle: 0deg, opacity-start: 92%, opacity-end: 0%)`
Gradient overlay for text readability on images.

```typst
#scrim-gradient(angle: 180deg, opacity-start: 80%, opacity-end: 0%)
```

### `zine-footer(left-text, right-text)`
Page footer with near-black rule + monospace text.

```typst
#zine-footer([PPT Master Riso], [2026])
```

### `zine-footer-auto(left-text, right-text)`
Placed page footer with auto page numbers (positioned at bottom).

```typst
#zine-footer-auto([INDIE BOOKSTORE MAP], [P. 04])
```

### `table-row(store, city, character, zine-level, is-header: false, stripe: false)`
Table row for bookstore map with 4 columns: store name, city, character description, zine-level (stars).

```typst
#table-row([STORE], [CITY], [CHARACTER], [LEVEL], is-header: true)
#table-row([Shakespeare & Co], [Paris], [Literary landmark since 1919], [***], stripe: true)
```

### `info-card(label-text, title-text, body, variant: "blue")`
Labeled info card with colored left border, tracked uppercase label, title, accent line, and body.

```typst
#info-card("BOOK FAIR", [Tokyo Art Book Fair], [Annual gathering of independent publishers...])
```

### `pillar-card(city, store-name, body, accent: palette.blue)`
Vertical pillar card for city-based layouts with colored top border, city label, store name, and content.

```typst
#pillar-card([TOKYO], [Shibuya Publishing], [Curated selection of art books...])
```

### `numbered-item(num, title-text, body, accent: palette.pink)`
Numbered list item with large colored number and title + description.

```typst
#numbered-item([01], [Find Your Store], [Research local indie bookstores...])
```

### `rich-numbered-row(num, title-text, desc, accent: palette.blue, icon-symbol: none)`
Rich card-based numbered row with colored number square, dashed connector, optional icon square, and dark stripe card.

```typst
#rich-numbered-row(
  [01], [Enter the Store], [Look for the zine rack near the entrance],
  accent: palette.blue, icon-symbol: [B],
)
```

### `vlist-item(num, title-text, desc, accent: palette.blue)`
Vertical list item with accent left border, monospace number, bold title, and description.

```typst
#vlist-item([01], [Selection], [Curated by the owner personally])
```

## File Structure

```
indie-bookstore/
  template.typ   -- Theme definition (palette, components, slides)
  demo.typ       -- Full demonstration presentation
```

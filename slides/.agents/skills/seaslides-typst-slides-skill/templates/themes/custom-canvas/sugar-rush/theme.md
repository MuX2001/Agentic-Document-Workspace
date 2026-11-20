# Sugar Rush Theme

**Type**: Custom (local template)
**Touying version**: 0.7.4
**Entry function**: `sugar-rush-theme`
**Style**: Memphis Design / 80s retro revival -- candy-colored, bold playful geometry
**Primary color**: `#FF3DA5` (Hot Pink)
**Best For**: Music festivals, pop culture events, youth marketing, entertainment, creative agencies
**Style Objective**: Memphis Design / 80s Retro Revival
**Complexity Level**: Canvas

## Description

A candy-colored 80s retro revival presentation theme with bold playful geometry, Memphis design patterns, heavy black strokes (3pt), and a multi-color accent system (pink, blue, yellow, mint, coral). Features KPI cards, pillar cards, flavor quadrant cards, hub-spoke layouts, timeline cards, ticket pricing cards, headliner cards, comparison columns, and decorative Memphis elements (zigzags, waves, dots, triangles, checkerboards). Uses Arial/Arial Unicode MS for the verified demo font stack and heavy display weight.

## Quick Start

```typst
#import "@preview/touying:0.7.4": *
#import "template.typ": *

#set text(font: ("Arial", "Arial Unicode MS"), size: 12pt)

#show: sugar-rush-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Sugar Rush Festival],
    subtitle: [Music & Culture 2026],
    author: [Creative Team],
    date: datetime.today(),
  ),
)

#title-slide()

== Festival Overview

#section-title(palette.pink)[BY THE NUMBERS]

#grid(columns: (1fr, 1fr, 1fr), column-gutter: 12pt,
  kpi-card(palette.pink, [DAYS], [7], [Non-stop music]),
  kpi-card(palette.blue, [STAGES], [12], [Across the venue]),
  kpi-card(palette.yellow, [ARTISTS], [200+], [From 30 countries]),
)
```

## Theme Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `aspect-ratio` | string | `"16-9"` | Slide aspect ratio |

## Available Slide Types

### `#title-slide(bg-image: none)`
Full-bleed cover with optional background image. No margins, designed for custom overlays.

### `#slide(title: auto)`
Standard cream slide with pink accent bar + bold title and page counter footer.

### `#chapter-slide(bg-image: none)`
Chapter divider with full-bleed image. For giant overlay chapter text.

### `#ending-slide[...]`
Centered ending slide.

## Reusable Components

### `#section-title(color, body)`
Section title with left color bar.
```typst
#section-title(palette.pink)[BY THE NUMBERS]
```

### `#chapter-badge(body)` / `#chapter-word(body)`
Dark label badge and giant chapter word.
```typst
#chapter-badge[CH . 01] #chapter-word[OVERTURE]
```

### `#kpi-card(color, label, number, desc, icon: none, decoration: none)`
KPI card with colored header band + big number.
```typst
#kpi-card(palette.pink, [DAYS], [7], [Non-stop music], icon: "D")
```

### `#pillar-card(color, num, title, icon-area, body)`
Numbered column card with colored top band.
```typst
#pillar-card(palette.blue, [01], [FREE], [Icons], [#memphis-bullet(palette.blue)[Feature]])
```

### `#memphis-bullet(color, body)`
Bullet point with colored dot.
```typst
#memphis-bullet(palette.pink)[Unlimited stage access]
```

### `#flavor-card(color, title, badge-text, body, icon: none)`
Genre/category card with badge pill.
```typst
#flavor-card(palette.pink, [ROCK], [25 ARTISTS], [Main stage lineup...])
```

### `#hub-center(title, sub)` / `#spoke-card(color, title, number, desc1, desc2, icon: none)`
Hub-spoke diagram components.
```typst
#hub-center[SUGAR \ DOME][MAIN . 30000]
#spoke-card(palette.blue, [CHERRY], [5,000], [Capacity], [Day 2])
```

### `#timeline-node(color, num, star: false)` / `#timeline-card(color, date, title, sub, desc)`
Timeline components (nodes + cards).
```typst
#timeline-node(palette.pink, [1])
#timeline-card(palette.pink, [7.18], [OPENING], [Night 1], [First show])
```

### `#ticket-card(color, title, subtitle, limit, price, features, highlight: false)`
Pricing tier card.
```typst
#ticket-card(palette.blue, [REGULAR], [Standard], [30000], [799], [Features...])
```

### `#compare-column(color, header-label, header-title, img-path, stat-num, stat-desc, stat-sub, body)`
Comparison column with image, stat, and bullets.
```typst
#compare-column(palette.pink, [2025], [Last Year], "img.jpg", [45K], [Attend], [Peak], [...])
```

### `#headliner-card(color, num, name, genre, detail1, detail2, icon: none)`
Artist/headliner info card.
```typst
#headliner-card(palette.pink, [01], [ARTIST], [ROCK], [2h set], [Main stage])
```

### `#cta-button(color, body)` / `#cta-button-dark(body)`
Memphis pill buttons.
```typst
#cta-button(palette.pink)[BUY TICKETS]
```

### `#dark-banner(body)`
Full-width dark rounded strip.
```typst
#dark-banner[#text(fill: white)[Announcement]]
```

### Decorative Memphis Elements
```typst
#memphis-dots(palette.pink, palette.blue, palette.yellow)
#memphis-triangle(palette.mint, size: 24pt)
#memphis-zigzag(palette.pink)
#memphis-wave(palette.blue)
#memphis-checkerboard(size: 40pt, cell: 8pt)
```

## Color Scheme

| Color | Hex | Role |
|-------|-----|------|
| Cream | `#FFF8EE` | Page background |
| Light Cream | `#FFE9C7` | Alt background |
| Hot Pink | `#FF3DA5` | Primary accent |
| Cyan | `#00B8D9` | Secondary accent |
| Yellow | `#FFD93D` | Tertiary accent |
| Mint | `#00C896` | Quaternary accent |
| Coral | `#FF6B4A` | Quinary accent |
| Near Black | `#1A1A2E` | Text, strokes |
| Gray | `#5C5C7A` | Secondary text |
| White | `#FFFFFF` | Card fills |

### Touying Color Mapping

Default config-colors not explicitly set; uses page fill `#FFF8EE` and text fill `#1A1A2E`.

## Files

- `template.typ` -- Theme definition (palette, components, slides, entry point)
- `demo.typ` -- Compilable showcase (music festival topic)

## Demo

See `demo.typ` for a compilable example.

# Sugar Rush Theme for Touying 0.7.4

## I. Project Information

| Item | Value |
| ---- | ----- |
| **Theme Name** | sugar-rush |
| **Best For** | Music festivals, pop culture events, youth marketing, entertainment, creative agencies |
| **Style Objective** | Memphis Design / 80s Retro Revival |
| **Complexity Level** | Canvas |

A candy-colored 80s retro revival presentation theme with bold playful geometry, Memphis design patterns, heavy black strokes, and multi-color accent system. Features KPI cards with colored header bands, pillar cards with numbered columns, flavor quadrant cards, hub-spoke layouts, timeline cards, ticket pricing cards, headliner cards, and decorative Memphis elements (zigzags, waves, dots, triangles, checkerboards).

## Design Philosophy

- **Memphis Maximalism**: Bold 3pt black strokes, candy-bright fills, and geometric decorative elements embrace 80s Memphis design
- **Multi-Color Palette**: Pink, blue, yellow, mint, and coral work together without a single dominant accent
- **Heavy Geometry**: 8pt rounded cards, thick borders, and playful shapes (circles, triangles, zigzags) fill negative space
- **Festival Energy**: Large black-weight numbers, tracked uppercase labels, and emoji-like icon slots convey event excitement

## Color Palette

| Color | Hex | Role |
|-------|-----|------|
| Cream | `#FFF8EE` | Primary background |
| Light Cream | `#FFE9C7` | Alternative background |
| Hot Pink | `#FF3DA5` | Primary accent |
| Cyan | `#00B8D9` | Secondary accent |
| Yellow | `#FFD93D` | Tertiary accent (dark text on yellow) |
| Mint | `#00C896` | Quaternary accent |
| Coral | `#FF6B4A` | Quinary accent |
| Near Black | `#1A1A2E` | Primary text, strokes, dark backgrounds |
| Gray | `#5C5C7A` | Secondary text |
| White | `#FFFFFF` | Card backgrounds, clean text |

## Theme Entry Point

```typst
#import "@preview/touying:0.7.4": *
#import "template.typ": *

#show: sugar-rush-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Sugar Rush Festival],
    subtitle: [Music & Culture 2026],
    author: [Creative Team],
    date: datetime.today(),
  ),
)
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `aspect-ratio` | `string` | `"16-9"` | Slide aspect ratio |

## Slide Functions

### `title-slide(bg-image: none)`
Full-bleed cover with optional background image (or cream fallback). No margins, no header/footer. Designed for custom overlay content using place().

### `slide(title: auto, ..args)`
Standard cream slide with pink left accent bar (6pt) + bold black-weight title (1.4em, Arial display font), and page counter footer.

### `chapter-slide(bg-image: none)`
Chapter divider with optional full-bleed background image. No margins, no header/footer. For giant overlay chapter text.

### `ending-slide(body)`
Centered ending slide with 14pt text, no header/footer.

## Reusable Components

### `accent-bar(color: palette.pink, width: 6pt, height: 100%)`
Memphis left accent bar (vertical colored stripe).

```typst
#accent-bar(color: palette.blue, height: 40pt)
```

### `section-title(color, body)`
Section title with left color bar + large bold tracked text.

```typst
#section-title(palette.pink)[BY THE NUMBERS]
```

### `section-sub(body)`
Subtitle line below section title (11pt, gray, tracked).

```typst
#section-sub[FESTIVAL STATS & FIGURES]
```

### `chapter-badge(body)`
Dark skewed label badge (near-black bg, white tracked text).

```typst
#chapter-badge[CH . 01]
```

### `chapter-word(body)`
Giant chapter word (64pt, black weight, tracked).

```typst
#chapter-word[OVER\-TURE]
```

### `kpi-card(color, label, number, desc, icon: none, decoration: none)`
KPI card with colored header band + big number (64pt) + description + decorative element.

```typst
#kpi-card(palette.pink, [DAYS], [7], [NON-STOP MUSIC], icon: "D", decoration: none)
```

### `pillar-card(color, num, title, icon-area, body)`
Numbered column card with colored top band, big number (52pt), title, icon area, divider, and bullet content.

```typst
#pillar-card(palette.blue, [01], [FREE], [Icon content], [
  #memphis-bullet(palette.blue)[Feature 1]
  #memphis-bullet(palette.blue)[Feature 2]
])
```

### `memphis-bullet(color, body)`
Bullet point with colored dot.

```typst
#memphis-bullet(palette.pink)[Unlimited access to all stages]
```

### `flavor-card(color, title, badge-text, body, icon: none)`
Genre/category card with colored header, badge pill, and body content.

```typst
#flavor-card(palette.pink, [ROCK], [25 ARTISTS], [Main stage acts...], icon: "R")
```

### `hub-center(title, sub)`
Hub spoke center circle with triple ring decoration (dashed outer, decorative middle, thick pink inner).

```typst
#hub-center[SUGAR \ DOME][MAIN STAGE . 30000]
```

### `spoke-card(color, title, number, desc1, desc2, icon: none)`
Satellite stage card with colored header, large number, and description lines.

```typst
#spoke-card(palette.blue, [CHERRY STAGE], [5,000], [CAPACITY], [Day 2 Main], icon: "S")
```

### `timeline-node(color, num, star: false)`
Colored circle with day number or star symbol.

```typst
#timeline-node(palette.pink, [1]) #timeline-node(palette.mint, [7], star: true)
```

### `timeline-card(color, date-text, title, subtitle, desc)`
Timeline event card (date at top).

```typst
#timeline-card(palette.pink, [7.18], [OPENING], [Opening Night], [First show begins])
```

### `timeline-card-bottom(color, date-text, title, subtitle, desc)`
Timeline event card with date at bottom (for below-the-line placement).

### `timeline-card-dark(color, date-text, title, subtitle, desc)`
Dark timeline card for finale/closing events.

### `dark-banner(body)`
Full-width dark rounded strip for emphasis.

```typst
#dark-banner[#text(fill: white)[Important announcement content]]
```

### `ticket-card(color, title, subtitle, limit, price, features, highlight: false)`
Pricing tier card with colored header, large price (36pt), features list, and highlight option.

```typst
#ticket-card(palette.blue, [REGULAR], [Standard tier], [30000 available], [799], [
  #memphis-bullet(palette.blue)[3-day pass]
  #memphis-bullet(palette.blue)[Main stages]
])
```

### `compare-column(color, header-label, header-title, img-path, stat-num, stat-desc, stat-sub, body, icon: none, badge: none)`
Comparison column with header bar, image, stat line, and bullet list.

```typst
#compare-column(palette.pink, [2025], [Last Year], "img.jpg", [45K], [Attendance], [Peak day], [
  #memphis-bullet(palette.pink)[3 stages]
])
```

### `headliner-card(color, num, name, genre, detail1, detail2, icon: none)`
Headliner info card with icon, large number, name, genre label, and details.

```typst
#headliner-card(palette.pink, [01], [ARTIST NAME], [ROCK], [2 hours], [Main stage])
```

### `cta-button(color, body)` / `cta-button-dark(body)`
Memphis-style pill buttons.

```typst
#cta-button(palette.pink)[BUY TICKETS] #cta-button-dark[LEARN MORE]
```

### `sponsor-item(icon-text, name)`
Sponsor strip item with icon and name.

```typst
#sponsor-item([S], [Spotify]) #sponsor-item([A], [Apple Music])
```

### `page-footer(source-text)`
Page footer with source text and page number.

```typst
#page-footer[Source: Festival Organization Committee, 2026]
```

### Decorative Elements

```typst
#memphis-dots(palette.pink, palette.blue, palette.yellow)  // Colored circles
#memphis-triangle(palette.mint, size: 24pt)                 // Triangle
#memphis-zigzag(palette.pink)                               // Zigzag line
#memphis-wave(palette.blue)                                 // Wavy line
#memphis-checkerboard(size: 40pt, cell: 8pt)               // B&W checkerboard
```

## File Structure

```
sugar-rush/
  template.typ   -- Theme definition (palette, components, slides)
  demo.typ       -- Full demonstration presentation
```

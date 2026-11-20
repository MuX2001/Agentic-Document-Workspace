# 2026 普利兹克奖大师季 - Content Design Specification

> **Purpose**: Content-focused design spec for the Typst/Touying reproduction of the ppt-master reference presentation. Documents all decisions made during the Strategist phase.

## I. Project Information

| Item | Value |
| ---- | ----- |
| **Project Name** | 2026 普利兹克奖大师季 — 8 座新作 · 8 种深耕 |
| **Page Format** | PPT 16:9 (841.89pt × 473.56pt) |
| **Page Count** | 11 |
| **Style Objective** | A) General Versatile + 编辑设计 / 杂志感 / 建筑摄影主导 |
| **Complexity Level** | Canvas |
| **Target Audience** | 建筑/设计爱好者、设计行业从业者、文化媒体读者 |
| **Use Case** | 行业分享、设计课堂、自媒体长图、读书会演讲 |
| **Created Date** | 2026-05-19 |
| **Reference Source** | ppt-master `ppt169_pritzker_2026` (11 SVGs) |

## II. Theme Selection

| Property | Value |
| -------- | ----- |
| **Theme Source** | custom (reproduction-specific) |
| **Theme Name** | pritzker-2026 |
| **Entry Function** | `pritzker-theme` |
| **Template File** | `template.typ` |

### Page-level Layout Patterns

These names describe the bespoke Canvas compositions implemented with `#slide(config: ...)` in `demo.typ`; they are not exported theme functions.

| Function | Layout Pattern | Used On |
|----------|---------------|---------|
| `cover-slide` | #1 Full-bleed background + floating title | Page 1 |
| `overview-slide` | Negative-space + 4×2 card grid | Page 2 |
| `architect-fullbleed` | #41 Background + native callout cards + inset image | Page 3 |
| `architect-comparison` | #48 Side-by-side comparison + stats row | Page 4 |
| `architect-montage` | #15 Multi-image montage with bold text | Page 5 |
| `architect-backdrop` | #12 Faded backdrop + oversized number + detail inset | Page 6 |
| `architect-before-after` | #50 Before/after + massing strip + KPI stack | Page 7 |
| `architect-banner` | #14 Horizontal banner strip mid-section | Page 8 |
| `architect-floating` | #19 Images floating in whitespace with frames | Page 9 |
| `architect-annotation` | #38 Background + annotation cards overlay | Page 10 |
| `epilogue-slide` | Negative-space centered text + virtue grid | Page 11 |

### Helper Components

| Component | Purpose |
|-----------|---------|
| `gold-rule` | Decorative horizontal gold line |
| `editorial-number` | Large italic serif number (Georgia) |
| `eyebrow-label` | Small tracked uppercase gold label |
| `dark-card` | Dark background card with gold text |
| `light-card` | Light card with left gold border |

## III. Third-party Packages

| Package | Version | Import | Purpose |
| ------- | ------- | ------ | ------- |
| touying | 0.7.4 | `@preview/touying:0.7.4` | Slide framework (required) |

> No additional packages needed. All visual components implemented in `template.typ`.

## IV. Visual Design

### Color Scheme

| Role | HEX | Typst Variable |
| ---- | --- | -------------- |
| Background | `#F5F2EC` | `palette.bg` |
| Secondary bg | `#EDE8DE` | `palette.bg-alt` |
| Text (dark) | `#1C1C1C` | `palette.text-dark` |
| Accent (bronze gold) | `#85673F` | `palette.gold` |
| Gold light | `#E8C788` | `palette.gold-light` |
| Secondary text | `#5C5852` | `palette.secondary` |
| Tertiary text | `#8B8680` | `palette.tertiary` |
| Border | `#D4CFC4` | `palette.border` |
| Dark block | `#1C1C1C` | `palette.dark-block` |
| Dark bg | `#0A0A0A` | `palette.dark-bg` |

### Typography

| Role | Font | Size | Weight | Style |
| ---- | ---- | ---- | ------ | ----- |
| Cover title | Georgia / Songti SC | 30pt | Bold | — |
| Page title | same | 18–22pt | Bold | — |
| Editorial number | Georgia | 48–130pt | Regular | Italic |
| Subtitle | same | 10–13pt | Regular | Italic |
| Body | same | 9–11pt | Regular | — |
| Eyebrow | same | 9pt | Regular | Uppercase, tracked |
| Caption/meta | same | 7–8pt | Regular | — |
| Page number | same | 7pt | Regular | — |

## V. Content Outline

| Slide | Function | Title | Key Content | Layout Notes |
|-------|----------|-------|-------------|--------------|
| 1 | `cover-slide` | 2026 普利兹克奖大师季 | 8 座新作 · 8 种深耕 / info card / quote | Full-bleed `ando_h_rooftop.png`, bottom-left scrim |
| 2 | `overview-slide` | 八位大师，八种坚守 | 4×2 grid: 01-08 architects | Cream bg, gold-left-border cards |
| 3 | `architect-fullbleed` | 安藤忠雄 · 苏州 H+ 美术馆 | 2 cards (core concept + narrative) + inset image | `ando_h_exterior.png` bg, `ando_h_interior.png` inset |
| 4 | `architect-comparison` | 奇普菲尔德 · 米兰冰球馆 | Left/right comparison + 3 stats | `roman_amphitheater` vs `milan_exterior`, arrow "两千年回响" |
| 5 | `architect-montage` | 跨越江河的流动态势 | 3 bridge images + stats | Dark bg, 3 images top, text + stats bottom |
| 6 | `architect-backdrop` | 苏州河畔绽放的钢铁花瓣 | Faded bg + detail inset + multi-line quote | `foster_exterior` faded, `foster_petal` inset |
| 7 | `architect-before-after` | OMA × SANAA 纽约新美术馆 | Before/after + massing + 3 KPIs | `before`/`after`/`massing` images |
| 8 | `architect-banner` | 20 年打磨的诗意艺术方舟 | Banner image + 3 stats + quote | `zumthor_lacma_exterior.png` banner strip |
| 9 | `architect-floating` | 沙漠中的解构主义绝唱 | 3 floating framed images + manifesto | Cream bg, thin borders, negative space |
| 10 | `architect-annotation` | 夯土砖屏风 · 扎根乡土 | 3 annotation cards over bg image | `kere_exterior` bg, cards with embedded images |
| 11 | `epilogue-slide` | 所有传世的经典 | 4-column virtue grid + closing text | Cream bg, corner brackets, centered |

## VI. Image Resource List

| Filename | Used On | Purpose | Layout Pattern |
| -------- | ------- | ------- | -------------- |
| `ando_h_rooftop.png` | P01 | Cover background | #1 full-bleed |
| `ando_h_exterior.png` | P03 | Ando main background | #41 bg + callouts |
| `ando_h_interior.png` | P03 | Ando inset (vertical) | Inset frame right |
| `chipperfield_roman_amphitheater.png` | P04 | Precedent comparison | #48 side-by-side |
| `chipperfield_milan_exterior.png` | P04 | Contemporary comparison | #48 side-by-side |
| `zaha_tamkang_bridge.png` | P05 | Bridge main view | #15 montage |
| `zaha_tamkang_structure.png` | P05 | Bridge structure | #15 montage |
| `zaha_tamkang_full.png` | P05 | Bridge panorama | #15 montage |
| `foster_shanghai_exterior.png` | P06 | Faded backdrop | #12 faded bg |
| `foster_shanghai_petal.png` | P06 | Detail inset (vertical) | Framed inset |
| `oma_new_museum_before.png` | P07 | Before state | #50 before/after |
| `oma_new_museum_after.png` | P07 | After state | #50 before/after |
| `oma_new_museum_massing.png` | P07 | Massing model strip | Bottom strip |
| `zumthor_lacma_exterior.png` | P08 | Banner image | #14 mid-section |
| `gehry_abu_dhabi_render1.png` | P09 | Main floating frame | #19 floating |
| `gehry_abu_dhabi_render2.png` | P09 | Secondary frame | #19 floating |
| `gehry_abu_dhabi_render3.png` | P09 | Tertiary frame | #19 floating |
| `kere_senegal_exterior.png` | P10 | Background | #38 bg + cards |
| `kere_senegal_courtyard.png` | P10 | Card embedded image | Annotation card |
| `kere_senegal_interior.png` | P10 | Card embedded image | Annotation card |

### Unused Reference Images

| Filename | Notes |
| -------- | ----- |
| `chipperfield_milan_aerial.png` | Alternate aerial view (not in reference SVG) |
| `chipperfield_milan_facade.png` | Facade detail (reference uses it as strip, simplified) |
| `oma_new_museum_interior.png` | Interior backup |
| `zumthor_lacma_interior.png` | Interior backup |
| `zumthor_lacma_underside.png` | Underside view backup |

## VII. Layout Pattern Coverage

> Pattern IDs from `references/image-layout-patterns.md`

| Group | Pattern | Slide | Description |
|-------|---------|-------|-------------|
| A (Container) | #1 | P01 | Full-bleed background with floating title |
| A (Container) | #12 | P06 | Faded image as backdrop with oversized overlay text |
| A (Container) | #14 | P08 | Horizontal banner strip cutting through mid-section |
| A (Container) | #15 | P05 | Multi-image montage with bold text spanning across |
| C (Overlay) | #19 | P09 | Image floating in whitespace with thin frame and caption |
| D (Canvas) | #38 | P10 | Background image with annotation cards |
| D (Canvas) | #41 | P03 | Background image with native callout cards floating over |
| E (Multi-image) | #48 | P04 | Side-by-side comparison |
| E (Multi-image) | #50 | P07 | Before/after slider-style side-by-side |

**Audit**: 9 distinct patterns across 4 groups. No pattern used >2 times. No adjacent slides share a pattern.

## VIII. Reproduction Notes

### Differences from ppt-master Reference

1. **Font substitution**: Georgia + Songti SC are used as installed editorial serif families; the reusable theme does not force a document font
2. **Vector precision**: SVG can position elements at sub-pixel precision; Typst uses point-based positioning with `place()` percentage offsets
3. **Text rendering**: SVG uses `<tspan>` for precise character positioning; Typst uses natural text flow
4. **Gradient complexity**: SVG supports multi-stop gradients; Typst's `gradient.linear` handles most cases but angled multi-stop gradients need simplification
5. **Clipping shapes**: SVG supports arbitrary clip paths; Typst only supports rectangular clips via `block(clip: true)`

### What Works Well in Typst/Touying

1. Component abstraction (one function per layout variant)
2. Grid-based layouts prevent overflow naturally
3. `place()` + percentage offsets for overlays are robust
4. Image `fit: "cover"` + `clip: true` handles arbitrary aspect ratios
5. Color palette as a dictionary enables global theme changes in 1-2 lines
6. main.typ stays clean: just function calls with named parameters

// Pritzker 2026 Theme — Building-Block Architecture
// Small composable components + markup mode (== headings create slides)
// Touying 0.7.4 compatible.

#import "@preview/touying:0.7.4": *

// ═══════════════════════════════════════
// Color Palette
// ═══════════════════════════════════════

#let palette = (
  bg: rgb("#F5F2EC"),
  bg-alt: rgb("#EDE8DE"),
  text-dark: rgb("#1C1C1C"),
  // Deep architectural bronze: retains the gold identity while meeting
  // WCAG AA for small text on the cream page background.
  gold: rgb("#85673F"),
  gold-light: rgb("#E8C788"),
  secondary: rgb("#5C5852"),
  // Metadata must remain legible at the theme's deliberately small sizes.
  tertiary: rgb("#706B65"),
  border: rgb("#D4CFC4"),
  dark: rgb("#1C1C1C"),
  scrim: rgb("#0A0A0A"),
)

// ═══════════════════════════════════════
// Small Composable Components
// ═══════════════════════════════════════

/// Decorative gold horizontal rule
#let gold-rule(width: 40pt, thickness: 2pt) = {
  block(width: width, height: thickness, fill: palette.gold)
}

/// Large italic serif number (editorial style)
#let editorial-num(n, size: 48pt, opacity: 50%, color: palette.gold) = {
  text(
    font: "Georgia",
    size: size,
    fill: color.transparentize(100% - opacity),
    style: "italic",
    weight: "regular",
  )[#n]
}

/// Small tracked uppercase gold label
#let eyebrow(dark: false, body) = {
  let label-color = if dark { palette.gold-light } else { palette.gold }
  text(size: 9pt, fill: label-color, tracking: 2pt, weight: "regular")[#upper(body)]
}

/// Numbered architect card (for overview grids)
/// Usage: master-card[01][安藤忠雄][苏州 H+ 美术馆][中国苏州 2026.1]
#let master-card(num, name, project, location) = {
  block(
    width: 100%,
    height: 112pt,
    inset: (left: 12pt, rest: 6pt),
    stroke: (left: 2pt + palette.gold, rest: none),
  )[
    #stack(
      spacing: .8em,
      editorial-num(num, size: 32pt, opacity: 80%),
      text(weight: "bold", size: 11pt, fill: palette.text-dark)[#name],
      text(fill: palette.secondary, size: 8.5pt)[#project],
      text(fill: palette.tertiary, size: 7.5pt)[#location],
    )
  ]
}

/// Dark info card with gold text
/// Usage: info-card[Title][body content]
#let info-card(title, body) = {
  block(fill: palette.dark, inset: 10pt, width: 100%)[
    #stack(spacing: .8em,
      text(weight: "bold", size: 9.5pt, fill: palette.gold-light)[#title],
      [
      #set text(fill: palette.gold-light, size: 9pt)
      #body
      ],
    )
  ]
}

/// Light insight card with gold left border
/// Usage: insight-card[Title][body content]
#let insight-card(title, body) = {
  block(
    fill: palette.bg.transparentize(5%),
    inset: 10pt,
    width: 100%,
    stroke: (left: 2pt + palette.gold, rest: none),
  )[
    #stack(spacing: .8em,
      text(weight: "bold", size: 9.5pt, fill: palette.text-dark)[#title],
      [
      #set text(fill: palette.text-dark, size: 9pt)
      #body
      ],
    )
  ]
}

/// Single stat box (KPI block)
/// variant: "dark" | "light" | "gold"
#let stat-box(value, desc, variant: "dark", value-size: 14pt) = {
  let bg-fill = if variant == "dark" { palette.dark } else if variant == "gold" { palette.gold.transparentize(80%) } else { palette.bg-alt }
  let val-fill = if variant == "dark" { palette.gold-light } else { palette.text-dark }
  let desc-fill = if variant == "dark" { palette.gold-light } else { palette.secondary }
  block(fill: bg-fill, inset: 10pt, width: 100%)[
    #stack(
      spacing: .8em,
      text(size: value-size, weight: "bold", fill: val-fill, style: "italic")[#value],
      text(size: 8pt, fill: desc-fill)[#desc],
    )
  ]
}

/// Horizontal row of stat boxes
/// Usage: stat-row(stat-box(...), stat-box(...), stat-box(...))
#let stat-row(..boxes) = {
  grid(
    columns: boxes.pos().map(_ => 1fr),
    column-gutter: 8pt,
    ..boxes.pos()
  )
}

/// Framed image with optional label
/// Usage: image-frame("path.png", label: [Caption], height: 160pt)
#let image-frame(path, label: none, height: auto, frame: false) = {
  block(width: 100%)[
    #block(
      width: 100%,
      height: height,
      clip: true,
      stroke: if frame { 0.75pt + palette.gold.transparentize(30%) } else { none },
      inset: if frame { 3pt } else { 0pt },
    )[
      #image(path, width: 100%, height: 100%, fit: "cover")
    ]
    #if label != none {
      v(3pt)
      text(size: 7pt, fill: palette.tertiary)[#label]
    }
  ]
}

/// Dark gradient scrim overlay for text readability on images
/// Usage: place(bottom + left, scrim-overlay(height: 60%))
///   or wrap content: scrim-overlay[content]
#let scrim-overlay(height: 100%, body) = {
  block(width: 100%, height: height, inset: (x: 5%, bottom: 8%, top: 5%))[
    #body
  ]
}

/// Comparison arrow with label text
#let comparison-arrow(body) = {
  align(center + horizon)[
    #stack(
      spacing: .8em,
      text(size: 22pt, fill: palette.gold, style: "italic")[→],
      text(size: 8pt, fill: palette.gold)[#body],
    )
  ]
}

/// Labeled info card — light background with LABEL header + title + body
/// Usage: labeled-card("CORE CONCEPT")[Title][body]
#let labeled-card(label-text, title, body, variant: "light") = {
  let is-dark = variant == "dark"
  let bg-fill = if is-dark { palette.dark.transparentize(18%) } else { palette.bg.transparentize(5%) }
  let title-fill = if is-dark { palette.gold-light } else { palette.text-dark }
  let body-fill = if is-dark { white.transparentize(5%) } else { palette.text-dark }
  let label-fill = if is-dark { palette.gold-light } else { palette.gold }
  block(
    fill: bg-fill,
    inset: 10pt,
    width: 100%,
    stroke: if not is-dark { (left: 3pt + palette.gold, rest: none) } else { none },
  )[
    #text(size: 8pt, fill: label-fill, tracking: 2pt, weight: "regular")[#upper(label-text)]
    #v(3pt)
    #stack(spacing: .8em,
      text(weight: "bold", size: 10pt, fill: title-fill)[#title],
      [
      #gold-rule(width: 24pt, thickness: 1.5pt)
      #v(4pt)
      #set text(fill: body-fill, size: 8.5pt)
      #body
      ],
    )
  ]
}

/// Stat column with category label
/// Usage: stat-column("SCALE")[$724M][description]
#let stat-column(label-text, value, desc) = {
  block(width: 100%, inset: (left: 10pt, rest: 6pt),
    stroke: (left: 2pt + palette.gold, rest: none),
  )[
    #stack(
      spacing: .8em,
      text(size: 8pt, fill: palette.gold, tracking: 1.5pt)[#upper(label-text)],
      text(size: 16pt, weight: "bold", fill: palette.text-dark)[#value],
      text(size: 8pt, fill: palette.secondary)[#desc],
    )
  ]
}

/// Dark quote block
/// Usage: quote-block[quote text][attribution]
#let quote-block(body, attribution) = {
  block(fill: palette.dark, inset: 10pt, width: 100%,
    stroke: (left: 3pt + palette.gold, rest: none),
  )[
    #text(size: 10pt, fill: palette.gold-light, style: "italic")[#body]
    #v(6pt)
    #text(size: 7.5pt, fill: palette.border)[#attribution]
  ]
}

/// Manifesto block — vertical gold accent + labeled statement
#let manifesto-block(label-text, title, desc, tag: none) = {
  block(width: 100%, inset: (left: 12pt, rest: 0pt),
    stroke: (left: 2pt + palette.gold, rest: none),
  )[
    #text(size: 8pt, fill: palette.gold, tracking: 2pt)[#upper(label-text)]
    #v(4pt)
    #text(size: 11pt, weight: "bold", fill: palette.text-dark)[#title]
    #v(3pt)
    #text(size: 8pt, fill: palette.secondary)[#desc]
    #if tag != none {
      v(3pt)
      text(size: 9pt, fill: palette.gold, style: "italic")[#tag]
    }
  ]
}

// ═══════════════════════════════════════
// Default Slide Function (used by == headings)
// ═══════════════════════════════════════

#let slide(title: auto, align: auto, ..args) = touying-slide-wrapper(self => {
  if title != auto { self.store.title = title }
  if align != auto { self.store.align = align }
  let header(self) = {
    set std.align(top)
    show: components.cell.with(inset: (x: 2em, top: 1em))
    set std.align(horizon + left)
    stack(spacing: .8em,
      {
        set text(fill: palette.text-dark, size: 1.2em, weight: "bold")
        if self.store.title != none {
          utils.call-or-display(self, self.store.title)
        } else {
          utils.display-current-heading(level: 2)
        }
      },
      gold-rule(width: 40pt),
    )
  }
  let footer(self) = {
    set std.align(bottom)
    show: components.cell.with(inset: (x: 2em, y: 0.5em))
    set text(fill: palette.tertiary, size: 0.6em)
    block(width: 100%, above: 4pt, stroke: (top: 0.5pt + palette.border))[
      #v(4pt)
      #grid(columns: (1fr, auto), [],
        context { text[#utils.slide-counter.display() / #utils.last-slide-number] })
    ]
  }
    let setting(body) = {
    show: std.align.with(self.store.align)
    body
  }
self = utils.merge-dicts(self, config-page(header: header, footer: footer))
  touying-slide(self: self, setting: setting, ..args)
})

// ═══════════════════════════════════════
// Special Slide Functions
// ═══════════════════════════════════════

/// Title/Cover slide — full-bleed background with scrim + title overlay
#let title-slide(
  bg-image: none,
  title: auto,
  subtitle: auto,
  info-line1: none,
  info-line2: none,
  quote-text: none,
  source: none,
) = touying-slide-wrapper(self => {
  let info = self.info
  let t = if title != auto { title } else { info.title }
  let s = if subtitle != auto { subtitle } else { info.subtitle }
  let body = {
    if bg-image != none {
      place(top + left, block(width: 100%, height: 100%, clip: true)[
        #image(bg-image, width: 100%, height: 100%, fit: "cover")
      ])
    } else {
      place(top + left, block(width: 100%, height: 100%, fill: rgb("#3A3530")))
    }
    // Scrims
    place(top + left, block(width: 60%, height: 100%,
      fill: gradient.linear(palette.scrim.transparentize(5%), palette.scrim.transparentize(100%), angle: 0deg)))
    place(bottom + left, block(width: 100%, height: 50%,
      fill: gradient.linear(palette.scrim.transparentize(100%), palette.scrim.transparentize(0%))))
    // Eyebrow
    place(top + left, dx: 5%, dy: 7%)[
      #grid(columns: (auto, auto), column-gutter: 8pt, align: horizon,
        block(width: 28pt, height: 2pt, fill: palette.gold),
        eyebrow(dark: true)[PRITZKER PRIZE · 2026],
      )
    ]
    // Title
    place(left + horizon, dx: 5%, dy: -14%)[
      #block(width: 52%)[
        #text(size: 40pt, fill: white, weight: "bold")[#t]
        #v(10pt)
        #text(size: 22pt, fill: palette.gold-light, style: "italic")[#s]
      ]
    ]
    // Info lines with gold vertical bar
    place(bottom + left, dx: 5%, dy: -22%)[
      #block(width: 42%)[
        #block(inset: (left: 12pt), stroke: (left: 2pt + palette.gold, rest: none))[
          #if info-line1 != none or info-line2 != none {
            set text(fill: white, size: 12pt)
            if info-line1 != none { info-line1; linebreak() }
            if info-line2 != none { info-line2 }
          }
        ]
        #v(8pt)
        #if quote-text != none {
          text(size: 9pt, fill: palette.border, style: "italic")[#quote-text]
        }
      ]
    ]
    // Footer
    place(bottom + left, dx: 5%, dy: -4%)[
      #if source != none { text(size: 7.5pt, fill: palette.border)[#source] }
    ]
    place(bottom + right, dx: -5%, dy: -4%)[
      #text(size: 7.5pt, fill: palette.border)[PPT MASTER · 2026.05]
    ]
  }
  self = utils.merge-dicts(self, config-page(header: none, footer: none, margin: 0pt))
  touying-slide(self: self, body)
})

/// Focus slide — centered statement on cream bg with optional corner brackets
#let focus-slide(brackets: false, footer-left: none, footer-right: none, body) = touying-slide-wrapper(self => {
  let content = {
    if brackets {
      // Top-left corner bracket
      place(top + left, dx: 4.5%, dy: 6%)[
        #block[
          #block(width: 40pt, height: 1pt, fill: palette.gold)
          #block(width: 1pt, height: 40pt, fill: palette.gold)
        ]
      ]
      // Bottom-right corner bracket
      place(bottom + right, dx: -4.5%, dy: -6%)[
        #std.align(bottom + right)[
          #block(width: 1pt, height: 40pt, fill: palette.gold)
          #block(width: 40pt, height: 1pt, fill: palette.gold)
        ]
      ]
    }
    // Footer
    if footer-left != none or footer-right != none {
      place(bottom + left, dx: 5%, dy: -3%)[
        #block(width: 90%)[
          #grid(columns: (1fr, auto),
            if footer-left != none { text(size: 7pt, fill: palette.tertiary)[#footer-left] } else { [] },
            if footer-right != none { text(size: 7pt, fill: palette.tertiary)[#footer-right] } else { [] },
          )
        ]
      ]
    }
    set std.align(center + horizon)
    set text(fill: palette.text-dark, size: 14pt)
    pad(x: 8%, body)
  }
  self = utils.merge-dicts(self, config-page(
    header: none, footer: none,
    margin: (x: 2em, y: 1.5em),
  ))
  touying-slide(self: self, content)
})

/// Ending slide
#let ending-slide(body) = touying-slide-wrapper(self => {
  let content = {
    set std.align(center + horizon)
    set text(fill: palette.text-dark, size: 14pt)
    pad(x: 10%, body)
  }
  self = utils.merge-dicts(self, config-page(header: none, footer: none, margin: 2em))
  touying-slide(self: self, content)
})

// ═══════════════════════════════════════
// Theme Entry Point
// ═══════════════════════════════════════

#let pritzker-theme(
  aspect-ratio: "16-9",
  align: horizon,
  ..args,
  body,
) = {
  set text(size: 12pt, fill: palette.text-dark)

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      fill: palette.bg,
      margin: (top: 3em, bottom: 1.5em, x: 2em),
    ),
    config-common(
      slide-fn: slide,
      breakable: false,
    ),
    config-store(
      title: none,
      align: align,
    ),
    config-colors(
      primary: palette.gold,
      primary-dark: palette.dark,
      neutral-lightest: palette.bg,
      neutral-darkest: palette.text-dark,
    ),
    ..args,
  )

  body
}

// Indie Bookstore Zine Guide — Risograph Zine Aesthetic
// Building-block architecture: small composable components + markup mode
// Touying 0.7.4 compatible.

#import "@preview/touying:0.7.4": *

// ===================================================
// Color Palette — Riso duotone + warm cream paper
// ===================================================

#let palette = (
  bg: rgb("#F5EFE0"),          // warm cream / kraft paper
  bg-alt: rgb("#EAE2CC"),      // darker cream for cards
  blue: rgb("#1E4DBC"),        // Federal Blue (Riso primary)
  pink: rgb("#FF5C8A"),        // Fluorescent Pink (Riso accent)
  mustard: rgb("#E8A02E"),     // mustard highlight (<5% usage)
  text-dark: rgb("#1A1A1A"),   // near-black body text
  text-sec: rgb("#5A5A5A"),    // annotation gray
  text-tert: rgb("#8C8275"),   // tertiary / faint
  border: rgb("#1A1A1A"),      // dividers (zine = near-black)
)

// ===================================================
// Small Composable Components
// ===================================================

/// Riso-style misregistered block — colored square with offset shadow
/// Used for TOC numbered squares, icon backgrounds, etc.
#let riso-square(size: 50pt, fill-color: palette.blue, body) = {
  block(width: size, height: size)[
    #place(top + left, dx: 2pt, dy: 2pt,
      block(width: size, height: size, fill: palette.pink.transparentize(45%)))
    #place(top + left,
      block(width: size, height: size, fill: fill-color))
    #place(center + horizon)[
      #set align(center)
      #body
    ]
  ]
}

/// Section eyebrow — monospace tracked uppercase label
#let eyebrow(body) = {
  text(
    size: 8pt,
    fill: palette.text-sec,
    tracking: 2pt,
    font: ("Menlo",),
    weight: "regular",
  )[#upper(body)]
}

/// Zine-style title accent bar — vertical colored stripe before title
#let title-bar(color: palette.blue, width: 10pt, height: 44pt) = {
  block(width: width, height: height, fill: color)
}

/// Hard-edge card (0px border-radius, zine aesthetic)
/// variant: "cream" | "blue" | "pink" | "mustard" | "dark"
#let zine-card(variant: "cream", body) = {
  let bg-fill = if variant == "cream" { palette.bg-alt }
    else if variant == "blue" { palette.blue }
    else if variant == "pink" { palette.pink }
    else if variant == "mustard" { palette.mustard }
    else if variant == "dark" { palette.text-dark }
    else { palette.bg-alt }
  let txt-fill = if variant == "cream" { palette.text-dark }
    else if variant == "dark" { palette.bg }
    else if variant == "blue" { palette.bg }
    else if variant == "pink" { palette.text-dark }
    else if variant == "mustard" { palette.text-dark }
    else { palette.text-dark }
  block(fill: bg-fill, inset: 12pt, width: 100%, radius: 0pt)[
    #set text(fill: txt-fill)
    #body
  ]
}

/// Numbered step circle (for action checklist / process flows)
/// variant: "blue" | "pink" | "mustard" | "dark"
#let step-circle(num, size: 60pt, variant: "blue") = {
  let fill-color = if variant == "blue" { palette.blue }
    else if variant == "pink" { palette.pink }
    else if variant == "mustard" { palette.mustard }
    else { palette.text-dark }
  circle(radius: size / 2, fill: fill-color, stroke: none)[
    #set align(center + horizon)
    #text(size: size * 0.5, fill: palette.bg, weight: "bold",
      font: ("Arial",))[#num]
  ]
}

/// Step arrow connector
#let step-arrow(size: 18pt) = {
  align(center + horizon)[
    #text(size: size, fill: palette.text-dark, weight: "bold")[#sym.arrow.r]
  ]
}

/// Timeline node marker (vertical tick on horizontal axis)
#let timeline-tick() = {
  block(width: 3pt, height: 12pt, fill: palette.text-dark)
}

/// Riso-style halftone dot bar (decorative, simulates halftone pattern)
#let halftone-bar(width: 100%, height: 4pt, color: palette.blue) = {
  block(width: width, height: height, fill: color.transparentize(60%))
}

/// Monospace caption — Menlo annotation text
#let mono-caption(body) = {
  text(
    size: 7.5pt,
    fill: palette.text-sec,
    tracking: 1.5pt,
    font: ("Menlo",),
  )[#upper(body)]
}

/// Icon placeholder — simple block with icon-like symbol
/// Uses a bold character as icon stand-in since we cannot embed SVG icons
#let icon-block(symbol, size: 28pt, color: palette.bg) = {
  text(size: size, fill: color, weight: "bold", font: "Arial")[#symbol]
}

/// Image frame with hard edge (zine aesthetic, no border-radius)
#let zine-image(path, height: auto, width: 100%) = {
  block(width: width, height: height, clip: true, radius: 0pt)[
    #image(path, width: 100%, height: 100%, fit: "cover")
  ]
}

/// Dark scrim overlay for text readability on images
#let scrim-gradient(angle: 0deg, opacity-start: 92%, opacity-end: 0%) = {
  block(width: 100%, height: 100%,
    fill: gradient.linear(
      palette.bg.transparentize(100% - opacity-start),
      palette.bg.transparentize(100% - opacity-end),
      angle: angle,
    ))
}

/// Page footer — zine style with near-black rule + monospace text
#let zine-footer(left-text, right-text) = {
  block(width: 100%, above: 2pt)[
    #stack(spacing: .8em,
      line(length: 100%, stroke: 0.75pt + palette.border),
      grid(columns: (1fr, auto),
        mono-caption(left-text),
        mono-caption(right-text),
      ),
    )
  ]
}

/// Page footer with auto page numbers
#let zine-footer-auto(left-text, right-text) = {
  place(bottom + left, dx: 5%, dy: -3%)[
    #block(width: 90%)[
      #stack(spacing: .8em,
        line(length: 100%, stroke: 0.75pt + palette.border),
        grid(columns: (1fr, auto),
          mono-caption(left-text),
          mono-caption(right-text),
        ),
      )
    ]
  ]
}

/// Table row for bookstore map
#let table-row(store, city, character, zine-level, is-header: false, stripe: false) = {
  let bg = if is-header { palette.bg-alt } else if stripe { palette.bg.transparentize(50%) } else { white.transparentize(95%) }
  let weight = if is-header { "bold" } else { "regular" }
  let txt-size = if is-header { 8pt } else { 9pt }
  let level-color = if zine-level == "***" { palette.pink }
    else if zine-level == "**" { palette.mustard }
    else if zine-level == "*" { palette.blue }
    else { palette.text-sec }
  block(fill: bg, width: 100%, inset: (x: 8pt, y: 5pt), radius: 0pt)[
    #grid(columns: (22%, 12%, 50%, 16%),
      column-gutter: 4pt,
      text(size: txt-size, weight: weight, fill: palette.text-dark, font: if is-header { ("Menlo",) } else { ("Heiti SC",) })[#store],
      text(size: txt-size, weight: weight, fill: palette.text-dark)[#city],
      text(size: txt-size, weight: weight, fill: palette.text-sec)[#character],
      align(center, text(size: txt-size, weight: "bold", fill: level-color)[#zine-level]),
    )
  ]
}

/// Labeled info card for book fairs etc.
#let info-card(label-text, title-text, body, variant: "blue") = {
  let accent = if variant == "blue" { palette.blue } else if variant == "pink" { palette.pink } else { palette.mustard }
  block(width: 100%, inset: 14pt, radius: 0pt,
    stroke: (left: 4pt + accent, rest: 0.5pt + palette.border.transparentize(80%)),
    fill: palette.bg,
  )[
    #stack(spacing: .8em,
      text(size: 8pt, fill: accent, tracking: 2pt, font: ("Menlo",), weight: "bold")[#upper(label-text)],
      text(size: 12pt, weight: "bold", fill: palette.text-dark)[#title-text],
      stack(spacing: .8em,
        line(length: 30pt, stroke: 1.5pt + accent),
        [#set text(size: 9pt, fill: palette.text-dark)
         #body],
      ),
    )
  ]
}

/// Vertical pillar card (for three-cities layout)
#let pillar-card(city, store-name, body, accent: palette.blue) = {
  block(width: 100%, inset: 12pt, radius: 0pt, fill: palette.bg-alt,
    stroke: (top: 4pt + accent, rest: none),
  )[
    #stack(spacing: .8em,
      text(size: 8pt, fill: accent, tracking: 1.5pt, font: ("Menlo",))[#upper(city)],
      text(size: 12pt, weight: "bold", fill: palette.text-dark)[#store-name],
      stack(spacing: .8em,
        line(length: 24pt, stroke: 1.5pt + accent),
        [#set text(size: 8.5pt, fill: palette.text-dark)
         #body],
      ),
    )
  ]
}

/// Numbered list item with bold number
#let numbered-item(num, title-text, body, accent: palette.pink) = {
  grid(columns: (36pt, 1fr), column-gutter: 8pt,
    text(size: 22pt, weight: "bold", fill: accent,
      font: ("Arial",))[#num],
    [
      #stack(spacing: .8em,
        text(size: 11pt, weight: "bold", fill: palette.text-dark)[#title-text],
        [#set text(size: 9pt, fill: palette.text-sec)
         #body],
      )
    ],
  )
}

/// Rich card-based numbered list row (for How to Browse / How to Collect)
/// Colored number square + dashed connector + icon square + dark stripe card with title + desc
#let rich-numbered-row(num, title-text, desc, accent: palette.blue, icon-symbol: none) = {
  grid(columns: (56pt, auto, ..if icon-symbol != none { (42pt,) } else { () }, 1fr), column-gutter: 0pt, align: horizon,
    // Number square with pink bottom stripe (riso offset effect)
    block(width: 52pt, height: 58pt, radius: 0pt)[
      #place(top + left, block(width: 52pt, height: 52pt, fill: accent, stroke: none, radius: 0pt)[
        #align(center + horizon)[#text(size: 22pt, fill: white, weight: "bold", font: ("Arial",))[#num]]
      ])
      #place(bottom + left, block(width: 52pt, height: 6pt, fill: palette.pink, radius: 0pt))
    ],
    // dashed connector
    block(width: 24pt, height: 2pt)[
      #place(horizon, line(length: 24pt, stroke: (paint: palette.blue, thickness: 1.5pt, dash: "dashed")))
    ],
    // Optional icon square
    ..if icon-symbol != none {(
      block(width: 38pt, height: 38pt, fill: accent.lighten(15%), radius: 0pt)[
        #align(center + horizon)[#text(size: 20pt, fill: white, weight: "bold")[#icon-symbol]]
      ],
    )} else {()},
    block(fill: palette.text-dark.transparentize(92%), width: 100%, inset: (x: 14pt, y: 10pt), radius: 0pt,
      stroke: (bottom: 0.5pt + palette.border.transparentize(70%)),
    )[
      #stack(spacing: .8em,
        text(weight: "bold", size: 13pt, fill: palette.text-dark)[#title-text],
        text(size: 9pt, fill: palette.text-sec)[#desc],
      )
    ],
  )
}

/// Vertical list item with blue number + gold rule
#let vlist-item(num, title-text, desc, accent: palette.blue) = {
  block(width: 100%, inset: (left: 10pt, rest: 4pt),
    stroke: (left: 3pt + accent, rest: none),
  )[
    #stack(spacing: .8em,
      text(size: 8pt, fill: accent, tracking: 1.5pt, font: ("Menlo",))[#num],
      text(size: 10pt, weight: "bold", fill: palette.text-dark)[#title-text],
      [#set text(size: 8pt, fill: palette.text-sec)
       #desc],
    )
  ]
}

// ===================================================
// Default Slide Function (used by == headings)
// ===================================================

#let slide(title: auto, align: auto, ..args) = touying-slide-wrapper(self => {
  if title != auto { self.store.title = title }
  if align != auto { self.store.align = align }
  let header(self) = {
    set align(top)
    show: components.cell.with(inset: (x: 2em, top: 0.8em))
    set align(horizon + left)
    grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
      block(width: 8pt, height: 36pt, fill: palette.blue),
      {
        set text(fill: palette.text-dark, size: 1.4em, weight: "bold",
          font: ("Heiti SC",))
        if self.store.title != none {
          utils.call-or-display(self, self.store.title)
        } else {
          utils.display-current-heading(level: 2)
        }
      },
    )
  }
  let footer(self) = {
    set align(bottom)
    show: components.cell.with(inset: (x: 2em, y: 0.4em))
    set text(fill: palette.text-sec, size: 0.5em,
      font: ("Menlo",), tracking: 1.5pt)
    block(width: 100%, above: 2pt, stroke: (top: 0.75pt + palette.border))[
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

// ===================================================
// Special Slide Functions
// ===================================================

/// Title/Cover slide — full-bleed with riso overlay
#let title-slide(
  bg-image: none,
  title: auto,
  subtitle: auto,
  info-text: none,
) = touying-slide-wrapper(self => {
  let info = self.info
  let t = if title != auto { title } else { info.title }
  let s = if subtitle != auto { subtitle } else { info.subtitle }
  let body = {
    // Background image
    if bg-image != none {
      place(top + left, block(width: 100%, height: 100%, clip: true)[
        #image(bg-image, width: 100%, height: 100%, fit: "cover")
      ])
    } else {
      place(top + left, block(width: 100%, height: 100%, fill: palette.blue))
    }
    // Left scrim for text legibility — stronger blue tint for riso feel
    place(top + left, block(width: 60%, height: 100%,
      fill: gradient.linear(
        palette.bg.transparentize(2%),
        palette.bg.transparentize(50%),
        palette.bg.transparentize(100%),
        angle: 0deg)))
    // Bottom scrim
    place(bottom + left, block(width: 100%, height: 40%,
      fill: gradient.linear(
        palette.bg.transparentize(100%),
        palette.bg.transparentize(15%),
      )))
    // Top-left: ISSUE No1 · 2026
    place(top + left, dx: 5%, dy: 5%)[
      #mono-caption[ISSUE No1 #sym.dot.c 2026]
    ]
    // Top-right: PPT MASTER · RISO ZINE DEMO
    place(top + right, dx: -5%, dy: 5%)[
      #mono-caption[PPT MASTER #sym.dot.c RISO ZINE DEMO]
    ]
    // Subtitle at right area — larger text, stacked
    place(top + right, dx: -5%, dy: 22%)[
      #block(width: 28%)[
        #set align(right)
        #text(size: 16pt, fill: palette.text-dark, weight: "bold",
          font: ("Heiti SC",))[#s]
      ]
    ]
    // Title with pink misregistered shadow at bottom-left
    place(left + bottom, dx: 5%, dy: -16%)[
      #block(width: 52%)[
        // Pink shadow offset
        #place(dx: 3pt, dy: 3pt)[
          #text(size: 72pt, fill: palette.pink.transparentize(40%), weight: "black",
            font: ("Arial", "Heiti SC"),
          )[#t]
        ]
        #text(size: 72pt, fill: palette.blue, weight: "black",
          font: ("Arial", "Heiti SC"),
        )[#t]
      ]
    ]
    // Info at bottom
    place(bottom + left, dx: 5%, dy: -8%)[
      #block(width: 60%)[
        #if info-text != none {
          text(size: 8pt, fill: palette.text-sec, font: ("Menlo",), tracking: 1pt)[#info-text]
        }
      ]
    ]
    // Footer decorations
    place(bottom + left, dx: 5%, dy: -3%)[
      #mono-caption[PPT Master Riso]
    ]
    place(bottom + right, dx: -5%, dy: -3%)[
      #mono-caption[2026]
    ]
  }
  self = utils.merge-dicts(self, config-page(header: none, footer: none, margin: 0pt))
  touying-slide(self: self, body)
})

/// Focus slide — centered statement (for hero city pages, outro)
#let focus-slide(body) = touying-slide-wrapper(self => {
  let content = {
    set align(center + horizon)
    set text(fill: palette.text-dark, size: 14pt)
    pad(x: 8%, body)
  }
  self = utils.merge-dicts(self, config-page(
    header: none, footer: none,
    margin: (x: 2em, y: 2em),
  ))
  touying-slide(self: self, content)
})

/// Hero slide — full-bleed background image with overlay content
#let hero-slide(bg-image, body) = touying-slide-wrapper(self => {
  let content = {
    place(top + left, block(width: 100%, height: 100%, clip: true)[
      #image(bg-image, width: 100%, height: 100%, fit: "cover")
    ])
    body
  }
  self = utils.merge-dicts(self, config-page(header: none, footer: none, margin: 0pt))
  touying-slide(self: self, content)
})

/// Ending slide — outro with background
#let ending-slide(bg-image: none, body) = touying-slide-wrapper(self => {
  let content = {
    if bg-image != none {
      place(top + left, block(width: 100%, height: 100%, clip: true)[
        #image(bg-image, width: 100%, height: 100%, fit: "cover")
      ])
    }
    // Left scrim
    place(top + left, block(width: 60%, height: 100%,
      fill: gradient.linear(
        palette.bg.transparentize(6%),
        palette.bg.transparentize(100%),
        angle: 0deg)))
    body
  }
  self = utils.merge-dicts(self, config-page(header: none, footer: none, margin: 0pt))
  touying-slide(self: self, content)
})

// ===================================================
// Theme Entry Point
// ===================================================

#let zine-theme(
  aspect-ratio: "16-9",
  align: horizon,
  ..args,
  body,
) = {
  set text(
    size: 11pt,
    fill: palette.text-dark,
    font: ("Heiti SC", "Arial"),
  )

  show: touying-slides.with(
    config-page(
      paper: "presentation-16-9",
      fill: palette.bg,
      margin: (top: 2.5em, bottom: 1.5em, x: 2em),
    ),
    config-common(
      slide-fn: slide,
      breakable: false,
    ),
    config-store(
      title: none,
      align: align,
    ),
    ..args,
  )

  body
}

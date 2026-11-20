// Sugar Rush Memphis Theme — Building-Block Architecture
// Candy-colored, 80s retro revival, bold playful geometry
// Touying 0.7.4 compatible.

#import "@preview/touying:0.7.4": *

// ===================================================
// Color Palette
// ===================================================

#let palette = (
  bg: rgb("#FFF8EE"),
  bg-alt: rgb("#FFE9C7"),
  pink: rgb("#FF3DA5"),
  blue: rgb("#00B8D9"),
  yellow: rgb("#FFD93D"),
  mint: rgb("#00C896"),
  coral: rgb("#FF6B4A"),
  ink: rgb("#1A1A2E"),
  gray: rgb("#5C5C7A"),
  white: rgb("#FFFFFF"),
)

// ===================================================
// Small Composable Components
// ===================================================

/// Memphis left accent bar (replaces gold-rule from pritzker)
#let accent-bar(color: palette.pink, width: 6pt, height: 100%) = {
  block(width: width, height: height, fill: color, radius: 0pt)
}

/// Section title with left color bar
/// Usage: section-title(palette.pink)[BY THE NUMBERS]
#let section-title(color, body) = {
  grid(columns: (6pt, auto), column-gutter: 12pt, align: horizon,
    block(width: 6pt, height: 36pt, fill: color),
    text(size: 28pt, weight: "black", fill: palette.ink, tracking: 1.5pt, font: ("Arial", "Arial Unicode MS"))[#body],
  )
}

/// Subtitle line below section title
#let section-sub(body) = {
  text(size: 11pt, fill: palette.gray, tracking: 2pt, font: ("Arial", "Arial Unicode MS"))[#body]
}

/// Memphis chapter badge — dark skewed label
/// Usage: chapter-badge[CH . 01]
#let chapter-badge(body) = {
  block(fill: palette.ink, inset: (x: 12pt, y: 6pt), radius: 2pt)[
    #text(size: 9pt, fill: palette.white, tracking: 3pt, weight: "bold")[#body]
  ]
}

/// Giant chapter word for chapter dividers
#let chapter-word(body) = {
  text(size: 64pt, weight: "black", fill: palette.ink, tracking: 3pt, font: ("Arial", "Arial Unicode MS"))[#body]
}

/// Memphis KPI card with colored header band + big number + description
/// Usage: kpi-card(palette.pink, [DAYS], [7], [连续狂欢 / NON-STOP], icon: "◆")
#let kpi-card(color, label, number, desc, icon: none, decoration: none) = {
  block(width: 100%, stroke: 3pt + palette.ink, radius: 8pt)[
    // Colored header band with icon
    #block(width: 100%, fill: color, inset: (x: 12pt, y: 8pt))[
      #set text(fill: if color == palette.yellow { palette.ink } else { palette.white })
      #grid(columns: (auto, auto), column-gutter: 8pt, align: horizon,
        if icon != none { text(size: 14pt, weight: "bold")[#icon] },
        text(size: 11pt, weight: "bold", tracking: 2pt)[#label],
      )
    ]
    // Number + description body with decorative element
    #block(width: 100%, fill: palette.bg, inset: (x: 16pt, y: 14pt))[
      #stack(spacing: .8em,
        grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
          text(size: 64pt, weight: "black", fill: palette.ink, font: ("Arial", "Arial Unicode MS"))[#number],
          // Decorative element (wave, triangle, dots etc.)
          if decoration != none { decoration } else {
            stack(dir: ltr, spacing: 3pt,
              circle(radius: 3pt, fill: color.lighten(40%), stroke: none),
              circle(radius: 5pt, fill: color.lighten(20%), stroke: none),
              circle(radius: 3pt, fill: color, stroke: none),
            )
          },
        ),
        text(size: 10pt, fill: palette.gray, tracking: 1pt)[#desc],
      )
    ]
  ]
}

/// Memphis pillar card — numbered column with color header + icon area + bullet list
/// Usage: pillar-card(palette.pink, [01], [FREE], icon-content, body)
#let pillar-card(color, num, title, icon-area, body) = {
  block(width: 100%, stroke: 3pt + palette.ink, radius: 8pt)[
    // Colored top band with big number + title
    #block(width: 100%, fill: color, inset: (x: 14pt, y: 8pt))[
      #align(center)[
        #stack(spacing: .8em,
          text(size: 52pt, weight: "black", fill: if color == palette.yellow { palette.ink } else { palette.white }, font: ("Arial", "Arial Unicode MS"))[#num],
          text(size: 11pt, fill: if color == palette.yellow { palette.ink } else { palette.white }, tracking: 3pt, weight: "bold")[#title],
        )
      ]
    ]
    // Icon + subtitle area
    #block(width: 100%, fill: palette.bg, inset: (x: 14pt, y: 6pt))[
      #icon-area
    ]
    // Divider
    #block(width: 100%, inset: (x: 14pt))[
      #line(length: 60%, stroke: 1pt + palette.ink)
    ]
    // Bullet list
    #block(width: 100%, fill: palette.bg, inset: (x: 14pt, y: 6pt))[
      #body
    ]
  ]
}

/// Memphis bullet point with colored dot
/// Usage: memphis-bullet(palette.pink)[Text here]
#let memphis-bullet(color, body) = {
  grid(columns: (12pt, 1fr), column-gutter: 6pt, align: (center + horizon, left + horizon),
    circle(radius: 4pt, fill: color, stroke: none),
    text(size: 11pt, fill: palette.ink)[#body],
  )
}

/// Flavor quadrant card — genre card with colored left border + header
/// Usage: flavor-card(palette.pink, [ROCK . 摇滚], [25 组艺人], body, icon: "⚡")
#let flavor-card(color, title, badge-text, body, icon: none) = {
  block(width: 100%, stroke: 3pt + palette.ink, radius: 8pt)[
    // Header with colored bg
    #block(width: 100%, fill: color, inset: (x: 14pt, y: 10pt))[
      #set text(fill: if color == palette.yellow { palette.ink } else { palette.white })
      #grid(columns: (auto, 1fr, auto), column-gutter: 8pt, align: (left + horizon, left + horizon, right + horizon),
        if icon != none { text(size: 20pt, weight: "bold")[#icon] } else { [] },
        text(size: 16pt, weight: "bold", tracking: 1pt)[#title],
        block(fill: palette.bg, inset: (x: 10pt, y: 4pt), radius: 12pt, stroke: 2pt + palette.ink)[
          #text(size: 8pt, fill: palette.ink, weight: "bold")[#badge-text]
        ],
      )
    ]
    // Body content
    #block(width: 100%, fill: palette.bg, inset: (x: 14pt, y: 10pt))[
      #body
    ]
  ]
}

/// Hub spoke center circle with double ring
/// Usage: hub-center[SUGAR \ DOME][主舞台 . 30000]
#let hub-center(title, sub) = {
  align(center)[
    // Outermost dashed orbit ring
    #block(width: 220pt, height: 220pt, radius: 110pt, stroke: (dash: "dashed", paint: palette.pink.lighten(60%), thickness: 1.5pt), fill: none)[
      #align(center + horizon)[
        // Outer decorative ring
        #block(width: 170pt, height: 170pt, radius: 85pt, stroke: 2pt + palette.pink.lighten(40%), fill: none)[
          #align(center + horizon)[
            // Inner main circle
            #block(width: 146pt, height: 146pt, radius: 73pt, stroke: 6pt + palette.pink, fill: palette.bg)[
              #align(center + horizon)[
                #stack(spacing: .8em,
                  text(size: 16pt, fill: palette.pink)[♪],
                  text(size: 17pt, weight: "black", fill: palette.ink, tracking: 2pt, font: ("Arial", "Arial Unicode MS"))[#title],
                  text(size: 8pt, fill: palette.pink, tracking: 1pt)[#sub],
                )
              ]
            ]
          ]
        ]
      ]
    ]
  ]
}

/// Spoke card — satellite stage card
/// Usage: spoke-card(palette.pink, [CHERRY STAGE . 摇滚], [5,000], [观众容量 . 西北区], [Day 2 主场 . 全程户外], icon: "⚡")
#let spoke-card(color, title, number, desc1, desc2, icon: none) = {
  block(width: 100%, stroke: 3pt + palette.ink, radius: 8pt)[
    #block(width: 100%, fill: color, inset: (x: 10pt, y: 5pt))[
      #text(size: 9pt, fill: if color == palette.yellow { palette.ink } else { palette.white }, tracking: 1.5pt, weight: "bold")[#title]
    ]
    #block(width: 100%, fill: palette.bg, inset: (x: 10pt, y: 6pt))[
      #stack(spacing: .8em,
        grid(columns: (auto, auto), column-gutter: 6pt, align: horizon,
          if icon != none { text(size: 16pt, fill: color)[#icon] } else { [] },
          text(size: 20pt, weight: "black", fill: palette.ink, font: ("Arial", "Arial Unicode MS"))[#number],
        ),
        text(size: 8pt, fill: palette.gray)[#desc1],
        text(size: 8pt, fill: palette.gray)[#desc2],
      )
    ]
  ]
}

/// Timeline node — colored circle with day number
#let timeline-node(color, num, star: false) = {
  align(center)[
    #circle(radius: 14pt, fill: color, stroke: none)[
      #align(center + horizon)[
        #if star {
          text(size: 14pt, weight: "bold", fill: palette.white)[★]
        } else {
          text(size: 11pt, weight: "bold", fill: palette.white)[#num]
        }
      ]
    ]
  ]
}

/// Timeline event card (above or below the line)
/// Usage: timeline-card(palette.pink, [7.18], [OPENING], [开幕之夜], [CHERRY BOMB 开场])
#let timeline-card(color, date-text, title, subtitle, desc) = {
  block(width: 100%, stroke: 2pt + palette.ink, radius: 6pt)[
    #block(width: 100%, fill: if color != none { color.lighten(85%) } else { palette.bg }, inset: (x: 6pt, y: 3pt))[
      #text(size: 7pt, fill: palette.gray, tracking: 1pt, weight: "bold")[#date-text]
    ]
    #block(width: 100%, fill: palette.bg, inset: (x: 6pt, y: 4pt))[
      #text(size: 9pt, weight: "bold", fill: palette.ink, tracking: 0.5pt)[#title]
      #v(1pt)
      #text(size: 8pt, fill: palette.pink)[#subtitle]
      #v(1pt)
      #text(size: 7pt, fill: palette.gray)[#desc]
    ]
  ]
}

/// Timeline event card — date at bottom (for below-the-line cards)
#let timeline-card-bottom(color, date-text, title, subtitle, desc) = {
  block(width: 100%, stroke: 2pt + palette.ink, radius: 6pt)[
    #block(width: 100%, fill: palette.bg, inset: (x: 6pt, y: 4pt))[
      #text(size: 9pt, weight: "bold", fill: palette.ink, tracking: 0.5pt)[#title]
      #v(1pt)
      #text(size: 8pt, fill: palette.pink)[#subtitle]
      #v(1pt)
      #text(size: 7pt, fill: palette.gray)[#desc]
    ]
    #block(width: 100%, fill: color, inset: (x: 6pt, y: 3pt))[
      #text(size: 7pt, fill: palette.white, tracking: 1pt, weight: "bold")[#date-text]
    ]
  ]
}

/// Dark timeline card (for the closing/finale)
#let timeline-card-dark(color, date-text, title, subtitle, desc) = {
  block(width: 100%, stroke: 2pt + palette.pink, radius: 6pt)[
    #block(width: 100%, fill: palette.ink, inset: (x: 6pt, y: 3pt))[
      #text(size: 7pt, fill: palette.bg, tracking: 1pt, weight: "bold")[#date-text]
    ]
    #block(width: 100%, fill: palette.ink, inset: (x: 6pt, y: 4pt))[
      #text(size: 9pt, weight: "bold", fill: palette.white, tracking: 0.5pt)[#title]
      #v(1pt)
      #text(size: 8pt, fill: palette.pink)[#subtitle]
      #v(1pt)
      #text(size: 7pt, fill: palette.bg.darken(30%))[#desc]
    ]
  ]
}

/// Dark info banner — full-width dark strip with content
#let dark-banner(body) = {
  block(width: 100%, fill: palette.ink, inset: (x: 20pt, y: 14pt), radius: 8pt)[
    #body
  ]
}

/// Ticket card — pricing tier
/// Usage: ticket-card(palette.blue, [REGULAR], [日常档 . 主力推荐], [限量 30000 张], [799], features, highlight: true)
#let ticket-card(color, title, subtitle, limit, price, features, highlight: false) = {
  block(width: 100%, stroke: 3pt + palette.ink, radius: 8pt)[
    // Header
    #block(width: 100%, fill: color, inset: (x: 12pt, y: 6pt))[
      #text(size: 18pt, weight: "black", fill: if color == palette.yellow { palette.ink } else { palette.white }, tracking: 2pt, font: ("Arial", "Arial Unicode MS"))[#title]
      #v(1pt)
      #if subtitle != none {
        text(size: 7pt, fill: if color == palette.yellow { palette.ink.lighten(20%) } else { palette.white.darken(10%) }, weight: "bold")[#subtitle]
      }
      #v(1pt)
      #text(size: 7pt, fill: if color == palette.yellow { palette.ink.lighten(30%) } else { palette.white.darken(15%) }, weight: "bold")[#limit]
    ]
    // Price
    #block(width: 100%, fill: palette.bg, inset: (x: 12pt, y: 5pt))[
      #text(size: 36pt, weight: "black", fill: palette.ink, font: ("Arial", "Arial Unicode MS"))[#sym.yen#price]
      #v(2pt)
      #line(length: 60%, stroke: 1pt + palette.ink)
      #v(2pt)
      #features
    ]
  ]
}

/// Sponsor strip item
#let sponsor-item(icon-text, name) = {
  grid(columns: (auto, auto), column-gutter: 4pt, align: horizon,
    text(size: 9pt, fill: palette.yellow)[#icon-text],
    text(size: 9pt, fill: palette.bg, tracking: 1.5pt, weight: "bold")[#name],
  )
}

/// Comparison column — image + stat + bullet list
#let compare-column(color, header-label, header-title, img-path, stat-num, stat-desc, stat-sub, body, icon: none, badge: none) = {
  block(width: 100%, stroke: 3pt + palette.ink, radius: 8pt)[
    // Header bar
    #block(width: 100%, fill: color, inset: (x: 14pt, y: 8pt))[
      #set text(fill: if color == palette.yellow { palette.ink } else { palette.white })
      #grid(columns: (auto, auto, 1fr, auto), column-gutter: 8pt, align: (left + horizon, left + horizon, left + horizon, right + horizon),
        if icon != none { text(size: 16pt, weight: "bold")[#icon] } else { [] },
        text(size: 14pt, weight: "bold", tracking: 1pt)[#header-label],
        text(size: 14pt, weight: "bold", tracking: 1pt)[#header-title],
        if badge != none {
          block(fill: palette.ink, inset: (x: 8pt, y: 3pt), radius: 2pt)[
            #text(size: 7pt, fill: palette.bg, tracking: 1.5pt, weight: "bold")[#badge]
          ]
        } else { [] },
      )
    ]
    // Image
    #block(width: 100%, height: 130pt, clip: true, fill: palette.bg)[
      #image(img-path, width: 100%, height: 100%, fit: "cover")
    ]
    // Stat line
    #block(width: 100%, fill: palette.bg, inset: (x: 14pt, y: 5pt))[
      #stack(spacing: .8em,
        grid(columns: (auto, 1fr), column-gutter: 8pt, align: (left + bottom, left + bottom),
          text(size: 28pt, weight: "black", fill: color, font: ("Arial", "Arial Unicode MS"))[#stat-num],
          stack(spacing: .8em,
            text(size: 10pt, weight: "bold", fill: palette.ink)[#stat-desc],
            text(size: 8pt, fill: palette.gray)[#stat-sub],
          ),
        ),
        line(length: 100%, stroke: 1pt + palette.ink),
      )
    ]
    // Bullets
    #block(width: 100%, fill: palette.bg, inset: (x: 14pt, y: 5pt))[
      #body
    ]
  ]
}

/// Headliner info card — icon + number + name + genre + details
#let headliner-card(color, num, name, genre, detail1, detail2, icon: none) = {
  block(width: 100%, stroke: 3pt + palette.ink, radius: 8pt)[
    #block(width: 100%, fill: palette.bg, inset: (x: 10pt, y: 6pt))[
      #grid(columns: (auto, 1fr, auto), column-gutter: 8pt, align: (left + top, left + top, right + top),
        if icon != none { text(size: 18pt, fill: color)[#icon] } else { [] },
        stack(spacing: .8em,
          text(size: 14pt, weight: "black", fill: palette.ink, tracking: 1pt, font: ("Arial", "Arial Unicode MS"))[#name],
          text(size: 7pt, fill: color, tracking: 1.5pt, weight: "bold")[#genre],
          text(size: 7pt, fill: palette.ink)[#detail1],
          text(size: 7pt, fill: palette.gray)[#detail2],
        ),
        text(size: 24pt, weight: "black", fill: color.lighten(30%), font: ("Arial", "Arial Unicode MS"))[#num],
      )
    ]
  ]
}

/// CTA button — Memphis-style rounded pill
#let cta-button(color, body) = {
  block(fill: color, inset: (x: 24pt, y: 10pt), radius: 20pt)[
    #text(size: 11pt, fill: palette.white, weight: "bold", tracking: 2pt)[#body]
  ]
}

/// CTA button dark variant
#let cta-button-dark(body) = {
  block(fill: palette.ink, inset: (x: 20pt, y: 8pt), radius: 16pt)[
    #text(size: 9pt, fill: palette.white, weight: "bold", tracking: 2pt)[#body]
  ]
}

/// Memphis decorative dots (a few colored circles)
#let memphis-dots(..colors) = {
  let cs = colors.pos()
  grid(columns: cs.map(_ => auto), column-gutter: 4pt, align: horizon,
    ..cs.map(c => circle(radius: 5pt, fill: c, stroke: none))
  )
}

/// Memphis decorative triangle
#let memphis-triangle(color, size: 24pt) = {
  // Simple rotated square to approximate a triangle visually
  block(width: size, height: size)[
    #polygon(fill: color, stroke: 2pt + palette.ink,
      (0pt, size),
      (size / 2, 0pt),
      (size, size),
    )
  ]
}

/// Memphis zigzag line (approximated with text)
#let memphis-zigzag(color) = {
  text(size: 18pt, fill: color, weight: "bold", font: ("Arial", "Arial Unicode MS"))[#sym.zws]
  // Simplified zigzag using path
  box(width: 40pt, height: 16pt)[
    #place(bottom + left)[
      #line(start: (0pt, 10pt), end: (10pt, 0pt), stroke: 2.5pt + color)
    ]
    #place(bottom + left)[
      #line(start: (10pt, 0pt), end: (20pt, 10pt), stroke: 2.5pt + color)
    ]
    #place(bottom + left)[
      #line(start: (20pt, 10pt), end: (30pt, 0pt), stroke: 2.5pt + color)
    ]
    #place(bottom + left)[
      #line(start: (30pt, 0pt), end: (40pt, 10pt), stroke: 2.5pt + color)
    ]
  ]
}

/// Memphis wavy line (using curves approximation)
#let memphis-wave(color) = {
  box(width: 50pt, height: 12pt)[
    #place(bottom + left)[
      #curve(stroke: 2.5pt + color,
        curve.move((0pt, 6pt)),
        curve.cubic(none, (8pt, -8pt), (12pt, 0pt)),
        curve.cubic((16pt, -8pt), (21pt, 14pt), (25pt, 6pt)),
        curve.cubic((29pt, 14pt), (33pt, -8pt), (37pt, 0pt)),
        curve.cubic((41pt, -8pt), (46pt, 14pt), (50pt, 6pt)),
      )
    ]
  ]
}

/// Checkerboard pattern block
#let memphis-checkerboard(size: 40pt, cell: 8pt) = {
  let cols = int(size / cell)
  block(width: size, height: size, clip: true)[
    #for row in range(cols) {
      for col in range(cols) {
        place(top + left, dx: col * cell, dy: row * cell,
          block(width: cell, height: cell, fill: if calc.rem(row + col, 2) == 0 { palette.ink } else { palette.white })
        )
      }
    }
  ]
}

/// Page footer with source text + page number
#let page-footer(source-text) = {
  block(width: 100%, inset: (x: 0pt))[
    #grid(columns: (1fr, auto),
      text(size: 7pt, fill: palette.gray)[#source-text],
      context { text(size: 7pt, fill: palette.gray, weight: "bold")[#utils.slide-counter.display("1") #h(4pt) / #h(4pt) #utils.last-slide-number] },
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
    show: components.cell.with(inset: (x: 2em, top: 1.2em))
    set align(horizon + left)
    grid(columns: (6pt, auto), column-gutter: 12pt, align: horizon,
      block(width: 6pt, height: 30pt, fill: palette.pink),
      {
        set text(fill: palette.ink, size: 1.4em, weight: "black", tracking: 1.5pt, font: ("Arial", "Arial Unicode MS"))
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
    show: components.cell.with(inset: (x: 2em, y: 0.5em))
    set text(fill: palette.gray, size: 0.6em)
    grid(columns: (1fr, auto), [],
      context { text(weight: "bold")[#utils.slide-counter.display("1") #h(4pt) / #h(4pt) #utils.last-slide-number] })
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

/// Title/Cover slide — full-bleed Memphis cover
#let title-slide(
  bg-image: none,
) = touying-slide-wrapper(self => {
  let body = {
    if bg-image != none {
      place(top + left, block(width: 100%, height: 100%, clip: true)[
        #image(bg-image, width: 100%, height: 100%, fit: "cover")
      ])
    } else {
      place(top + left, block(width: 100%, height: 100%, fill: palette.bg))
    }
  }
  self = utils.merge-dicts(self, config-page(header: none, footer: none, margin: 0pt))
  touying-slide(self: self, body)
})

/// Chapter divider — full-bleed image with giant word overlay
#let chapter-slide(
  bg-image: none,
) = touying-slide-wrapper(self => {
  let body = {
    if bg-image != none {
      place(top + left, block(width: 100%, height: 100%, clip: true)[
        #image(bg-image, width: 100%, height: 100%, fit: "cover")
      ])
    } else {
      place(top + left, block(width: 100%, height: 100%, fill: palette.bg))
    }
  }
  self = utils.merge-dicts(self, config-page(header: none, footer: none, margin: 0pt))
  touying-slide(self: self, body)
})

/// Focus/ending slide
#let ending-slide(body) = touying-slide-wrapper(self => {
  let content = {
    set align(center + horizon)
    set text(fill: palette.ink, size: 14pt)
    pad(x: 10%, body)
  }
  self = utils.merge-dicts(self, config-page(header: none, footer: none, margin: 2em))
  touying-slide(self: self, content)
})

// ===================================================
// Theme Entry Point
// ===================================================

#let sugar-rush-theme(
  aspect-ratio: "16-9",
  align: horizon,
  ..args,
  body,
) = {
  set text(size: 12pt, fill: palette.ink)

  show: touying-slides.with(
    config-page(
      paper: "presentation-16-9",
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
    ..args,
  )

  body
}

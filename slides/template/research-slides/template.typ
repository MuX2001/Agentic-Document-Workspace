// Shared research content helpers; the selected original theme renders pages.
#import "preset.typ": native-theme, native-slide, native, accent
#let research-theme = native-theme
#let _page = native-slide
#let ink = rgb("242424")
#let muted = rgb("5e5e5e")
#let _style = (
  table-row-rule: 0.5pt + rgb("dce2e4"),
  table-header-fill: none,
  experiment-columns: (3fr, 2fr),
  theory-columns: none,
  discussion-width: 100%,
  discussion-size: 20pt,
)

#let theory-slide(formula, title: none, explanation: none, columns: auto) = _page(title: title)[
  #let widths = if columns == auto { _style.theory-columns } else { columns }
  #let equation = align(center, text(size: 30pt, formula))
  #v(1fr)
  #if explanation != none and widths != none {
    grid(columns: widths, gutter: 32pt, align: left + horizon, explanation, equation)
  } else {
    equation
    if explanation != none {
      block(above: 28pt, width: 100%, explanation)
    }
  }
  #v(1fr)
]

// Height is part of the verified 16:9 canvas. `contain` retains every edge.
#let diagram-slide(figure, title: none) = _page(title: title)[
  #align(center + horizon, figure)
]
#let diagram(path, height: 403pt) = image(path, width: 100%, height: height, fit: "contain")

#let experiment-slide(visual, results, title: none) = _page(title: title)[
  #grid(columns: _style.experiment-columns, gutter: 28pt, visual, results)
]
#let frame-strip(..frames) = grid(columns: (1fr,) * frames.pos().len(), gutter: 10pt, ..frames.pos())
#let caption(body) = block(above: 8pt, text(size: 18pt, fill: muted, body))
#let experiment-frame(path, label: none, height: 180pt) = [
  #image(path, width: 100%, height: height, fit: "contain")
  #if label != none { caption(label) }
]

#let comparison-slide(headers, rows, title: none, widths: (1.4fr, 2fr, 2fr, 2fr)) = _page(title: title)[
  #set text(size: 18pt)
  #table(
    columns: widths,
    inset: (x: 10pt, y: 15pt),
    fill: (_, y) => if y == 0 { _style.table-header-fill },
    stroke: (_, y) => (
      bottom: if y > 0 and y < rows.len() { _style.table-row-rule },
    ),
    align: left + top,
    table.header(..headers.map(h => text(weight: "semibold", h))),
    table.hline(stroke: 0.7pt + ink),
    ..rows.flatten(),
  )
]

#let discussion-slide(body, title: none) = _page(title: title)[
  #v(1fr)
  #block(width: _style.discussion-width, text(size: _style.discussion-size, body))
  #v(1fr)
]

#let markdown-slide(body, title: none, compact: false) = _page(title: title)[
  #if compact { text(size: 18pt, body) } else { body }
]

#let markdown-table(headers, cells) = block(width: 100%)[
  #set text(size: 18pt)
  #table(
    columns: (1fr,) * headers.len(),
    inset: (x: 9pt, y: 9pt),
    fill: (_, y) => if y == 0 { _style.table-header-fill },
    stroke: (_, y) => (bottom: if y > 0 { _style.table-row-rule }),
    align: left + top,
    table.header(..headers.map(h => text(weight: "semibold", h))),
    table.hline(stroke: 0.7pt + ink),
    ..cells,
  )
]

#let markdown-figure(path, label, height: 308pt) = block(width: 100%)[
  #align(center)[
    #image(path, width: 100%, height: height, fit: "contain", alt: label)
    #if label != "" { caption(label) }
  ]
]

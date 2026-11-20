// Workspace research layouts composed inside the official Quarto Clean theme.
#import "preset.typ": native as clean, native-theme
#import "@preview/touying:0.7.4": alert

#let research-theme = native-theme
#let title-page = clean.title-slide
#let jump(target, body) = link(label(target), clean.button(body))
#let caption(body) = clean.small-cite(body)
#let subtitle(body) = heading(depth: 3, outlined: false, body)
#let slide-heading(title) = if title != none { heading(depth: 2, title) }
#let section-page(title) = heading(depth: 1, title)

#let diagram(path, height: 315pt) = image(path, width: 100%, height: height, fit: "contain")
#let diagram-slide(visual, title: none) = [#slide-heading(title) #align(center, visual)]
#let experiment-slide(visual, results, title: none) = [
  #slide-heading(title)
  #grid(columns: (3fr, 2fr), gutter: 1.2em, align: left + horizon, visual, results)
]
#let theory-slide(formula, title: none, explanation: none, columns: auto) = [
  #slide-heading(title)
  #align(center, formula)
  #if explanation != none { explanation }
]
#let discussion-slide(body, title: none) = [#slide-heading(title) #body]
#let markdown-slide(body, title: none, compact: false) = [#slide-heading(title) #body]
#let frame-strip(..frames) = grid(columns: (1fr,) * frames.pos().len(), gutter: 1em, ..frames.pos())
#let experiment-frame(path, label: none, height: 180pt) = [
  #diagram(path, height: height)
  #if label != none { caption(label) }
]
#let markdown-figure(path, label, height: 240pt) = [
  #align(center, diagram(path, height: height))
  #if label != "" { caption(label) }
]

#let evidence-table(headers, rows, widths: auto) = {
  set text(size: 0.9em)
  table(
    columns: if widths == auto { (1fr,) * headers.len() } else { widths },
    align: left + horizon,
    inset: (x: 0.45em, y: 0.35em),
    stroke: none,
    fill: (_, y) => if y == 0 { rgb("e8f1f3") },
    table.header(..headers.map(h => strong(h))),
    table.hline(stroke: 0.7pt + rgb("107895")),
    ..rows.flatten(),
    table.hline(stroke: 0.45pt + luma(180)),
  )
}
#let score-cell(value, body) = table.cell(
  fill: rgb("107895").lighten((100 - 0.50 * calc.clamp(value, 0, 100)) * 1%), body)
#let comparison-slide(headers, rows, title: none, widths: auto, notes: none) = [
  #slide-heading(title)
  #evidence-table(headers, rows, widths: widths)
  #if notes != none { block(above: 0.55em, notes) }
]
#let markdown-table(headers, cells) = evidence-table(headers, cells.chunks(headers.len()))

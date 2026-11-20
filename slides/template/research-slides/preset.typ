// A: complete upstream Quarto Clean 0.2.1, without source modifications.
#import "@preview/touying:0.7.4": config-store
#import "@preview/touying-quarto-clean:0.2.1" as upstream
#let native = upstream
#let accent = rgb("107895")
#let native-theme(lang: "zh", body) = {
  set text(lang: lang)
  show: upstream.clean-theme.with(
    font-family-heading: ("Roboto", "Microsoft YaHei"),
    font-family-body: ("Roboto", "Microsoft YaHei"),
    font-family-mono: ("Fira Code", "Microsoft YaHei"),
  )
  body
}
#let native-slide(body, title: none) = upstream.slide(
  config: config-store(header: if title == none { [] } else { title }), body,
)

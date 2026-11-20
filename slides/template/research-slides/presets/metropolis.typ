// B: complete upstream Metropolis from Touying 0.7.4.
#import "@preview/touying:0.7.4": themes
#let native = themes.metropolis
#let accent = rgb("eb811b")
#let native-theme(lang: "zh", body) = {
  set text(font: ("Fira Sans", "Source Han Sans"), weight: "light", lang: lang)
  set strong(delta: 100)
  show: native.metropolis-theme.with(aspect-ratio: "16-9")
  body
}
#let native-slide(body, title: none) = native.slide(
  title: if title == none { [] } else { title }, body,
)

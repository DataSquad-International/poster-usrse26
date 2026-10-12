// DataSquad International poster layout (Quarto + Typst).
// Words live in poster.qmd, numbers in data/outcomes.csv. Edit this file only for layout.

#let navy = rgb("#1D3557")
#let steel = rgb("#457B9D")
#let orange = rgb("#F9AE1A")
#let canvas = rgb("#F8F9FA")
#let slate = rgb("#2D2D2D")

// Horizontal stacked bar of counts from a two-column CSV (category,count) plus a legend.
#let outcomes-bar(path) = {
  let rows = csv(path).slice(1)
  let counts = rows.map(r => int(r.at(1)))
  let total = counts.sum()
  let fills = (navy, steel, orange, rgb("#8FB8D0"), rgb("#E07A5F"), rgb("#6B6B6B"))
  let ink = (white, white, navy, navy, navy, white)
  block(width: 100%, breakable: false)[
    #grid(
      columns: counts.map(c => c * 1fr),
      gutter: 4pt,
      ..counts.enumerate().map(((i, c)) => rect(
        width: 100%,
        height: 2.4in,
        fill: fills.at(calc.rem(i, fills.len())),
        radius: 6pt,
        align(center + horizon, text(fill: ink.at(calc.rem(i, ink.len())), size: 72pt, weight: "bold", str(c))),
      )),
    )
    #v(18pt)
    #for (i, r) in rows.enumerate() [
      #box(width: 30pt, height: 30pt, baseline: 4pt, fill: fills.at(calc.rem(i, fills.len())), radius: 4pt)
      #h(10pt) #r.at(0) (#r.at(1) of #total) #linebreak()
    ]
  ]
}

#let poster(
  title: "Poster title",
  eyebrow: none,
  subtitle: none,
  authors: none,
  affiliations: none,
  logo: none,
  qr: none,
  qr-caption: none,
  footer-text: none,
  footer-url: none,
  size: "44x44",
  num-columns: 3,
  body,
) = {
  let dims = size.split("x")
  let columns-n = int(str(num-columns))

  set text(font: ("Atkinson Hyperlegible", "Helvetica Neue", "Arial"), size: 44pt, fill: slate)
  set page(
    width: int(dims.at(0)) * 1in,
    height: int(dims.at(1)) * 1in,
    margin: (top: 1in, bottom: 1.7in, left: 1.25in, right: 1.25in),
    fill: canvas,
    footer: block(
      width: 100%,
      fill: navy,
      inset: (x: 40pt, y: 22pt),
      radius: 10pt,
      text(fill: white, size: 34pt)[
        #footer-text #h(1fr) #text(fill: orange, weight: "bold", footer-url)
      ],
    ),
  )
  set par(justify: false, leading: 0.8em, spacing: 1.1em)
  set list(indent: 8pt, body-indent: 16pt, spacing: 0.9em, marker: text(fill: orange)[■])
  set enum(indent: 8pt, body-indent: 16pt, spacing: 0.9em)
  show link: set text(fill: steel, weight: "bold")
  show strong: set text(fill: navy)

  show heading.where(level: 1): it => {
    v(40pt, weak: true)
    block(
      width: 100%,
      fill: white,
      stroke: (top: 10pt + steel, rest: 1.5pt + rgb("#E3E6EA")),
      inset: (x: 28pt, y: 22pt),
      radius: (top: 0pt, bottom: 12pt),
      below: 22pt,
      text(fill: navy, size: 60pt, weight: "bold", it.body),
    )
  }
  show heading.where(level: 2): it => {
    v(50pt)
    block(below: 16pt, text(fill: navy, size: 50pt, weight: "bold", it.body))
  }

  // Header band, styled like the site hero
  block(width: 100%, fill: navy, inset: 56pt, radius: 14pt, below: 0pt)[
    #grid(
      columns: (1fr, auto),
      column-gutter: 60pt,
      align: horizon,
      [
        #if eyebrow != none [
          #text(fill: orange, size: 38pt, weight: "bold", tracking: 5pt, upper(eyebrow))
          #v(4pt)
        ]
        #text(fill: white, size: 140pt, weight: "bold", title)
        #if subtitle != none [
          #v(10pt)
          #text(fill: rgb("#CDD6E3"), size: 52pt, subtitle)
        ]
        #v(34pt)
        #text(fill: white, size: 46pt, weight: "bold", authors)
        #if affiliations != none [
          #linebreak()
          #text(fill: orange, size: 38pt, affiliations)
        ]
      ],
      if logo != none {
        block(fill: white, inset: 36pt, radius: 24pt, image(logo, height: 3.6in))
      },
    )
  ]
  block(width: 100%, height: 14pt, fill: orange, radius: 4pt, above: 0pt, below: 10pt)

  columns(columns-n, gutter: 60pt, body)
}

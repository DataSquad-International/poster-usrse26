// DataSquad International poster layout (Quarto + Typst).
// Words live in poster.qmd, numbers in data/outcomes.csv. Edit this file only for layout.

#let navy = rgb("#1D3557")
#let steel = rgb("#457B9D")
#let orange = rgb("#F9AE1A")
#let canvas = rgb("#F8F9FA")
#let slate = rgb("#2D2D2D")
#let muted = rgb("#CDD6E3")

// Example tagged with its school: thin local accent only (UCLA and Carleton official blues).
#let school(name, accent, body) = block(
  width: 100%,
  breakable: false,
  above: 30pt,
  below: 14pt,
  inset: (left: 28pt),
  stroke: (left: 10pt + accent),
)[
  #text(size: 34pt, weight: "bold", fill: accent, tracking: 3pt, upper(name))
  #v(2pt)
  #body
]
#let carleton(body) = school("Carleton", rgb("#003069"), body)
#let ucla(body) = school("UCLA", rgb("#2774AE"), body)

#let lede(body) = text(size: 78pt, weight: "bold", fill: navy, body)

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
        height: 1.7in,
        fill: fills.at(calc.rem(i, fills.len())),
        radius: 4pt,
        align(center + horizon, text(fill: ink.at(calc.rem(i, ink.len())), size: 72pt, weight: "bold", str(c))),
      )),
    )
    #v(18pt)
    #for (i, r) in rows.enumerate() [
      #box(width: 30pt, height: 30pt, baseline: 4pt, fill: fills.at(calc.rem(i, fills.len())), radius: 3pt)
      #h(10pt) #r.at(0) (#r.at(1) of #total) #linebreak()
    ]
  ]
}

// Arrows drawn as shapes so they do not depend on font glyphs.
#let arrow-right(len: 1.3in, col: navy) = box(width: len, height: 48pt, {
  place(left + horizon, line(length: len - 26pt, stroke: 7pt + col))
  place(right + horizon, polygon(fill: col, (0pt, 0pt), (28pt, 24pt), (0pt, 48pt)))
})
#let arrow-down(len: 0.9in, col: navy) = box(width: 48pt, height: len, {
  place(top + center, line(angle: 90deg, length: len - 26pt, stroke: 7pt + col))
  place(bottom + center, polygon(fill: col, (0pt, 0pt), (48pt, 0pt), (24pt, 28pt)))
})
#let node(body, fill: white, ink: navy, stroke: 5pt + navy, size: 48pt) = block(
  width: 100%,
  fill: fill,
  stroke: stroke,
  radius: 6pt,
  inset: 22pt,
  align(center + horizon, text(size: size, weight: "bold", fill: ink, body)),
)

// The central idea: requests and supervision go into paid student work; two things come out.
#let model-diagram(
  requests: "Research requests",
  supervision: "Staff supervision",
  work: "Paid student project work",
  service: "Useful research support",
  students: "Skilled students",
  spread: "Good practice travels to labs and offices across campus",
) = grid(
  columns: (1fr, auto, 1.25fr, auto, 1.15fr),
  align: center + horizon,
  column-gutter: 18pt,
  row-gutter: 24pt,
  [], [], node(supervision, size: 46pt, stroke: 4pt + steel), [], [],
  [], [], arrow-down(len: 0.7in), [], [],
  node(requests, size: 50pt, stroke: 5pt + steel),
  arrow-right(),
  grid.cell(rowspan: 2, node(work, fill: navy, ink: white, size: 60pt)),
  arrow-right(),
  node(service, size: 50pt, stroke: 5pt + steel),
  [], [], arrow-right(), node(students, fill: orange, ink: navy, size: 58pt, stroke: 5pt + orange),
  [], [], [], [], arrow-down(len: 0.7in),
  [], [], [], [], text(size: 42pt, fill: navy, weight: "bold", spread),
)

#let poster(
  title: "Poster title",
  authors: none,
  affiliations: none,
  logo: none,
  footer-text: none,
  footer-url: none,
  size: "44x44",
  num-columns: 1,
  body,
) = {
  let dims = size.split("x")
  let columns-n = int(str(num-columns))

  set text(font: ("Atkinson Hyperlegible", "Helvetica Neue", "Arial"), size: 42pt, fill: slate)
  set page(
    width: int(dims.at(0)) * 1in,
    height: int(dims.at(1)) * 1in,
    margin: (top: 1in, bottom: 1.7in, left: 1.25in, right: 1.25in),
    fill: canvas,
    footer: block(
      width: 100%,
      fill: navy,
      inset: (x: 40pt, y: 22pt),
      radius: 6pt,
      text(fill: white, size: 34pt)[
        #footer-text #h(1fr) #text(fill: orange, weight: "bold", footer-url)
      ],
    ),
  )
  set par(justify: false, leading: 0.8em, spacing: 1.05em)
  set list(indent: 6pt, body-indent: 18pt, spacing: 0.85em, marker: box(width: 15pt, height: 15pt, fill: navy, baseline: 1pt))
  set enum(indent: 6pt, body-indent: 16pt, spacing: 0.85em)
  show link: set text(fill: steel, weight: "bold")
  show strong: set text(fill: navy)

  // Panel titles: plain navy type over a single steel rule. No boxes.
  show heading.where(level: 1): it => block(
    width: 100%,
    above: 48pt,
    below: 22pt,
    stroke: (bottom: 6pt + steel),
    inset: (bottom: 14pt),
    text(fill: navy, size: 58pt, weight: "bold", it.body),
  )
  show heading.where(level: 2): it => {
    v(44pt, weak: false)
    block(below: 16pt, text(fill: navy, size: 46pt, weight: "bold", it.body))
  }

  // Header: title and people only. Mark in white on navy.
  block(width: 100%, fill: navy, inset: (x: 56pt, y: 40pt), radius: 6pt, below: 36pt)[
    #grid(
      columns: (1fr, auto),
      column-gutter: 50pt,
      align: horizon,
      [
        #text(fill: white, size: 150pt, weight: "bold", title)
        #v(18pt)
        #text(fill: white, size: 46pt, weight: "bold", authors)
        #if affiliations != none [
          #linebreak()
          #text(fill: muted, size: 38pt, affiliations)
        ]
      ],
      if logo != none { image(logo, height: 3.8in) },
    )
  ]

  columns(columns-n, gutter: 60pt, body)
}

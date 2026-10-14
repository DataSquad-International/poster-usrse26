#import "@preview/fletcher:0.5.8": diagram as fletcher-diagram, node as fnode, edge
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
  #text(size: 34pt, weight: "bold", fill: accent, tracking: 3pt, upper(name)) #h(14pt) #body
]
#let carleton(body) = school("Carleton", rgb("#003069"), body)
#let ucla(body) = school("UCLA", rgb("#2774AE"), body)

// Call-to-action panel: navy border, orange heading strip. Border keeps it prominent in grayscale.
#let startbox(body) = block(width: 100%, stroke: 6pt + navy, radius: 8pt, inset: 28pt, breakable: false)[
  #show heading.where(level: 1): it => pad(x: -28pt, top: -28pt, bottom: 10pt, block(
    width: 100%, fill: orange, inset: (x: 28pt, y: 18pt), above: 0pt, below: 0pt,
    text(fill: navy, size: 58pt, weight: "bold", it.body),
  ))
  #body
]

#let urltext(body) = text(size: 50pt, weight: "bold", body)
#let lede(body) = text(size: 78pt, weight: "bold", fill: navy, body)

// Directly labelled counts from a two-column CSV (category,count). Works in grayscale.
#let outcomes-list(path) = {
  let rows = csv(path).slice(1)
  block(width: 100%, breakable: false)[
    #for (i, r) in rows.enumerate() [
      #block(
        width: 100%,
        above: 0pt,
        below: 0pt,
        inset: (y: 14pt),
        stroke: (bottom: 1.5pt + rgb("#C9D3DC")),
        grid(
          columns: (1fr, auto),
          align: horizon,
          text(size: 42pt, r.at(0)),
          text(size: 68pt, weight: "bold", fill: navy, r.at(1)),
        ),
      )
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
#let node(body, fill: white, ink: navy, stroke: 5pt + navy, size: 48pt, height: auto) = block(
  width: 100%,
  height: height,
  fill: fill,
  stroke: stroke,
  radius: 6pt,
  inset: 22pt,
  align(center + horizon, text(size: size, weight: "bold", fill: ink, body)),
)

// Nine student developers across two cohorts: seven built it, two extended it.
#let relay() = {
  let dots(n, fill) = for _ in range(n) { box(width: 52pt, height: 52pt, radius: 26pt, fill: fill, baseline: 10pt); h(14pt) }
  block(width: 100%, breakable: false, above: 14pt, below: 6pt, {
    grid(
      columns: (auto, 1fr),
      column-gutter: 18pt,
      row-gutter: 12pt,
      align: horizon,
      text(size: 40pt, weight: "bold", fill: navy, [2022]), dots(7, steel),
      text(size: 40pt, weight: "bold", fill: navy, [2023-24]), dots(2, orange),
    )
  })
}

// Illustrative photo of an LAPD helicopter, cropped to a banner. CC BY 2.0, so the credit line is required.
#let heli-photo() = block(width: 100%, breakable: false, above: 10pt, below: 8pt, {
  image("assets/lapd-as350b2-chris-yarzab.jpg", width: 100%, height: 230pt, fit: "cover", alt: "An LAPD Eurocopter AS350B2 helicopter in flight")
  v(4pt)
  text(size: 28pt, fill: rgb("#4A5560"))[LAPD helicopter, for illustration. Photo: Chris Yarzab, CC BY 2.0, via Wikimedia Commons. Cropped and resized.]
})

// Before and after loading time, drawn to scale (318 minutes against 2).
#let speedup(before: 318, after: 2, unit: "min") = {
  let bar(label, value, fill) = grid(
    columns: (auto, 1fr),
    column-gutter: 18pt,
    align: horizon,
    text(size: 40pt, weight: "bold", fill: navy, label),
    stack(dir: ltr, spacing: 12pt,
      rect(width: value / before * 72%, height: 58pt, fill: fill, stroke: none, radius: 3pt),
      text(size: 44pt, weight: "bold", fill: navy, [~#value #unit]),
    ),
  )
  block(width: 100%, breakable: false, above: 14pt, below: 6pt, {
    bar("Before", before, steel)
    v(10pt)
    bar("After", after, orange)
  })
}

// Who is on a DataSquad: students in a short flow (request, work, documentation), staff supervising all of it.
#let roles() = {
  let pill(role, desc, fill: white, stroke-col: steel) = grid(
    columns: (0.44fr, 0.56fr),
    column-gutter: 22pt,
    align: horizon,
    block(
      width: 100%, fill: fill, stroke: 4pt + stroke-col, radius: 6pt, inset: 16pt, breakable: false,
      align(center, text(size: 40pt, weight: "bold", fill: navy, role)),
    ),
    text(size: 38pt, desc),
  )
  block(width: 100%, breakable: false, {
    pill("Project manager", "triages requests")
    v(10pt)
    pill("Data analysts and developers", "do the hands-on work with data and code")
    v(10pt)
    pill("Technical writers", "document projects")
    v(22pt)
    pill("Staff", "supervise, mentor, fund, and sustain the DataSquad", fill: muted, stroke-col: navy)
  })
}

// The central idea: requests and supervision go into paid student work; two things come out.
// Drawn with fletcher so boxes size to their text and arrows route themselves.
#let model-diagram(
  requests: "Research requests",
  supervision: [Staff supervision #linebreak() and mentoring],
  work: [Paid student #linebreak() project work],
  service: "Useful research support",
  students: "Skilled students",
  spread: "Goal: wider use of good practice",
) = layout(size => {
  let w = size.width
  let box(body, fill: white, ink: navy, stroke: 5pt + steel, size: 54pt) = (
    fill: fill, stroke: stroke, corner-radius: 6pt, inset: 22pt,
    label: align(center + horizon, text(size: size, weight: "bold", fill: ink, body)),
  )
  let n(pos, name, spec, width, height) = fnode((pos.at(0), -pos.at(1)), spec.label, name: name, fill: spec.fill, stroke: spec.stroke, corner-radius: spec.corner-radius, inset: spec.inset, width: width, height: height)
  let x0 = 0.11 * w
  let x1 = 0.46 * w
  let x2 = 0.83 * w
  let ym = 195pt
  fletcher-diagram(
    edge-stroke: 7pt + navy,
    mark-scale: 120%,
    spacing: 0pt,
    n((x0, ym), <req>, box(requests, size: 50pt), 0.2 * w, 150pt),
    n((x1, ym), <work>, box(work, fill: navy, ink: white, size: 60pt, stroke: 5pt + navy), 0.24 * w, 180pt),
    n((x1, 0pt), <sup>, box(supervision, size: 44pt, stroke: 4pt + steel), 0.24 * w, 120pt),
    n((x2, ym - 72pt), <svc>, box(service, size: 48pt), 0.30 * w, 120pt),
    n((x2, ym + 72pt), <stu>, box(students, fill: orange, stroke: 5pt + orange, size: 48pt), 0.30 * w, 120pt),
    n((x2, ym + 270pt), <spr>, box(spread, size: 44pt, stroke: 4pt + steel), 0.30 * w, 150pt),
    edge(<req>, <work>, "-|>"),
    edge(<sup>, <work>, "-|>"),
    edge(<work>, <svc>, "-|>"),
    edge(<work>, <stu>, "-|>"),
    edge(<stu>, <spr>, "-|>"),
  )
})

#let poster(
  title: "Poster title",
  subtitle: none,
  authors: none,
  affiliations: none,
  logo: none,
  watermark: none,
  footer-text: none,
  footer-url: none,
  size: "44x44",
  num-columns: 1,
  draft: false,
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
    background: {
      if watermark != none {
        place(center + horizon, image(watermark, width: 34in))
      }
    },
    footer: block(
      width: 100%,
      fill: navy,
      inset: (x: 40pt, y: 22pt),
      radius: 6pt,
      text(fill: white, size: 34pt)[
        #footer-text #h(1fr)
        #if draft { box(fill: orange, inset: (x: 22pt, y: 8pt), radius: 4pt, text(fill: navy, weight: "bold", tracking: 3pt, "DRAFT")) }
        #h(1fr) #text(fill: orange, weight: "bold", footer-url)
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
    v(34pt, weak: false)
    block(below: 0pt, text(fill: navy, size: 46pt, weight: "bold", it.body))
    v(20pt, weak: false)
  }

  // Header: title and people only. Mark in white on navy.
  block(width: 100%, fill: navy, inset: (x: 56pt, y: 48pt), radius: 6pt, below: 44pt)[
    #grid(
      columns: (1fr, auto),
      column-gutter: 50pt,
      align: horizon,
      [
        #block(below: 0pt, text(fill: white, size: 130pt, weight: "bold", top-edge: "cap-height", bottom-edge: "baseline", title))
        #if subtitle != none [
          #v(44pt)
          #block(below: 0pt, par(leading: 0.55em, text(fill: muted, size: 46pt, subtitle)))
        ]
        #v(60pt)
        #block(below: 14pt, text(fill: white, size: 46pt, weight: "bold", authors))
        #if affiliations != none [
          #block(text(fill: muted, size: 38pt, affiliations))
        ]
      ],
      if logo != none { image(logo, height: 3.2in) },
    )
  ]

  columns(columns-n, gutter: 60pt, body)
}

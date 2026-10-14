#import "@preview/fletcher:0.5.8": diagram as fletcher-diagram, node as fnode, edge
#import "@preview/wrap-it:0.1.1": wrap-content
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

// Ranked frequency bars, both schools combined, from data/outcomes.csv (category,count). Rows starting with "_" hold
// the coverage numbers for the caption. Directly labelled, so it works in grayscale.
#let outcomes-list(path) = {
  let all = csv(path).slice(1)
  let meta = (:)
  for r in all.filter(r => r.at(0).starts-with("_")) { meta.insert(r.at(0), int(r.at(1))) }
  let cats = all.filter(r => not r.at(0).starts-with("_"))
  let top = int(cats.first().at(1))
  let coded = meta.at("_ucla_coded") + meta.at("_carleton_coded")
  let total = meta.at("_ucla_alumni") + meta.at("_carleton_alumni")
  block(width: 100%, breakable: false)[
    #for r in cats [
      #block(width: 100%, above: 0pt, below: 0pt, inset: (y: 5pt), stroke: (bottom: 1.5pt + rgb("#C9D3DC")),
        grid(
          columns: (430pt, 1fr, 60pt),
          column-gutter: 12pt,
          align: horizon,
          text(size: 30pt, fill: slate, r.at(0)),
          rect(width: int(r.at(1)) / top * 100%, height: 30pt, fill: steel, stroke: none, radius: 3pt),
          align(right, text(size: 42pt, weight: "bold", fill: navy, r.at(1))),
        ))
    ]
    #v(8pt)
    #text(size: 28pt, fill: rgb("#4A5560"))[#coded of #total alumni coded so far: UCLA #meta.at("_ucla_coded") of #meta.at("_ucla_alumni"), Carleton #meta.at("_carleton_coded") of #meta.at("_carleton_alumni"), #meta.at("_carleton_from_title") of them coded from the job title alone. Carleton is only partly coded, so this is not a sample. Descriptive, not a placement rate.]
  ]
}

// Word cloud of job-title words (UCLA and Carleton combined) from data/title-words.csv (word,count). The last row
// (_people_with_a_title) is the number of people. Titles only, never employers. Real text, laid out by a spiral
// search that measures each word, so nothing overlaps and the result is the same every build. Horizontal only,
// for legibility. Size shows how many people; color groups the kind of work (navy tech, steel data and research,
// amber everything else) and is redundant with the words themselves, so it works in grayscale.
#let word-cloud(path, height: 600pt, min-count: 2) = layout(size => {
  let w = size.width
  let max-size = 0.115 * w
  let min-size = 0.040 * w
  let all = csv(path).slice(1)
  let people = all.last().at(1)
  let words = all.filter(r => not r.at(0).starts-with("_") and int(r.at(1)) >= min-count)
  let peak = int(words.first().at(1))
  let tech = ("software", "engineer", "developer", "systems", "technical", "it", "development", "specialist")
  let rsch = ("data", "analyst", "science", "scientist", "research", "actuarial", "clinical", "teaching", "graduate", "fellow")
  let shout = ("it", "ceo")
  let label-of(word, n) = {
    let sz = min-size + calc.pow(n / peak, 0.42) * (max-size - min-size)
    let col = if word in tech { navy } else if word in rsch { steel } else { rgb("#A8590A") }
    let shown = if word in shout { upper(word) } else { upper(word.first()) + word.slice(1) }
    text(size: sz, weight: "bold", fill: col, top-edge: "cap-height", bottom-edge: "baseline", shown)
  }
  let placed = ()
  let out = ()
  let pad = 7pt
  for r in words {
    let label = label-of(r.at(0), int(r.at(1)))
    let m = measure(label)
    let bw = m.width + 2 * pad
    let bh = m.height + 2 * pad + 6pt
    let found = false
    let i = 0
    while not found and i < 6000 {
      let a = i * 0.12
      let rad = 0.9pt * i * 0.12 * 3
      let cx = w / 2 + rad * calc.cos(a * 1rad) * 1.9
      let cy = height / 2 + rad * calc.sin(a * 1rad)
      let x0 = cx - bw / 2
      let y0 = cy - bh / 2
      if x0 >= 0pt and y0 >= 0pt and x0 + bw <= w and y0 + bh <= height {
        let ok = true
        for p in placed {
          if x0 < p.x + p.w and x0 + bw > p.x and y0 < p.y + p.h and y0 + bh > p.y { ok = false; break }
        }
        if ok {
          placed.push((x: x0, y: y0, w: bw, h: bh))
          out.push((x: x0 + pad, y: y0 + pad + 3pt, label: label))
          found = true
        }
      }
      i += 1
    }
  }
  block(width: w, breakable: false)[
    #block(width: w, height: height, for o in out { place(top + left, dx: o.x, dy: o.y, o.label) })
    #v(10pt)
    #text(size: 30pt, fill: rgb("#4A5560"))[Words in the current job titles of #people alumni of UCLA and Carleton, from public profiles in 2026. Larger means more people. Words used by fewer than #min-count people are not shown. Descriptive, not a placement rate.]
  ]
})

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
    v(4pt)
    text(size: 32pt, fill: rgb("#4A5560"))[Each dot is one student. Blue built it, orange extended it.]
  })
}

// Helicopter example: text flows around a small photo (CC BY 2.0, so the credit line is required),
// then two big numbers for the load time. Numbers are from the project team and unconfirmed.
#let load-tiles(before: 318, after: 2) = {
  let tile(label, value, fill) = block(width: 100%, fill: fill, radius: 6pt, inset: 20pt, breakable: false,
    align(center)[
      #text(size: 34pt, weight: "bold", fill: navy, label) \
      #text(size: 96pt, weight: "bold", fill: navy, str(value)) #text(size: 40pt, weight: "bold", fill: navy)[ min]
    ])
  block(width: 100%, breakable: false, above: 16pt, below: 6pt, {
    text(size: 32pt, fill: rgb("#4A5560"))[Time to load the data]
    v(8pt)
    grid(columns: (1fr, auto, 1fr), column-gutter: 16pt, align: horizon,
      tile("Before", before, muted), arrow-right(len: 70pt), tile("After", after, orange))
  })
}
#let heli-example(body) = block(
  width: 100%, breakable: false, above: 30pt, below: 14pt, inset: (left: 28pt), stroke: (left: 10pt + rgb("#2774AE")),
)[
  #wrap-content(
    {
      image("assets/lapd-as350b2-chris-yarzab.jpg", width: 300pt, height: 190pt, fit: "cover", alt: "An LAPD Eurocopter AS350B2 helicopter in flight")
      v(2pt)
      block(width: 300pt, text(size: 28pt, fill: rgb("#4A5560"))[LAPD helicopter, for illustration. Photo: Chris Yarzab, CC BY 2.0, via Wikimedia Commons. Cropped and resized.])
    },
    [#text(size: 34pt, weight: "bold", fill: rgb("#2774AE"), tracking: 3pt, upper("UCLA")) #h(14pt) #body],
    align: top + right,
    column-gutter: 24pt,
  )
  #load-tiles()
]

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

// The central idea: requests go into student work, with staff teaching and review built in; two things come out.
// One row, drawn with fletcher so boxes size to their text and arrows route themselves.
#let model-diagram(
  requests: "Research requests",
  work: "Student project work",
  staff: "Staff teach, review, and mentor",
  service: "Useful research support",
  students: "Skilled students",
) = layout(size => {
  let w = size.width
  let cell(body, fill: white, ink: navy, size: 54pt) = block(
    width: 100%, fill: fill, inset: 30pt,
    align(center + horizon, text(size: size, weight: "bold", fill: ink, body)),
  )
  let panel(width, ..parts) = (
    width: width, fill: none, stroke: 5pt + navy, corner-radius: 6pt, inset: 0pt,
    label: block(width: 100%, clip: true, radius: 3pt, stack(dir: ttb, ..parts)),
  )
  let n(pos, name, spec) = fnode(pos, spec.label, name: name, fill: spec.fill, stroke: spec.stroke, corner-radius: spec.corner-radius, inset: spec.inset, width: spec.width)
  let req = panel(0.20 * w, cell(requests, size: 64pt))
  let wrk = panel(0.36 * w, cell(work, fill: navy, ink: white, size: 76pt), cell(staff, fill: muted, size: 52pt))
  let out = panel(0.28 * w, cell(service, size: 64pt), cell(students, fill: orange, size: 64pt))
  fletcher-diagram(
    edge-stroke: 7pt + navy,
    mark-scale: 120%,
    spacing: 0pt,
    n((0.10 * w, 0pt), <req>, req),
    n((0.46 * w, 0pt), <work>, wrk),
    n((0.84 * w, 0pt), <out>, out),
    edge(<req>, <work>, "-|>"),
    edge(<work>, <out>, "-|>"),
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

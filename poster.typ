// Simple numbering for non-book documents
#let equation-numbering = "(1)"
#let callout-numbering = "1"
#let subfloat-numbering(n-super, subfloat-idx) = {
  numbering("1a", n-super, subfloat-idx)
}

// Theorem configuration for theorion
// Simple numbering for non-book documents (no heading inheritance)
#let theorem-inherited-levels = 0

// Theorem numbering format (can be overridden by extensions for appendix support)
// This function returns the numbering pattern to use
#let theorem-numbering(loc) = "1.1"

// Default theorem render function
#let theorem-render(prefix: none, title: "", full-title: auto, body) = {
  if full-title != "" and full-title != auto and full-title != none {
    strong[#full-title.]
    h(0.5em)
  }
  body
}
// Some definitions presupposed by pandoc's typst output.
#let content-to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms.item: it => block(breakable: false)[
  #text(weight: "bold")[#it.term]
  #block(inset: (left: 1.5em, top: -0.4em))[#it.description]
]

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let fields = old_block.fields()
  let _ = fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => {
          let subfloat-idx = quartosubfloatcounter.get().first() + 1
          subfloat-numbering(n-super, subfloat-idx)
        })
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => block({
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          })

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let children = old_title_block.body.body.children
  let old_title = if children.len() == 1 {
    children.at(0)  // no icon: title at index 0
  } else {
    children.at(1)  // with icon: title at index 1
  }

  // TODO use custom separator if available
  // Use the figure's counter display which handles chapter-based numbering
  // (when numbering is a function that includes the heading counter)
  let callout_num = it.counter.display(it.numbering)
  let new_title = if empty(old_title) {
    [#kind #callout_num]
  } else {
    [#kind #callout_num: #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block,
    block_with_new_content(
      old_title_block.body,
      if children.len() == 1 {
        new_title  // no icon: just the title
      } else {
        children.at(0) + new_title  // with icon: preserve icon block + new title
      }))

  align(left, block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1)))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color,
        width: 100%,
        inset: 8pt)[#if icon != none [#text(icon_color, weight: 900)[#icon] ]#title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}



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
#let word-cloud(path, height: 600pt, min-count: 3) = layout(size => {
  let w = size.width
  let max-size = 0.092 * w
  let min-size = 0.036 * w
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
  let pad = 6pt
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
    #text(size: 28pt, fill: rgb("#4A5560"))[Words in the job titles of #people alumni (UCLA and Carleton), from public profiles in 2026. Larger means more people; words used by fewer than #min-count people are not shown. Navy is technology, steel is data and research, amber is other. Descriptive, not a placement rate.]
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

// Four cards: what a student gets from the job. Icons are traced from the source drawing to vector (assets/pathways-*.svg);
// the Venn diagram and every label are live text and shapes, so they stay sharp at print size.
#let venn(size: 290pt) = {
  let r = size * 0.31
  let stroke = 4.5pt + navy
  box(width: size, height: size * 0.93, {
    place(top + center, circle(radius: r, stroke: stroke))
    place(bottom + left, circle(radius: r, stroke: stroke))
    place(bottom + right, circle(radius: r, stroke: stroke))
    place(top + center, dy: size * 0.13, text(size: 30pt, weight: "bold", fill: navy)[Knowledge])
    place(left + bottom, dx: size * 0.05, dy: -size * 0.15, text(size: 28pt, weight: "bold", fill: navy)[Behavior])
    place(right + bottom, dx: -size * 0.075, dy: -size * 0.15, text(size: 28pt, weight: "bold", fill: navy)[Skills])
  })
}
#let pathways() = {
  let card(icon, label) = block(
    width: 100%, height: 455pt, stroke: 5pt + navy, radius: 80pt, inset: 22pt, breakable: false,
    align(center + horizon, stack(dir: ttb, spacing: 18pt, icon, text(size: 44pt, weight: "bold", fill: navy, label))),
  )
  grid(columns: (1fr, 1fr), column-gutter: 24pt, row-gutter: 24pt,
    card(image("assets/pathways-experience.svg", height: 250pt, alt: "A laptop surrounded by gears and sparkles"), [Experience]),
    card(image("assets/pathways-mentorship.svg", height: 250pt, alt: "Three people on rising steps, each helping the next one up"), [Mentorship]),
    card(venn(size: 290pt), [Professional Growth]),
    card(image("assets/pathways-applied.svg", height: 250pt, alt: "A lightbulb over an open book with a hammer and wrench"), [Applied Curricular Skills]),
  )
}

// DataSquad roles: four rows, icon plus role and what it does. Icons are traced to vector (assets/role-*.svg);
// all text is live type.
#let role-cards() = {
  let row(icon, alt, name, desc) = block(
    width: 100%, stroke: 4pt + navy, radius: 46pt, inset: (x: 24pt, y: 16pt), breakable: false,
    grid(columns: (110pt, 1fr), column-gutter: 24pt, align: horizon,
      align(center, image(icon, height: 92pt, alt: alt)),
      [#text(size: 40pt, weight: "bold", fill: navy, name) \
       #text(size: 34pt, fill: slate, desc)]),
  )
  stack(dir: ttb, spacing: 12pt,
    row("assets/role-project-management.svg", "A clipboard with gears and a checklist", [Project Management Intern], [Triages requests, helps manage and mentor their peers, advises the staff]),
    row("assets/role-analyst-developer.svg", "A laptop showing code and a bar chart", [Data Analysts and Developers], [Do the hands-on work with data and code]),
    row("assets/role-technical-writer.svg", "A document with a pen", [Technical Writers], [Document projects and assure clear communications.]),
    row("assets/role-staff.svg", "A columned building beside a person", [Staff], [Supervise, mentor, and situate the DataSquad in their institution]),
  )
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
  doi: none,
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
        #if not draft and doi != none { link("https://doi.org/" + doi, text(fill: white, weight: "bold", "doi:" + doi)) }
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
#let brand-color = (:)
#let brand-color-background = (:)
#let brand-logo = (:)

#set page(
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  numbering: "1",
  columns: 1,
)

#show: doc => poster(
   title: [DataSquad: An entry point for RSE], 
   subtitle: [Student RSE model for research support, experiential learning, and technical workforce development], 
   authors: [Paula Lackie, Oliver Hall, Tim Dennis, Leigh Phan], 
   affiliations: [Carleton College DataSquad | UCLA Library Data Science Center DataSquad], 
   size: "44x44", 
   logo: "assets/datasquad-international-mark-white.svg", 
   watermark: "assets/datasquad-international-watermark.svg", 
   footer-text: [US-RSE '26 · San Jose · Poster reception, Monday Oct 19], 
   footer-url: [datasquad.info], 
  
   doi: "10.5281/zenodo.23381638", 
  
  doc,
)

#grid(columns: (1fr, 2fr,), column-gutter: 70pt, row-gutter: 40pt,
[
#lede[
Paid students contribute to research and build RSE skills while they do it.

]
Campuses need more data and software help than staff can provide. Students want this experience, but their courses can't cover everything. DataSquads fill this gap.

],
[
#model-diagram()
],
)
#grid(columns: (1fr, 1.3fr, 1fr,), column-gutter: 70pt, row-gutter: 40pt,
[
#pathways()
= DataSquad roles
<datasquad-roles>
#role-cards()
],
[
= What the work looks like
<what-the-work-looks-like>
#carleton[
#strong[Election-news scraper.] Seven students built it in 2022. Two more extended it from 2023 to 2024 for a political science project that involved over 500,000 transcripts.

#relay()
]
#heli-example[*Police helicopter flight data.* Two students brought software skills to a research lab's R code. They refactored it with staff, and the code went through code review. Loading the data fell from about 318 minutes to about 2.]
#v(30pt)
#strong[Research software habits, when the project needs them.] Run instructions, a dependency list, one test, and a citation file. We do not treat them as a checklist. We plan to track whether researchers keep them. Two student-built projects have citation files and DOIs that credit their developers: wbcheck (#link("https://doi.org/10.5281/zenodo.23329531")[doi:10.5281/zenodo.23329531]) and the UC OSPO Education site (#link("https://doi.org/10.5281/zenodo.23330022")[doi:10.5281/zenodo.23330022]).

],
[
= Where students go next
<where-students-go-next>
Where former student employees work now, in the words of their job titles.

#word-cloud("data/title-words.csv", height: 380pt)
= What adopting takes
<what-adopting-takes>
- Student positions and a wage budget
- Supervisors with time to review and coach
- Onboarding and a home for documentation
- A plan for turnover

#startbox[
= Start a DataSquad
<start-a-datasquad>
#grid(columns: (1fr, 2.2in,), column-gutter: 30pt, row-gutter: 40pt,
[
Get the starter kit for roles, onboarding, confidentiality, and request tracking. Students learn software sharing from our open lesson, #link("https://ucospo.net/research-software-citable-discoverable/")[Sharing Research Software]. Supervise students? Compare onboarding, review, and graduation handoffs with us.

#urltext[
#link("https://datasquad.info/join")[datasquad.info/join]

]
],
[
#block(
fill:white,
inset:0pt,
radius:4pt,
[
#box(image("assets/qr-datasquad-info.svg", width: 2.2in))

])

],
)
]
],
)




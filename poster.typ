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

// The central idea: requests and supervision go into paid student work; two things come out.
#let model-diagram(
  requests: "Research requests",
  supervision: "Staff supervision",
  work: [Paid student #linebreak() project work],
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
  node(service, size: 56pt, stroke: 5pt + steel, height: 2in),
  [], [], arrow-right(), node(students, fill: orange, ink: navy, size: 56pt, stroke: 5pt + orange, height: 2in),
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
    background: if draft {
      place(center + horizon, rotate(-35deg, text(size: 430pt, weight: "bold", fill: rgb("#1D355724"), tracking: 20pt, "DRAFT")))
    } else { none },
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
    v(34pt, weak: false)
    block(below: 0pt, text(fill: navy, size: 46pt, weight: "bold", it.body))
    v(20pt, weak: false)
  }

  // Header: title and people only. Mark in white on navy.
  block(width: 100%, fill: navy, inset: (x: 56pt, y: 38pt), radius: 6pt, below: 44pt)[
    #grid(
      columns: (1fr, auto),
      column-gutter: 50pt,
      align: horizon,
      [
        #block(below: 0pt, text(fill: white, size: 150pt, weight: "bold", top-edge: "cap-height", bottom-edge: "baseline", title))
        #v(58pt)
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
   title: [Is the DataSquad Model For You?], 
   authors: [Paula Lackie, Oliver Hall, Tim Dennis, Leigh Phan], 
   affiliations: [Carleton College DataSquad | UCLA Library Data Science Center DataSquad], 
   size: "44x44", 
   logo: "assets/datasquad-mark-white.svg", 
   footer-text: [US-RSE '26 · San Jose · Poster reception, Monday Oct 19], 
   footer-url: [datasquad.info], 
   draft: true, 
  
  doc,
)

#grid(columns: (1fr, 2fr,), column-gutter: 70pt, row-gutter: 40pt,
[
#lede[
Students are not just the tool. They are a beneficial product of the service.

]
Campuses need more data and software support than they have staff to give, and students have few ways to gain real experience. The work is little known, especially to students from underrepresented backgrounds. Students who want that experience can close the gap, and perhaps widen who thrives in this work.

],
[
#model-diagram()
],
)
#grid(columns: (1.15fr, 1.2fr, 1fr,), column-gutter: 70pt, row-gutter: 40pt,
[
= Paid learning, useful service
<paid-learning-useful-service>
Students are paid employees, supervised by library or department staff. They help researchers with data from wrangling to reproducibility.

== Who is on a squad
<who-is-on-a-squad>
- Student #strong[data analysts] do the hands-on work.
- A student #strong[project manager] triages requests.
- Student #strong[technical writers] document projects.
- #strong[Staff] supervise, fund, and sustain the squad.

== Limits we keep
<limits-we-keep>
Squads help with a researcher's data. They do not change the research questions, tutor, or break confidentiality.

== What it costs in pace
<what-it-costs-in-pace>
Student availability, the academic calendar, onboarding, review, and graduation handoffs all slow the work. More students take on more varied projects but need more oversight. Handbooks, templates, and staff carry continuity.

],
[
= Practices as projects need them
<practices-as-projects-need-them>
Examples sit on a spectrum. Not every client needs a public repository.

#carleton[
#strong[Election-news scraper.] Nine students started, extended, or used it from 2021 to 2024 to collect broadcast transcripts for a political science project. #strong[The tool outlasted the students who began it.]

]
#ucla[
#strong[wbcheck.] Two students began this Carpentries lesson checker in 2023. Staff rebuilt it in 2026 with AI assistance. It has 48 documented rules, tests, a BSD-3 license, and a citation file crediting the original authors.

]
#carleton[
#strong[Language placement dashboard.] The project ran longer than any student would stay, so the squad sketched the database and chose heatmaps for the development team to build.

]
#ucla[
#strong[UC OSPO education site.] Two students built the lesson pages and search for a catalog of 55 open source lessons.

]
#v(30pt)
Where a project calls for it, students add run instructions, a dependency list, one test, or a citation file. We plan to track whether clients keep them.

],
[
= What we know
<what-we-know>
We located 19 UCLA former student employees. By current job category (public profiles, 2026):

#outcomes-list("data/outcomes.csv")
Descriptive, not a placement rate. Carleton tracing is in progress.

== What adopting takes
<what-adopting-takes>
- Paid student positions and a wage budget
- A supervisor with time to review
- Onboarding, and somewhere to keep documentation
- A plan for turnover

#v(44pt)
= Start one
<start-one>
The starter kit covers roles, a confidentiality agreement, onboarding, and request tracking. Ask us for sample job descriptions.

#grid(columns: (3.6in, 1fr,), column-gutter: 36pt, row-gutter: 40pt,
[
#block(
fill:white,
inset:0pt,
radius:4pt,
[
#box(image("assets/qr-datasquad-info.svg", width: 3.6in))

])

],
[
#urltext[
#link("https://datasquad.info/join")[datasquad.info/join]

]
],
)
],
)




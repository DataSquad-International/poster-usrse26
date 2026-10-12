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
   eyebrow: [US-RSE '26 poster · DataSquad International], 
   subtitle: [Student-staffed data and research software support that trains the people who deliver it], 
   authors: [Paula Lackie, Oliver Hall, Tim Dennis, Leigh Phan], 
   affiliations: [Carleton College DataSquad | UCLA Library Data Science Center DataSquad], 
   size: "44x44", 
   logo: "assets/dsi-logo.png", 
   footer-text: [US-RSE '26 · San Jose · Poster reception, Monday Oct 19], 
   footer-url: [datasquad.info], 
   num-columns: 3, 
  doc,
)

= The gap
<the-gap>
Campuses need more data and software support than they have staff to give, and students have few ways to get real experience doing it. The work is hard to see from the outside, so students from underrepresented backgrounds are the least likely to find it.

Students who want that experience can close the gap. They add support capacity, more kinds of people thrive in research software and data work, and the problem-solving is fun.

#block(
fill:rgb(255, 244, 221),
inset:28pt,
radius:10pt,
[
Training students is part of the service. A student is the tool and also a #strong[product] of the service. Those who move on to labs and offices take good practice with them.

])

= What a DataSquad is
<what-a-datasquad-is>
A team of paid undergraduate analysts who help researchers work with data. The network defines what a DataSquad is and how squads coordinate. Each institution runs the day-to-day its own way.

== What squads do
<what-squads-do>
- Data wrangling and transformation
- Data management and the data lifecycle
- Visualization and storytelling
- Reproducibility and open science
- Statistical and analytical support
- Emerging methods, such as geospatial and 3D data

== What squads do not do
<what-squads-do-not-do>
- Change the substance of a researcher's data or research questions
- Tutor or help with homework
- Break confidentiality. Consultations stay in confidence.

= Who is on a squad
<who-is-on-a-squad>
- Student #strong[data analysts] do the hands-on work with researchers.
- Student #strong[technical writers] document projects and write guides.
- A student #strong[project manager] triages requests and keeps work moving.
- Library or department #strong[program staff] supervise, fund, and sustain the squad.

== The tradeoff
<the-tradeoff>
Student turnover and learning time make the service slower than a professional team's. More students can take on more varied projects, but they need more oversight.

= What squads have built
<what-squads-have-built>
- Two UCLA students designed #strong[wbcheck], a Carpentries lesson checker, in 2023. Extended in 2026 with AI assistance, it now has tests, a license, release notes, and a citation file crediting the original authors.
- In the #strong[helicopter flight data] project, a UCLA researcher took our base functions and adapted them to her own questions.
- Carleton's #strong[Google Analytics with Python] write-up gives steps anyone can repeat.

= Where students go
<where-students-go>
#block(
fill:white,
inset:28pt,
radius:10pt,
[
#outcomes-bar("data/outcomes.csv")
19 UCLA DataSquad alumni we have tracked, by current job category. Carleton alumni to be added.

])

= Start one
<start-one>
Borrow the shared pieces and choose the local ones yourself. The starter kit on the site covers roles, a confidentiality agreement, onboarding, and request tracking. Ask us for sample job descriptions.

#grid(columns: (1fr, auto), column-gutter: 30pt, align: horizon,
  [Join the network and find the starter kit at #link("https://datasquad.info/join")[datasquad.info/join]],
  image("assets/qr-datasquad-info.svg", width: 5in),
)




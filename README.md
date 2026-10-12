# USRSE26 poster: Is the DataSquad Model For You?

Poster for US-RSE '26 (San Jose). Reception Monday Oct 19, 2026. Camera-ready Wednesday Oct 21. Max size 44 x 44 in. The PDF also goes to Zenodo.

Built with Quarto + Typst. Coauthors edit words in plain text and open a pull request.

## Edit the words

Everything on the poster is in `poster.qmd`.

- Change the words freely. Keep the `:::` lines: they place each block on the page.
- `# Heading` is a panel title. `## Heading` is a sub-heading inside a panel.
- `::: {.carleton}` and `::: {.ucla}` wrap an example and tag it with its school.
- `::: {.cells columns="1fr 2fr"}` with `::: {.cell}` inside makes independent areas; text stays in its own area.
- Title, authors, and footer are in the block at the top of the file.
- Chart numbers are in `data/outcomes.csv` (`category,count`). The chart redraws itself.
- `<!-- TODO ... -->` comments mark open questions.

Do not edit `typst-template.typ` or `areas.lua` unless you are changing the layout.

## Build

Needs [Quarto](https://quarto.org) 1.9 or later (it bundles Typst).

```bash
quarto render poster.qmd     # writes poster.pdf
```

The Atkinson Hyperlegible font (OFL license) is in `fonts/` and loads automatically.

## Before it goes to print or Zenodo

0. Set `poster-draft: false` at the top of `poster.qmd` to remove the DRAFT watermark, then re-render.
1. Check `pdfinfo poster.pdf`: one page, 3168 x 3168 pt (44 x 44 in).
2. Look at the whole page and zoom into every section for overflow.
3. Scan the QR code on a phone.
4. The logo is the vector DataSquad hexagon mark (`assets/datasquad-mark-white.svg`). The network mark with the globe only exists as a 215 px image, so it is not used.
5. Print a small paper proof.

## Layout

| File | Purpose |
|---|---|
| `poster.qmd` | Words and settings |
| `typst-template.typ`, `typst-show.typ`, `areas.lua` | Layout, colors, header, diagram, chart |
| `data/outcomes.csv` | Alumni outcome counts (aggregates only) |
| `data/README.md`, `scripts/` | Data dictionary and the script that builds the local alumni dataset |
| `submission/` | Title, abstract, presenters, keywords for EasyChair |
| `assets/`, `fonts/` | Logo, QR code, font |

Alumni names, emails, and positions are never committed. Only category counts are. Everything else in `data/` is git-ignored.

Style follows datasquad.info: navy `#1D3557`, steel `#457B9D`, orange `#F9AE1A`, Atkinson Hyperlegible.

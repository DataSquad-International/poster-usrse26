# USRSE26 poster: Is the DataSquad Model For You?

Poster for US-RSE '26 (San Jose). Reception Monday Oct 19, 2026. Camera-ready Wednesday Oct 21. Max size 44 x 44 in. The PDF also goes to Zenodo.

Built with Quarto + Typst. Coauthors edit words in plain text and open a pull request.

## Edit the words

Everything on the poster is in `poster.qmd`.

- `# Heading` makes a section card. `## Heading` makes a sub-heading.
- Title, authors, subtitle, and footer are in the block at the top of the file.
- Student outcome numbers are in `data/outcomes.csv` (`category,count`). The chart redraws itself.
- `<!-- TODO ... -->` comments mark open questions.

Do not edit `typst-template.typ` unless you are changing the layout.

## Build

Needs [Quarto](https://quarto.org) 1.9 or later (it bundles Typst).

```bash
quarto render poster.qmd     # writes poster.pdf
```

The Atkinson Hyperlegible font (OFL license) is in `fonts/` and loads automatically.

## Before it goes to print or Zenodo

1. Check `pdfinfo poster.pdf`: one page, 3168 x 3168 pt (44 x 44 in).
2. Look at the whole page and zoom into every section for overflow.
3. Scan the QR code on a phone.
4. Replace `assets/dsi-logo.png` with a vector or high-resolution original if one exists. The current file is 215 px wide, upscaled 4x.
5. Print a small paper proof.

## Layout

| File | Purpose |
|---|---|
| `poster.qmd` | Words and settings |
| `typst-template.typ`, `typst-show.typ` | Layout, colors, header, chart |
| `data/outcomes.csv` | Alumni outcome counts (aggregates only) |
| `submission/` | Title, abstract, presenters, keywords for EasyChair |
| `assets/`, `fonts/` | Logo, QR code, font |

Alumni names and positions are not stored here. Only category counts are.

Style follows datasquad.info: navy `#1D3557`, steel `#457B9D`, orange `#F9AE1A`, Atkinson Hyperlegible.

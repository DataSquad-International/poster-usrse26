# Contributing

This repository holds the source for the US-RSE '26 poster "Is the DataSquad Model For You?". Coauthors usually only edit words. This page covers how.

## Change the words

1. Make a branch, for example `fix-wording`, or use the GitHub web editor and choose "Create a new branch".
2. Edit `poster.qmd`. Keep the `:::` lines. They place each block on the page. The comment at the top of the file explains the pieces.
3. Open a pull request. Tim Dennis or Paula Lackie reviews and merges. Please do not push straight to `main`.

## Check the build

The "Render poster" check runs automatically on every pull request. It renders the poster and fails if the PDF is not exactly one page at 44 x 44 inches or if a font is not embedded. A green check means the page still fits. The rendered PDF is attached to the run as the `poster-pdf` artifact so you can look at it without installing anything.

To build it yourself, install [Quarto](https://quarto.org) 1.9 or later and run:

```bash
quarto render poster.qmd
```

## Please do not commit

- Names, emails, phone numbers, LinkedIn links, or bios of alumni or students. Only aggregate counts (`data/outcomes.csv`) belong here. Everything else in `data/` is git-ignored on purpose.
- A student's name, photo, or quote on the poster without their written consent for both the printed poster and the public PDF on Zenodo.
- Claims about people or projects that you have not checked against a public source.

## Before the final print

Set `poster-draft: false` in `poster.qmd` to remove the DRAFT watermark, render again, and follow the checklist in the README.

## Conduct

Be kind and assume good intent. By taking part you agree to the [Code of Conduct](./CODE_OF_CONDUCT.md).

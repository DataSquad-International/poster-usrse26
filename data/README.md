# Alumni data (local only)

Everything in `data/` is git-ignored except `outcomes.csv` (aggregate counts for the poster chart) and this file.
Raw files live in `data/raw/`. Never commit them: they contain names, emails, LinkedIn URLs, and bios.

Rebuild the unified file:

```bash
python3 -I scripts/build_unified.py            # writes data/alumni-unified.csv
python3 -I scripts/build_unified.py --counts   # program, category, count (aggregates only)
python3 -I scripts/build_unified.py --poster   # category, UCLA, Carleton counts for data/outcomes.csv (alumni only, each person once)
```

## `alumni-unified.csv` columns

| Column | Meaning | UCLA | Carleton |
|---|---|---|---|
| `person_id` | Stable ID (`UCL-001`, `CAR-001`) so analysis never needs a name | yes | yes |
| `program` | `UCLA` or `Carleton` | yes | yes |
| `first_name`, `last_name` | Split from the source name | yes | yes |
| `group` | `alumni` or `current student` | from source | derived, see QA |
| `grad_year` | Four-digit class year | not in source | from `GraduationYear` |
| `linkedin_url` | Profile URL | not in source | yes |
| `current_position`, `organization`, `location` | Where the person is now | yes | **empty, to fill** |
| `category`, `also_category` | Same category list for both schools | yes | **empty, to fill** |
| `outcome_source`, `outcome_notes` | How and when the outcome was checked | yes | **empty, to fill** |
| `on_website`, `photo_on_site` | Alumni directory flags (`yes`/`no`) | empty | yes |
| `assessment_2025_response`, `web_update_2025` | Responded to the 2025 alumni form | empty | yes |
| `public_bio` | Bio from the alumni directory | empty | yes |
| `record_created` | First `CreationDate` in the Carleton export | empty | yes |
| `qa_flags` | Semicolon-separated data-quality notes | | |
| `poster_category`, `title_raw` | Poster category label from the sheet, or the raw title still to code | yes | yes |
| `major`, `occupation_group` (A to E or `unknown`), `study_status`, `sector`, `data_work`, `confidence`, `soc_code`, `soc_title` | Job classification v1, see `taxonomy/job-classification-v1.md` (SOC codes checked against O*NET) | all 19 alumni coded | empty, to fill |

Email and phone are not copied. They stay in the original Carleton export.

## Poster categories

`outcomes.csv` is written by `python3 -I scripts/build_unified.py --poster`: ranked frequencies of job classification v1 categories, UCLA and Carleton alumni combined, each person once (see `taxonomy/job-classification-v1.md`). Rows starting with `_` hold the coverage numbers that the poster caption prints. Source: `data/SU26DistributionList-DSAlumni.xlsx` (tab 1 Carleton, tab `ds-alumni-shared` UCLA), merged by name.
A sheet value counts only if it is exactly one of the six v1 labels. Raw job titles typed into the classification column (for example "Software Engineer") are NOT counted until someone codes them. Current students are left out.
Coverage: UCLA 19 of 19 alumni coded; Carleton 42 of 113 (about 53 more have a raw title waiting). Carleton is a partial, non-random subset. Coded by one person so far; the two-coder agreement check is still pending.
The old five categories (Data / analytics / consulting; Software / engineering / IT; Research / graduate school; Nonprofit / public sector; Still a student) are retired.
Category is the person's **current** position, as of the check date in `outcome_source`.

## Known QA flags

- `grad_year_two_digit_assumed_20xx`: the Carleton sheet stores years as `5`, `9`, `10` to `29`. Read as 2005, 2009, 2010 to 2029. Confirm 2005 and 2009 with Paula.
- `source_status_alum_but_class_year_in_future`: the sheet marks everyone `Alum`, but class years after 2026 are current students. The build moves them to `current student`.
- `no_linkedin_url`: no usable profile link. The sheet also has `#N/A` formula results.
- The Carleton sheet has two `CreationDate` columns; the first non-empty value is kept.
- Carleton outcomes are not in the sheet. Someone has to check positions, as was done for UCLA, then fill the empty columns.

## `alumni-combined.csv` (one normalized sheet, UCLA + Carleton)

Written by `python3 -I scripts/build_unified.py --combined` (local only, ignored by git: it has names). One row per person, 149 rows. No emails, phones, UIDs, FAUs, or payroll names.

| Column | Rule |
|---|---|
| `person_id`, `program` | `UCL-001` style ID; `UCLA` or `Carleton` |
| `first_name`, `last_name` | Parentheses removed; the removed name goes in `notes` ("also known as") |
| `status` | `alumni` or `current student` (current if the sheet says so, or the class year is after 2026) |
| `grad_year` | Four digits. Carleton two-digit years are read as 20xx (confirm 2005 and 2009 with Paula). Blank for most UCLA alumni: the source has no year |
| `major_1`, `major_2`, `minors` | Split from the sheet: `A/B` and `A; B` become two majors, `(minor: X)` moves to `minors`. `Sociology/Anthropology` and `Political Science/IR` (shown as Political Science and International Relations) stay one major. `&` becomes `and`. Undecided and `#N/A` become blank |
| `job_category` | Job classification v1 label, only when the sheet gives exactly one of the six labels (or the person is a full-time grad student). Blank otherwise |
| `job_category_status` | `coded`, `title only, not yet coded`, `no title found`, or `current student` |
| `job_title` | Current job title from the sheet or the UCLA file. Never an employer |
| `study_status`, `sector`, `data_work`, `soc_code`, `confidence` | UCLA coding detail; blank for Carleton until coded |
| `notes` | Anything the cleaning changed or could not decide |

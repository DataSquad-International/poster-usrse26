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

`outcomes.csv` is written by `build_unified.py --poster` from `data/SU26DistributionList-DSAlumni.xlsx` (tab 1 = Carleton, tab `ds-alumni-shared` = UCLA), merged into the unified file by name. Poster categories are job classification v1 (see `taxonomy/job-classification-v1.md`): Data, statistics and actuarial; Software and IT; Business, finance and consulting; Research, science and teaching; Graduate or professional study; Public service, community and other. A sheet value counts only if it is exactly one of those labels. Raw job titles typed into the classification column (for example "Software Engineer") are kept in `title_raw` and are NOT counted until someone codes them. Current students are left out. Each person counts once.
UCLA: 19 of 19 alumni coded. Carleton: 42 of 113 alumni coded so far (about 53 more have a raw title waiting to be coded), so Carleton counts are a partial, non-random subset. Coded by one person so far; the two-coder agreement check is still pending.
The old five categories (Data / analytics / consulting; Software / engineering / IT; Research / graduate school; Nonprofit / public sector; Still a student) are retired.
Category is the person's **current** position, as of the check date in `outcome_source`.

## Known QA flags

- `grad_year_two_digit_assumed_20xx`: the Carleton sheet stores years as `5`, `9`, `10` to `29`. Read as 2005, 2009, 2010 to 2029. Confirm 2005 and 2009 with Paula.
- `source_status_alum_but_class_year_in_future`: the sheet marks everyone `Alum`, but class years after 2026 are current students. The build moves them to `current student`.
- `no_linkedin_url`: no usable profile link. The sheet also has `#N/A` formula results.
- The Carleton sheet has two `CreationDate` columns; the first non-empty value is kept.
- Carleton outcomes are not in the sheet. Someone has to check positions, as was done for UCLA, then fill the empty columns.

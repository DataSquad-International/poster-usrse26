#!/usr/bin/env python3
"""Build one normalized alumni dataset from the UCLA and Carleton source files.

Inputs (kept local, never committed): data/raw/*.csv
Output (local only):                  data/alumni-unified.csv
Aggregates for the poster:            python3 scripts/build_unified.py --counts

Standard library only. Emails and phone numbers are deliberately NOT copied to the
unified file; they stay in the original Carleton export.
"""
import csv, re, sys, collections, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from xlsx_read import read as read_xlsx
from propose_title_codes import code as propose_code, is_confident

ROOT = pathlib.Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"
OUT = ROOT / "data" / "alumni-unified.csv"
XLSX = ROOT / "data" / "SU26DistributionList-DSAlumni.xlsx"  # tab 1 = Carleton, tab "ds-alumni-shared" = UCLA
THIS_YEAR = 2026  # class years after this are current students

COLUMNS = [
    "person_id", "program", "first_name", "last_name", "group", "grad_year",
    "linkedin_url", "current_position", "organization", "location",
    "category", "also_category", "outcome_source", "outcome_notes",
    "on_website", "photo_on_site", "assessment_2025_response", "web_update_2025",
    "public_bio", "record_created", "qa_flags",
    "major", "occupation_group", "study_status", "sector", "data_work", "confidence", "soc_code", "soc_title",
    "poster_category", "title_raw",
]

# Poster categories (job classification v1). A sheet value counts only if it is exactly one of these.
POSTER_CATEGORIES = [
    "Data, statistics and actuarial", "Software and IT", "Business, finance and consulting",
    "Research, science and teaching", "Graduate or professional study", "Public service, community and other",
]

def clean(s):
    return re.sub(r"\s+", " ", (s or "").replace(" ", " ")).strip()

def yes(s):
    return {"yes": "yes", "y": "yes", "1": "yes", "no": "no", "n": "no", "0": "no"}.get(clean(s).lower(), "")

def split_name(full):
    parts = clean(full).split(" ")
    return (" ".join(parts[:-1]), parts[-1]) if len(parts) > 1 else (clean(full), "")

def load_ucla():
    out = []
    with open(RAW / "ucla-alumni-where-are-they-now.csv", encoding="utf-8-sig", newline="") as f:
        for r in csv.DictReader(f):
            first, last = split_name(r["name"])
            out.append(dict(
                program="UCLA", first_name=first, last_name=last,
                group={"alumni": "alumni", "current student": "current student"}.get(clean(r["group"]).lower(), clean(r["group"])),
                grad_year="", linkedin_url="",
                current_position=clean(r["current_position"]), organization=clean(r["organization"]),
                location=clean(r["location"]), category=clean(r["category"]),
                also_category=clean(r["also_category"]), outcome_source=clean(r["source"]),
                outcome_notes=clean(r["notes"]), on_website="", photo_on_site="",
                assessment_2025_response="", web_update_2025="", public_bio="", record_created="",
                qa_flags="", major=clean(r.get("major", "")), occupation_group=clean(r.get("occupation_group", "")),
                study_status=clean(r.get("study_status", "")), sector=clean(r.get("sector", "")),
                data_work=clean(r.get("data_work", "")), confidence=clean(r.get("confidence", "")),
                soc_code=clean(r.get("soc_code", "")), soc_title=clean(r.get("soc_title", "")),
            ))
    return out

def year4(v):
    v = clean(v)
    if re.fullmatch(r"\d+\.0", v): v = v[:-2]  # xlsx stores years as 2027.0
    if not v.isdigit():
        return "", "grad_year_missing_or_nonnumeric"
    n = int(v)
    return (str(2000 + n) if n < 100 else str(n)), ("grad_year_two_digit_assumed_20xx" if n < 100 else "")

def load_carleton():
    out = []
    p = next(RAW.glob("carleton-alumni-distribution*.csv"))
    with open(p, encoding="utf-8-sig", newline="") as f:
        rows = list(csv.reader(f))
    h, data = rows[0], rows[1:]
    ci = [i for i, c in enumerate(h) if c == "CreationDate"]
    ix = {c: i for i, c in enumerate(h) if c != "CreationDate"}
    g = lambda r, c: clean(r[ix[c]]) if ix[c] < len(r) else ""
    for r in data:
        flags = []
        gy, fl = year4(g(r, "GraduationYear")); flags += [fl] if fl else []
        li = g(r, "Linked In Info") or g(r, "LinkedIn formula")
        if li.startswith("#") or "linkedin.com" not in li: li = ""
        if not li: flags.append("no_linkedin_url")
        group = "alumni"
        if gy and int(gy) > THIS_YEAR:
            group = "current student"; flags.append("source_status_alum_but_class_year_in_future")
        created = next((clean(r[i]) for i in ci if i < len(r) and clean(r[i])), "")
        out.append(dict(
            program="Carleton", first_name=g(r, "FirstName"), last_name=g(r, "LastName"),
            group=group, grad_year=gy, linkedin_url=li,
            current_position="", organization="", location="", category="", also_category="",
            outcome_source="", outcome_notes="",
            on_website=yes(g(r, "On Website")), photo_on_site=yes(g(r, "Photo on Site")),
            assessment_2025_response=yes(g(r, "25' Assessment")), web_update_2025=yes(g(r, "25' Web Update")),
            public_bio=g(r, "personalBio"), record_created=created, qa_flags=";".join(flags),
        ))
    return out

def name_key(first, last):
    f = re.sub(r"\(.*?\)", "", clean(first)).strip().lower()
    l = re.sub(r"\(.*?\)", "", clean(last)).strip().lower()
    return (f.split(" ")[0], l)

def load_sheet(rows, program, major_col, class_col):
    """Rows from an xlsx tab -> {name key: record} with poster category, raw title, major, status."""
    h = [clean(c) for c in rows[0]]
    ix = {}
    for i, c in enumerate(h):  # the UCLA tab has two GraduationYear columns: use the first one that has a value
        if c: ix.setdefault(c, []).append(i)
    g = lambda r, c: next((clean(r[i]) for i in ix.get(c, []) if i < len(r) and clean(r[i])), "")
    out = {}
    for r in rows[1:]:
        if not any(clean(c) for c in r): continue
        first, last = g(r, "FirstName"), g(r, "LastName")
        if not first and not last: continue
        label = g(r, class_col)
        rec = dict(first=first, last=last, major=g(r, major_col), year=g(r, "GraduationYear"), flags=[],
                   title=g(r, "Job Classification (LinkIn Formula)"))
        rec["poster_category"] = label if label in POSTER_CATEGORIES else ""
        rec["current"] = label.lower() == "current student" or g(r, "Status").lower().startswith("current")
        rec["title_raw"] = "" if (rec["poster_category"] or rec["current"] or label in ("", "#N/A")) else label
        if "/" in label and all(p in POSTER_CATEGORIES for p in label.split("/")):
            rec["flags"].append("two_poster_categories_pick_one")
        out[name_key(first, last)] = rec
    return out

def merge_xlsx(rows):
    """Append sheet data to the rows: poster_category, title_raw, major; add people not yet in the file."""
    if not XLSX.exists(): return rows
    book = read_xlsx(str(XLSX))
    carl_tab = next(n for n in book if n.startswith("15Sept25"))
    sheets = {
        "Carleton": load_sheet(book[carl_tab], "Carleton", "Majors", "Job Classification"),
        "UCLA": load_sheet(book["ds-alumni-shared"], "UCLA", "Major", "JobClassification"),
    }
    have = {(r["program"],) + name_key(r["first_name"], r["last_name"]) for r in rows}
    for r in rows:
        rec = sheets[r["program"]].get(name_key(r["first_name"], r["last_name"]))
        if not rec: continue
        r["poster_category"], r["title_raw"] = rec["poster_category"], rec["title_raw"]
        if not r["current_position"] and rec["title"] not in ("", "#N/A", "Current Student"): r["current_position"] = rec["title"]
        if rec["major"]: r["major"] = rec["major"]
        if rec["current"] and r["group"] == "alumni":
            r["group"] = "current student"
            r["qa_flags"] = ";".join(filter(None, [r["qa_flags"], "sheet_labels_current_student"]))
        for f in rec["flags"]: r["qa_flags"] = ";".join(filter(None, [r["qa_flags"], f]))
    for prog, recs in sheets.items():
        for k, rec in recs.items():
            if (prog,) + k in have: continue
            row = {c: "" for c in COLUMNS}
            row.update(program=prog, first_name=rec["first"], last_name=rec["last"], major=rec["major"],
                       group="current student" if (rec["current"] or (year4(rec["year"])[0] and int(year4(rec["year"])[0]) > THIS_YEAR)) else "alumni",
                       grad_year=year4(rec["year"])[0] if rec["year"] else "",
                       poster_category=rec["poster_category"], title_raw=rec["title_raw"],
                       qa_flags=";".join(["added_from_xlsx"] + rec["flags"]))
            rows.append(row)
    return rows

def apply_title_codes(rows):
    """Carleton alumni with a raw title and no category: apply the CONFIDENT rules from scripts/propose_title_codes.py
    (category and SOC code from the title alone, confidence high or medium). Low-confidence titles stay uncoded.
    Flagged in qa_flags so every title-based code can be listed and reviewed by a coder."""
    for r in rows:
        if r["program"] != "Carleton" or r["group"] != "alumni" or r.get("poster_category") or not r.get("title_raw"): continue
        cat, soc, st, conf, why = propose_code(r["title_raw"])
        if is_confident(cat, soc, conf):
            r["poster_category"], r["soc_code"], r["soc_title"], r["confidence"] = cat, soc, st, conf
            r["qa_flags"] = ";".join(filter(None, [r.get("qa_flags", ""), "category_from_title_pending_review"]))
    return rows

def poster_counts(rows):
    """Combined UCLA + Carleton frequencies for the poster: category,count (alumni only, each person once), then
    meta rows starting with "_" for the coverage line. Counts only people with a v1 category; raw titles are not guessed."""
    comb = combined_rows(apply_title_codes(rows))
    al = [r for r in comb if r["status"] == "alumni"]
    c = collections.Counter(r["job_category"] for r in al if r["job_category"])
    table = [["category", "count"]] + [[k, n] for k, n in c.most_common()]
    for p in ("UCLA", "Carleton"):
        pa = [r for r in al if r["program"] == p]
        table.append([f"_{p.lower()}_coded", sum(1 for r in pa if r["job_category"])])
        table.append([f"_{p.lower()}_alumni", len(pa)])
    table.append(["_carleton_from_title", sum(1 for r in al if "category from title alone" in r["notes"])])
    return table

# ---- Combined, normalized table (UCLA + Carleton in one sheet, no emails, phones, IDs, or payroll data) ----
# Majors that contain a "/" but are one program of study at the school, not a double major.
ONE_MAJOR = {"Sociology/Anthropology": "Sociology/Anthropology", "Political Science/IR": "Political Science and International Relations"}
COMBINED_COLUMNS = [
    "person_id", "program", "first_name", "last_name", "status", "grad_year",
    "major_1", "major_2", "minors",
    "job_category", "job_category_status", "job_title",
    "study_status", "sector", "data_work", "soc_code", "confidence", "notes",
]

def split_majors(raw):
    """'Data Theory (minor: GIS)' -> (['Data Theory'], ['GIS']); 'A/B' and 'A; B' -> two majors; blanks for Undecided and #N/A."""
    s = re.sub(r"\s+", " ", (raw or "").strip().replace("&", "and"))
    flags = []
    if s in ("", "#N/A"): return [], [], flags
    if s.lower() == "undecided": return [], [], ["major_undecided_in_source"]
    minors = []
    m = re.search(r"\((?:minors?):\s*([^)]*)\)", s, re.I)
    if m:
        minors = [x.strip() for x in m.group(1).split(",") if x.strip()]
        s = (s[:m.start()] + s[m.end():]).strip()
    majors = []
    for part in re.split(r";", s):
        part = part.strip()
        if not part: continue
        if part in ONE_MAJOR: majors.append(ONE_MAJOR[part])
        elif "/" in part: majors += [x.strip() for x in part.split("/") if x.strip()]
        else: majors.append(part)
    if len(majors) > 2: flags.append("more_than_two_majors_kept_first_two")
    return majors[:2], minors, flags

def combined_rows(rows):
    out = []
    for r in rows:
        majors, minors, mflags = split_majors(r.get("major", ""))
        first = re.sub(r"\s*\(.*?\)", "", r.get("first_name", "")).strip()
        notes = [x for x in mflags]
        pn = re.search(r"\((.*?)\)", r.get("first_name", "") + " " + r.get("last_name", ""))
        if pn: notes.append(f"also known as {pn.group(1)}")
        last = re.sub(r"\s*\(.*?\)", "", r.get("last_name", "")).strip()
        title = clean(r.get("current_position", "")) or clean(r.get("title_raw", ""))
        if r.get("group", "") != "alumni": jstatus = "current student"
        elif r.get("poster_category", ""): jstatus = "coded"
        elif title: jstatus = "title only, not yet coded"
        else: jstatus = "no title found"
        if "two_poster_categories_pick_one" in r.get("qa_flags", ""): notes.append("sheet lists two categories, pick one")
        if "added_from_xlsx" in r.get("qa_flags", ""): notes.append("added from the 2026-10-14 sheet")
        if "category_from_title_pending_review" in r.get("qa_flags", ""): notes.append("category from title alone, pending coder review")
        out.append({
            "person_id": r.get("person_id", ""), "program": r.get("program", ""), "first_name": first, "last_name": last,
            "status": r.get("group", ""), "grad_year": r.get("grad_year", ""),
            "major_1": majors[0] if majors else "", "major_2": majors[1] if len(majors) > 1 else "",
            "minors": "; ".join(minors),
            "job_category": r.get("poster_category", "") or ("Graduate or professional study" if r.get("study_status", "") == "grad_full_time" and r.get("group", "") == "alumni" else ""),
            "job_category_status": jstatus, "job_title": title,
            "study_status": r.get("study_status", ""), "sector": r.get("sector", ""), "data_work": r.get("data_work", ""),
            "soc_code": r.get("soc_code", ""), "confidence": r.get("confidence", ""), "notes": "; ".join(notes),
        })
    out.sort(key=lambda d: (d["program"], d["last_name"].lower(), d["first_name"].lower()))
    return out

def main():
    rows = merge_xlsx(load_ucla() + load_carleton())
    seen = collections.Counter((r["program"], r["first_name"].lower(), r["last_name"].lower()) for r in rows)
    for r in rows:
        if seen[(r["program"], r["first_name"].lower(), r["last_name"].lower())] > 1:
            r["qa_flags"] = ";".join(filter(None, [r["qa_flags"], "duplicate_name_in_program"]))
    n = collections.Counter()
    for r in rows:
        n[r["program"]] += 1
        r["person_id"] = f'{r["program"][:3].upper()}-{n[r["program"]]:03d}'
    if "--combined" in sys.argv:
        comb = combined_rows(rows)
        path = ROOT / "data" / "alumni-combined.csv"
        with open(path, "w", encoding="utf-8", newline="") as f:
            w = csv.DictWriter(f, fieldnames=COMBINED_COLUMNS); w.writeheader(); w.writerows(comb)
        print(f"wrote {path.relative_to(ROOT)}: {len(comb)} rows"); return
    if "--poster" in sys.argv:
        csv.writer(sys.stdout, lineterminator="\n").writerows(poster_counts(rows)); return
    if "--counts" in sys.argv:
        c = collections.Counter((r["program"], r["category"]) for r in rows if r["group"] == "alumni" and r["category"])
        w = csv.writer(sys.stdout); w.writerow(["program", "category", "count"])
        for (p, cat), k in sorted(c.items()): w.writerow([p, cat, k])
        return
    with open(OUT, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=COLUMNS); w.writeheader(); w.writerows(rows)
    print(f"wrote {OUT.relative_to(ROOT)}: {len(rows)} rows")

main()

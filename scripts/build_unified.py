#!/usr/bin/env python3
"""Build one normalized alumni dataset from the UCLA and Carleton source files.

Inputs (kept local, never committed): data/raw/*.csv
Output (local only):                  data/alumni-unified.csv
Aggregates for the poster:            python3 scripts/build_unified.py --counts

Standard library only. Emails and phone numbers are deliberately NOT copied to the
unified file; they stay in the original Carleton export.
"""
import csv, re, sys, collections, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"
OUT = ROOT / "data" / "alumni-unified.csv"
THIS_YEAR = 2026  # class years after this are current students

COLUMNS = [
    "person_id", "program", "first_name", "last_name", "group", "grad_year",
    "linkedin_url", "current_position", "organization", "location",
    "category", "also_category", "outcome_source", "outcome_notes",
    "on_website", "photo_on_site", "assessment_2025_response", "web_update_2025",
    "public_bio", "record_created", "qa_flags",
    "major", "level1_group", "also_group", "soc_code", "soc_title",
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
                qa_flags="", major=clean(r.get("major", "")), level1_group=clean(r.get("level1_group", "")),
                also_group=clean(r.get("also_group", "")), soc_code=clean(r.get("soc_code", "")),
                soc_title=clean(r.get("soc_title", "")),
            ))
    return out

def year4(v):
    v = clean(v)
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

def main():
    rows = load_ucla() + load_carleton()
    seen = collections.Counter((r["program"], r["first_name"].lower(), r["last_name"].lower()) for r in rows)
    for r in rows:
        if seen[(r["program"], r["first_name"].lower(), r["last_name"].lower())] > 1:
            r["qa_flags"] = ";".join(filter(None, [r["qa_flags"], "duplicate_name_in_program"]))
    n = collections.Counter()
    for r in rows:
        n[r["program"]] += 1
        r["person_id"] = f'{r["program"][:3].upper()}-{n[r["program"]]:03d}'
    if "--counts" in sys.argv:
        c = collections.Counter((r["program"], r["category"]) for r in rows if r["group"] == "alumni" and r["category"])
        w = csv.writer(sys.stdout); w.writerow(["program", "category", "count"])
        for (p, cat), k in sorted(c.items()): w.writerow([p, cat, k])
        return
    with open(OUT, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=COLUMNS); w.writeheader(); w.writerows(rows)
    print(f"wrote {OUT.relative_to(ROOT)}: {len(rows)} rows")

main()

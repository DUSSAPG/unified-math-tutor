import argparse
import csv
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CATALOG_PATH = ROOT / "assets" / "config" / "topic_catalog.json"
TEMPLATE_PATH = ROOT / "reports" / "topic_labels_template.csv"
LOCALES = ["en", "en-GB", "fr-CH", "de-CH", "it-CH"]
CH_LOCALES = ["fr-CH", "de-CH", "it-CH"]


def load_catalog(path=CATALOG_PATH):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def write_catalog(catalog, path=CATALOG_PATH):
    with path.open("w", encoding="utf-8", newline="\n") as f:
        json.dump(catalog, f, ensure_ascii=False, indent=2)
        f.write("\n")


def export_template(args):
    catalog = load_catalog()
    TEMPLATE_PATH.parent.mkdir(parents=True, exist_ok=True)
    with TEMPLATE_PATH.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "topic_id",
                "field",
                "en",
                "en-GB",
                "fr-CH",
                "de-CH",
                "it-CH",
            ],
        )
        writer.writeheader()
        for topic in sorted(catalog["topics"], key=lambda item: item["id"]):
            for field in ["title", "subtitle"]:
                row = {"topic_id": topic["id"], "field": field}
                for locale in LOCALES:
                    row[locale] = topic["locales"].get(locale, {}).get(field, "")
                writer.writerow(row)
    print(f"wrote {TEMPLATE_PATH.relative_to(ROOT)}")


def apply_translations(args):
    catalog = load_catalog()
    rows = []
    with Path(args.csv).open("r", encoding="utf-8", newline="") as f:
        rows = list(csv.DictReader(f))

    by_id = {topic["id"]: topic for topic in catalog["topics"]}
    for row in rows:
        topic = by_id.get(row["topic_id"])
        if topic is None:
            raise SystemExit(f"unknown topic_id: {row['topic_id']}")
        field = row["field"]
        if field not in {"title", "subtitle"}:
            raise SystemExit(f"unknown field: {field}")
        for locale in LOCALES:
            value = row.get(locale, "").strip()
            if not value:
                continue
            topic.setdefault("locales", {}).setdefault(locale, {})[field] = value

    write_catalog(catalog)
    print(f"updated {CATALOG_PATH.relative_to(ROOT)}")


def check_no_english_leaks(args):
    catalog = load_catalog()
    failures = []
    for topic in catalog["topics"]:
        english_values = [
            topic["locales"]["en"]["title"],
            topic["locales"]["en"]["subtitle"],
            topic["locales"].get("en-GB", {}).get("title", ""),
            topic["locales"].get("en-GB", {}).get("subtitle", ""),
        ]
        english_ascii = {
            normalize(value)
            for value in english_values
            if value and is_ascii_words(value)
        }
        for locale in CH_LOCALES:
            localized = topic["locales"].get(locale)
            if not localized:
                failures.append(f"{topic['id']} missing {locale}")
                continue
            for field in ["title", "subtitle"]:
                value = localized.get(field, "")
                if normalize(value) in english_ascii:
                    failures.append(
                        f"{topic['id']} {locale} {field} leaks English: {value}"
                    )
    if failures:
        raise SystemExit("\n".join(failures))
    print("topic catalog CH no-English-leak check passed")


def normalize(value):
    return re.sub(r"\s+", " ", re.sub(r"[^a-z0-9]+", " ", value.lower())).strip()


def is_ascii_words(value):
    return bool(re.search(r"[A-Za-z]", value)) and all(ord(ch) < 128 for ch in value)


def main():
    parser = argparse.ArgumentParser(description="Maintain localized topic catalog.")
    subparsers = parser.add_subparsers(required=True)

    export_parser = subparsers.add_parser("export-template")
    export_parser.set_defaults(func=export_template)

    apply_parser = subparsers.add_parser("apply")
    apply_parser.add_argument("csv")
    apply_parser.set_defaults(func=apply_translations)

    check_parser = subparsers.add_parser("check-no-english-leaks")
    check_parser.set_defaults(func=check_no_english_leaks)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()

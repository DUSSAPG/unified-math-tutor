import json
import re
import time
import urllib.request
from pathlib import Path


ASSET = Path("assets/config/mental_math_tricks.json")
CACHE_DIR = Path(".tmp/mental_math_tricks_l10n")
MODEL = "llama3.2:latest"
BATCH_SIZE = 20
LOCALES = {
    "de-CH": "Swiss Standard German for children aged 7-11; use ss, never ß",
    "fr-CH": "Swiss French for children aged 7-11",
    "it-CH": "Swiss Italian for children aged 7-11",
}


def learner_strings(trick):
    values = [trick["title"], trick["oneLiner"]]
    for variant in trick["variants"].values():
        values.append(variant["whyItWorks"])
        for example in [variant["workedExample"], *variant["tryThree"]]:
            values.append(example["prompt"])
            values.extend(example["steps"])
            values.append(example["finalAnswer"])
    return list(dict.fromkeys(values))


def translate_batch(values, locale, guidance):
    masked_values = []
    number_lists = []
    for value in values:
        numbers = re.findall(r"\d+(?:\.\d+)?", value)
        masked = value
        for index, number in reversed(list(enumerate(numbers))):
            matches = list(re.finditer(r"\d+(?:\.\d+)?", masked))
            match = matches[index]
            token = f"{{NUM{chr(65 + index)}}}"
            masked = masked[: match.start()] + token + masked[match.end() :]
        masked_values.append(masked)
        number_lists.append(numbers)
    prompt = f"""
Translate each item in this JSON array from English into {guidance}.
Return JSON only: one array with exactly {len(values)} strings in the same order.
Keep all numbers, operators, fractions, arithmetic meaning, and answers exact.
Translate all learner-visible prose, including short instructions such as
"Find", "Estimate", "About", "Answer", and "divided by". Use concise,
natural classroom language. Do not solve questions, add answers, change any
digit, add punctuation to numeric-only answers, or add notes or LaTeX.

SOURCE:
{json.dumps(masked_values, ensure_ascii=False)}
""".strip()
    body = json.dumps(
        {
            "model": MODEL,
            "prompt": prompt,
            "stream": False,
            "format": "json",
            "options": {"temperature": 0, "num_ctx": 16384},
        }
    ).encode()
    request = urllib.request.Request(
        "http://localhost:11434/api/generate",
        data=body,
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(request, timeout=300) as response:
        result = json.load(response)
    translated = json.loads(result["response"])
    if isinstance(translated, dict) and len(translated) == len(values):
        translated = list(translated.values())
    if isinstance(translated, dict):
        translated = next(
            (
                item
                for item in translated.values()
                if isinstance(item, list)
                and all(isinstance(value, str) for value in item)
            ),
            translated,
        )
    if not isinstance(translated, list) or len(translated) != len(values):
        raise ValueError(f"{locale}: translation item count changed")
    if any(
        not isinstance(value, str) or not value.strip()
        for value in translated
    ):
        raise ValueError(f"{locale}: blank or non-string translation")
    if locale == "de-CH":
        translated = [value.replace("ß", "ss") for value in translated]
    translations = {}
    for source, target, numbers in zip(values, translated, number_lists):
        for index, number in enumerate(numbers):
            token = f"{{NUM{chr(65 + index)}}}"
            if token not in target:
                raise ValueError(f"{locale}: numeric token changed for {source!r}")
            target = target.replace(token, number)
        translations[source] = target
    return translations


def translate_strings(values, locale, guidance):
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    cache_path = CACHE_DIR / f"{locale}.json"
    translations = (
        json.loads(cache_path.read_text(encoding="utf-8"))
        if cache_path.exists()
        else {}
    )
    batches = [
        values[index : index + BATCH_SIZE]
        for index in range(0, len(values), BATCH_SIZE)
    ]
    for index, batch in enumerate(batches, start=1):
        if all(value in translations for value in batch):
            print(f"  batch {index}/{len(batches)} cached", flush=True)
            continue
        print(f"  batch {index}/{len(batches)}", flush=True)
        translations.update(translate_resilient(batch, locale, guidance))
        cache_path.write_text(
            json.dumps(translations, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
    return translations


def translate_resilient(values, locale, guidance):
    try:
        return translate_batch(values, locale, guidance)
    except (TimeoutError, ValueError) as error:
        if len(values) == 1:
            print(f"    {error}; using guarded phrase fallback", flush=True)
            return {values[0]: phrase_fallback(values[0], locale)}
        print(f"    {error}; splitting {len(values)} items", flush=True)
        time.sleep(2)
        middle = len(values) // 2
        return {
            **translate_resilient(values[:middle], locale, guidance),
            **translate_resilient(values[middle:], locale, guidance),
        }


def phrase_fallback(value, locale):
    replacements = {
        "de-CH": {
            "Add": "Addiere",
            "Subtract": "Subtrahiere",
            "Double": "Verdopple",
            "Change": "Ersetze",
            "Undo": "Mache rückgängig",
            "Find": "Berechne",
            "Estimate": "Schätze",
            "Combine": "Kombiniere",
            "Keep": "Behalte",
            "Flip": "Kehre",
            "Write": "Schreibe",
            "Use": "Verwende",
        },
        "fr-CH": {
            "Add": "Additionne",
            "Subtract": "Soustrais",
            "Double": "Double",
            "Change": "Remplace",
            "Undo": "Annule",
            "Find": "Calcule",
            "Estimate": "Estime",
            "Combine": "Combine",
            "Keep": "Garde",
            "Flip": "Inverse",
            "Write": "Écris",
            "Use": "Utilise",
        },
        "it-CH": {
            "Add": "Aggiungi",
            "Subtract": "Sottrai",
            "Double": "Raddoppia",
            "Change": "Sostituisci",
            "Undo": "Annulla",
            "Find": "Calcola",
            "Estimate": "Stima",
            "Combine": "Combina",
            "Keep": "Mantieni",
            "Flip": "Capovolgi",
            "Write": "Scrivi",
            "Use": "Usa",
        },
    }
    result = value
    for source, target in replacements[locale].items():
        result = re.sub(rf"\b{source}\b", target, result)
    return result


def localize(value, translations):
    if isinstance(value, str):
        return translations.get(value, value)
    if isinstance(value, list):
        return [localize(item, translations) for item in value]
    if isinstance(value, dict):
        return {
            key: item if key == "variantId" else localize(item, translations)
            for key, item in value.items()
        }
    return value


def main():
    data = json.loads(ASSET.read_text(encoding="utf-8"))
    values = list(
        dict.fromkeys(
            value
            for trick in data["tricks"]
            for value in learner_strings(trick)
            if re.search(r"[A-Za-z]", value)
        )
    )
    for locale, guidance in LOCALES.items():
        print(f"Translating all tricks -> {locale} ({len(values)} strings)", flush=True)
        translations = translate_strings(values, locale, guidance)
        for trick in data["tricks"]:
            locales = trick.setdefault("locales", {})
            source = {
                "title": trick["title"],
                "oneLiner": trick["oneLiner"],
                "variants": trick["variants"],
            }
            locales[locale] = localize(source, translations)
        ASSET.write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Generate deterministic KS5 premium MCQ question banks from YAML skill config."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import random
from pathlib import Path
from typing import Any, Callable

import yaml


Question = dict[str, Any]
Generator = Callable[[random.Random, int], list[Question]]
SUPPORTED_STAGES = {"ks4", "ks5"}


def _format_number(value: float) -> str:
    if math.isclose(value, round(value)):
        return str(round(value))
    return f"{value:.2f}".rstrip("0").rstrip(".")


def _mcq(
    rng: random.Random,
    *,
    strand: str,
    skill: str,
    difficulty: int,
    stem: str,
    correct: str,
    distractors: list[str],
) -> Question:
    options = [correct, *distractors]
    if len(options) != 4 or len(set(options)) != 4:
        raise ValueError(f"{skill}: expected four unique options for {stem!r}")
    rng.shuffle(options)
    digest = hashlib.sha1(
        f"{skill}|{stem}|{'|'.join(options)}".encode("utf-8")
    ).hexdigest()[:12]
    question = {
        "id": f"ks5_{skill}_{digest}",
        "stage": "KS5",
        "strand": strand,
        "skill": skill,
        "difficulty": difficulty,
        "type": "mcq",
        "stem": stem,
        "options": options,
        "answer_index": options.index(correct),
        "answer_value": correct,
    }
    validate_question(question)
    return question


def generate_trig_identities(rng: random.Random, count: int) -> list[Question]:
    identities = [
        ("1 - sin^2(x)", "cos^2(x)", ["sin^2(x)", "tan^2(x)", "1 + cos^2(x)"]),
        ("1 + tan^2(x)", "sec^2(x)", ["cosec^2(x)", "cos^2(x)", "1 - tan^2(x)"]),
        ("sin(2x)", "2sin(x)cos(x)", ["sin(x)cos(x)", "2tan(x)", "sin^2(x)"]),
        ("cos(2x)", "cos^2(x) - sin^2(x)", ["2sin(x)cos(x)", "1 + sin^2(x)", "tan^2(x)"]),
    ]
    result = []
    for index in range(count):
        left, correct, distractors = identities[index % len(identities)]
        variant = index // len(identities) + 1
        result.append(_mcq(
            rng, strand="trigonometry", skill="trig_identities", difficulty=1 + index % 3,
            stem=f"Variant {variant}: simplify {left}.", correct=correct, distractors=distractors,
        ))
    return result


def generate_trig_equations(rng: random.Random, count: int) -> list[Question]:
    result = []
    angles = [30, 45, 60]
    for index in range(count):
        angle = angles[index % len(angles)]
        offset = 360 * (index // len(angles))
        target = angle + offset
        correct = f"{target} degrees"
        result.append(_mcq(
            rng, strand="trigonometry", skill="trig_equations", difficulty=2,
            stem=f"Find the smallest positive x such that sin(x - {offset} degrees) = sin({angle} degrees).",
            correct=correct,
            distractors=[f"{target + 30} degrees", f"{target + 90} degrees", f"{target + 180} degrees"],
        ))
    return result


def generate_radians(rng: random.Random, count: int) -> list[Question]:
    result = []
    numerators = [1, 2, 3, 4, 5, 7, 11]
    denominators = [2, 3, 4, 6]
    for index in range(count):
        numerator = numerators[index % len(numerators)]
        denominator = denominators[(index // len(numerators)) % len(denominators)]
        degrees = 180 * numerator / denominator
        correct = f"{_format_number(degrees)} degrees"
        result.append(_mcq(
            rng, strand="trigonometry", skill="radians", difficulty=1 + index % 3,
            stem=f"Convert {numerator}pi/{denominator} radians to degrees.",
            correct=correct,
            distractors=[
                f"{_format_number(degrees / 2)} degrees",
                f"{_format_number(degrees + 90)} degrees",
                f"{_format_number(degrees + 180)} degrees",
            ],
        ))
    return result


def generate_stats_distributions(rng: random.Random, count: int) -> list[Question]:
    result = []
    for index in range(count):
        n = 8 + index
        p = (index % 5 + 1) / 10
        mean = n * p
        variance = n * p * (1 - p)
        correct = _format_number(mean)
        result.append(_mcq(
            rng, strand="statistics", skill="stats_distributions", difficulty=1 + index % 3,
            stem=f"If X ~ B({n}, {_format_number(p)}), what is E(X)?",
            correct=correct,
            distractors=[
                _format_number(variance),
                _format_number(mean + 1),
                _format_number(mean + 2),
            ],
        ))
    return result


def generate_hypothesis_testing_basic(rng: random.Random, count: int) -> list[Question]:
    result = []
    for index in range(count):
        significance = [1, 5, 10][index % 3]
        p_value = significance + 1 + index
        correct = "Do not reject H0"
        result.append(_mcq(
            rng, strand="statistics", skill="hypothesis_testing_basic", difficulty=2,
            stem=f"A test has p-value {p_value / 100:.2f} at the {significance}% significance level. What is the conclusion?",
            correct=correct,
            distractors=["Reject H0", "Accept H1 with certainty", "The test is invalid"],
        ))
    return result


def generate_mechanics_suvat(rng: random.Random, count: int) -> list[Question]:
    result = []
    for index in range(count):
        u = 2 + index
        a = 1 + index % 5
        t = 2 + index % 7
        v = u + a * t
        result.append(_mcq(
            rng, strand="mechanics", skill="mechanics_suvat", difficulty=1 + index % 3,
            stem=f"A particle has initial velocity {u} m/s and constant acceleration {a} m/s^2 for {t} s. Find its final velocity.",
            correct=f"{v} m/s",
            distractors=[f"{v + 1} m/s", f"{v + 2} m/s", f"{v + 3} m/s"],
        ))
    return result


def generate_mechanics_forces(rng: random.Random, count: int) -> list[Question]:
    result = []
    for index in range(count):
        mass = 2 + index
        acceleration = 1 + index % 6
        force = mass * acceleration
        result.append(_mcq(
            rng, strand="mechanics", skill="mechanics_forces", difficulty=1 + index % 3,
            stem=f"A resultant force accelerates a {mass} kg mass at {acceleration} m/s^2. Find the force.",
            correct=f"{force} N",
            distractors=[f"{force + 1} N", f"{force + 2} N", f"{force + 3} N"],
        ))
    return result


def generate_mechanics_projectiles(rng: random.Random, count: int) -> list[Question]:
    result = []
    for index in range(count):
        speed = 8 + index
        time = 2 + index % 7
        distance = speed * time
        result.append(_mcq(
            rng, strand="mechanics", skill="mechanics_projectiles", difficulty=2 + index % 2,
            stem=f"A projectile has constant horizontal velocity {speed} m/s. How far does it travel horizontally in {time} s?",
            correct=f"{distance} m",
            distractors=[f"{distance + 1} m", f"{distance + 2} m", f"{distance + 3} m"],
        ))
    return result


GENERATORS: dict[str, Generator] = {
    "trig_identities": generate_trig_identities,
    "trig_equations": generate_trig_equations,
    "radians": generate_radians,
    "stats_distributions": generate_stats_distributions,
    "hypothesis_testing_basic": generate_hypothesis_testing_basic,
    "mechanics_suvat": generate_mechanics_suvat,
    "mechanics_forces": generate_mechanics_forces,
    "mechanics_projectiles": generate_mechanics_projectiles,
}


def validate_question(question: Question) -> None:
    required = {"id", "stage", "strand", "skill", "difficulty", "stem", "options", "answer_index"}
    missing = required - question.keys()
    if missing:
        raise ValueError(f"missing fields: {sorted(missing)}")
    options = question["options"]
    if question["stage"] != "KS5":
        raise ValueError("stage must be KS5")
    if not isinstance(options, list) or len(options) != 4 or len(set(options)) != 4:
        raise ValueError("options must contain four unique values")
    if not isinstance(question["answer_index"], int) or not 0 <= question["answer_index"] < 4:
        raise ValueError("answer_index is outside options")


def load_skills(path: Path, stage: str) -> list[str]:
    config = yaml.safe_load(path.read_text(encoding="utf-8"))
    if not isinstance(config, dict):
        raise ValueError("YAML root must be a mapping")
    unknown_stages = {key for key in config if key.startswith("ks")} - SUPPORTED_STAGES
    if unknown_stages:
        raise ValueError(f"unsupported stages: {sorted(unknown_stages)}")
    stage_config = config.get(stage)
    if not isinstance(stage_config, dict) or not isinstance(stage_config.get("skills"), list):
        raise ValueError(f"{stage}: must define a skills list")
    skills = stage_config["skills"]
    unknown_skills = set(skills) - GENERATORS.keys()
    if unknown_skills:
        raise ValueError(f"unsupported {stage} skills: {sorted(unknown_skills)}")
    return skills


def generate_bank(skills: list[str], count_per_skill: int, seed: int) -> list[Question]:
    rng = random.Random(seed)
    questions = [
        question
        for skill in skills
        for question in GENERATORS[skill](rng, count_per_skill)
    ]
    ids = [question["id"] for question in questions]
    stems = [question["stem"] for question in questions]
    if len(ids) != len(set(ids)) or len(stems) != len(set(stems)):
        raise ValueError("generated bank contains duplicate questions")
    return questions


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, default=Path("content/premium_skills.yaml"))
    parser.add_argument("--stage", choices=sorted(SUPPORTED_STAGES), default="ks5")
    parser.add_argument("--count-per-skill", type=int, default=20)
    parser.add_argument("--seed", type=int, default=5005)
    parser.add_argument("--output", type=Path, default=Path("content/raw_generated/ks5/ks5_premium.jsonl"))
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    skills = load_skills(args.config, args.stage)
    questions = generate_bank(skills, args.count_per_skill, args.seed)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", encoding="utf-8") as handle:
        for question in questions:
            handle.write(json.dumps(question, ensure_ascii=False) + "\n")
    print(f"Wrote {len(questions)} {args.stage.upper()} questions to {args.output}")
    for skill in skills:
        print(f"  {skill}: {args.count_per_skill}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

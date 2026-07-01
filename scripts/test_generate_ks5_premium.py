#!/usr/bin/env python3
"""Tests for deterministic KS5 premium generation."""

from __future__ import annotations

import importlib.util
import random
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("02_generate_ks5_premium.py")
SPEC = importlib.util.spec_from_file_location("generate_ks5_premium", SCRIPT)
assert SPEC and SPEC.loader
GENERATOR = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GENERATOR)


class Ks5PremiumGeneratorTest(unittest.TestCase):
    def test_each_generator_emits_twenty_valid_unique_questions(self) -> None:
        for skill, generate in GENERATOR.GENERATORS.items():
            with self.subTest(skill=skill):
                questions = generate(random.Random(1234), 20)
                self.assertEqual(20, len(questions))
                self.assertEqual(20, len({q["id"] for q in questions}))
                self.assertEqual(20, len({q["stem"] for q in questions}))
                for question in questions:
                    GENERATOR.validate_question(question)
                    self.assertEqual("KS5", question["stage"])
                    self.assertEqual(skill, question["skill"])
                    self.assertEqual(4, len(question["options"]))

    def test_bank_is_deterministic_for_seed(self) -> None:
        skills = list(GENERATOR.GENERATORS)
        first = GENERATOR.generate_bank(skills, count_per_skill=20, seed=99)
        second = GENERATOR.generate_bank(skills, count_per_skill=20, seed=99)
        self.assertEqual(first, second)

    def test_yaml_accepts_ks5(self) -> None:
        config = SCRIPT.parents[1] / "content" / "premium_skills.yaml"
        skills = GENERATOR.load_skills(config, "ks5")
        self.assertEqual(set(GENERATOR.GENERATORS), set(skills))


if __name__ == "__main__":
    unittest.main()

# tests/test_id_factory.py
#
# Tests for the IdFactory utility.
# Run with:  python manage.py test tests.test_id_factory
#

import django
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'softdes.settings')
django.setup()

from django.test import TestCase
from api.utils.idFactory import IdFactory


class TestIdFactory(TestCase):

    def test_returns_an_integer(self):
        result = IdFactory.create_numeric_id(10)
        self.assertIsInstance(result, int)

    def test_length_20_stays_within_digit_range(self):
        # A 20-digit id shouldn't exceed 20 digits worth of magnitude
        result = IdFactory.create_numeric_id(20)
        self.assertGreaterEqual(result, 0)
        # upper bound: every digit is 9 → 9 * (10^0 + 10^1 + ... + 10^19)
        upper = sum(9 * (10 ** i) for i in range(20))
        self.assertLessEqual(result, upper)

    def test_zero_length_returns_zero(self):
        result = IdFactory.create_numeric_id(0)
        self.assertEqual(result, 0)

    def test_length_one_is_single_digit(self):
        for _ in range(50):   # run a bunch of times to catch randomness issues
            result = IdFactory.create_numeric_id(1)
            self.assertGreaterEqual(result, 0)
            self.assertLessEqual(result, 9)

    def test_two_calls_are_not_always_identical(self):
        # With 20 digits of randomness, the chance of a collision is ~1e-20
        results = {IdFactory.create_numeric_id(20) for _ in range(10)}
        self.assertGreater(len(results), 1,
            "Got the same ID 10 times in a row — something is wrong with the RNG")

    def test_result_is_non_negative(self):
        for length in [1, 5, 10, 20]:
            with self.subTest(length=length):
                self.assertGreaterEqual(IdFactory.create_numeric_id(length), 0)

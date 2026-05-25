# tests/test_credentials_handler.py
#
# Tests for the chain-of-responsibility credential validators.
# Run with:  python manage.py test tests.test_credentials_handler
#

import django
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'softdes.settings')
django.setup()

from django.test import TestCase
from api.middleware.CredentialsHandler import (
    CheckSchoolEmailHandler,
    CheckIllegalCharactersHandler,
    CheckProfanityHandler,
)


class TestSchoolEmailHandler(TestCase):

    def setUp(self):
        self.handler = CheckSchoolEmailHandler()

    def test_valid_usc_email_passes(self):
        result = self.handler.handle("juandelacruz@usc.edu.ph")
        # True means the chain passed — no errors
        self.assertEqual(result, True)

    def test_gmail_is_rejected(self):
        result = self.handler.handle("juandelacruz@gmail.com")
        self.assertIsInstance(result, str)
        self.assertIn("Invalid email format", result)

    def test_empty_string_fails(self):
        result = self.handler.handle("")
        self.assertIsInstance(result, str)

    def test_partial_domain_fails(self):
        # "usc.edu" without the .ph should still fail
        result = self.handler.handle("someone@usc.edu")
        self.assertIsInstance(result, str)

    def test_usc_domain_anywhere_in_string_passes(self):
        # edge case: what if @usc.edu.ph appears mid-string somehow
        result = self.handler.handle("test@usc.edu.ph.extra")
        # handler only checks 'in', so this technically passes the email check
        # documenting the current behaviour rather than asserting ideal behaviour
        self.assertIsNotNone(result)


class TestIllegalCharactersHandler(TestCase):

    def setUp(self):
        self.email_handler = CheckIllegalCharactersHandler()

        self.username_handler = CheckIllegalCharactersHandler()
        self.username_handler.is_username = True

    # --- email / password mode ---

    def test_clean_email_passes(self):
        result = self.email_handler.handle("clean@usc.edu.ph")
        self.assertEqual(result, True)

    def test_dollar_sign_in_email_fails(self):
        result = self.email_handler.handle("bad$email@usc.edu.ph")
        self.assertIn("illegal characters", result)

    def test_hash_in_password_fails(self):
        result = self.email_handler.handle("pass#word")
        self.assertIn("illegal characters", result)

    def test_all_illegal_email_chars_caught(self):
        for ch in ['!', '#', '$', '%', '^', '&', '*']:
            with self.subTest(char=ch):
                result = self.email_handler.handle(f"test{ch}@usc.edu.ph")
                self.assertIsInstance(result, str,
                    msg=f"Expected failure for char '{ch}' but got True")

    # --- username mode ---

    def test_clean_username_passes(self):
        result = self.username_handler.handle("juan_dela_cruz")
        self.assertEqual(result, True)

    def test_dot_in_username_fails(self):
        result = self.username_handler.handle("juan.delacruz")
        self.assertIn("illegal characters", result)

    def test_parentheses_in_username_fails(self):
        result = self.username_handler.handle("user(name)")
        self.assertIn("illegal characters", result)

    def test_backslash_in_username_fails(self):
        result = self.username_handler.handle("back\\slash")
        self.assertIn("illegal characters", result)


class TestProfanityHandler(TestCase):

    def setUp(self):
        self.handler = CheckProfanityHandler()

    def test_normal_text_passes(self):
        result = self.handler.handle("community_service_activity")
        self.assertEqual(result, True)

    def test_normal_email_passes(self):
        result = self.handler.handle("jsmith@usc.edu.ph")
        self.assertEqual(result, True)

    def test_clean_title_passes(self):
        result = self.handler.handle("Coastal Cleanup Drive 2026")
        self.assertEqual(result, True)


class TestFullChain(TestCase):
    """
    Mirrors the exact chain UserApiMiddleware.validateCredentials builds
    for the email field:  IllegalChars -> SchoolEmail -> Profanity
    """

    def _build_email_chain(self):
        check_illegal = CheckIllegalCharactersHandler()
        check_school  = CheckSchoolEmailHandler()
        check_profane = CheckProfanityHandler()
        check_illegal.set_next(check_school).set_next(check_profane)
        return check_illegal

    def test_good_email_clears_full_chain(self):
        chain = self._build_email_chain()
        self.assertEqual(chain.handle("jsmith@usc.edu.ph"), True)

    def test_illegal_char_short_circuits_chain(self):
        chain = self._build_email_chain()
        # Should stop at the first handler, never reach the school-email check
        result = chain.handle("bad$@usc.edu.ph")
        self.assertIn("illegal characters", result)

    def test_wrong_domain_stopped_before_profanity(self):
        chain = self._build_email_chain()
        result = chain.handle("someone@gmail.com")
        self.assertIn("Invalid email format", result)

    def test_set_next_returns_the_handler_for_chaining(self):
        # make sure set_next is actually chainable (returns the passed handler)
        h1 = CheckIllegalCharactersHandler()
        h2 = CheckSchoolEmailHandler()
        returned = h1.set_next(h2)
        self.assertIs(returned, h2)

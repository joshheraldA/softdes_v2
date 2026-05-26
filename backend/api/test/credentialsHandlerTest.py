import pytest
# Point explicitly to the utils app where the handler lives
from api.middleware.CredentialsHandler import (
    CheckSchoolEmailHandler,
    CheckIllegalCharactersHandler,
    CheckProfanityHandler
)

email_handler = CheckSchoolEmailHandler()
illegal_char_handler = CheckIllegalCharactersHandler()
profanity_handler = CheckProfanityHandler()
email_handler.set_next(illegal_char_handler).set_next(profanity_handler)

@pytest.mark.parametrize("handler, payload, is_username, expected", [
    (email_handler, "johndoe@usc.edu.ph", False, True),
    (illegal_char_handler, "john_doe123", True, True),
    (email_handler, "student@gmail.com", False, "Invalid email format."),
    (email_handler, "just_a_string", False, "Invalid email format."),
    (email_handler, "john!doe@usc.edu.ph", False, "Email/Password cannot contain illegal characters."),
    (illegal_char_handler, "john-doe(admin)", True, "Username cannot contain illegal characters."),
    (illegal_char_handler, "P@ssword!", False, "Email/Password cannot contain illegal characters."),
    (email_handler, "fuck@usc.edu.ph", False, "Email/username cannot contain profanity"),
    (email_handler, "FUCK@usc.edu.ph", False, "Email/username cannot contain profanity"),
    (profanity_handler, "clean_username", False, True),
])
def test_credentials_chain(handler, payload, is_username, expected):
    illegal_char_handler.is_username = is_username
    
    assert handler.handle(payload) == expected
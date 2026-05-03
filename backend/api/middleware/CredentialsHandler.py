
# ============================================================================
#  FILE        : CredentialsHandler.py
#  AUTHOR      : Samuel T. Yee II
#  DESCRIPTION : Different handlers to validate credentials.
#  COPYRIGHT   : April 24, 2026
#  REVISION HISTORY
#  Date:            By: 	            Description:
#  4/24/26          Samuel T. Yee II    Finished Writing
#  
# ============================================================================




from abc import ABC, abstractmethod
from typing import Optional
from better_profanity import profanity



profanity.load_censor_words()
word_list = [str(word) for word in profanity.CENSOR_WORDSET]


class CredentialsHandler(ABC):

    """
    This class declares the interface for building the chain of handlers regarding credentials.
    """

    def set_next(self, handler: CredentialsHandler) -> CredentialsHandler:
        pass

    def handle(self, email) -> Optional[str]:
        pass


class AbstractCredentialsHandler(CredentialsHandler):

    """
    This is where the default chaining behavior is implemented.
    """

    _next_handler: CredentialsHandler = None


    def set_next(self, handler: CredentialsHandler):
        self._next_handler = handler
        return handler
    
    def handle(self, request:str):

        if self._next_handler: # if next handler != null, handle the request, otherwise, return null
            return self._next_handler.handle(request)
        
        return True # returns valid if it passes all checks successfully
    

class CheckSchoolEmailHandler(AbstractCredentialsHandler):

    """
    Checks if email has @usc.edu.ph
    """
    def handle(self, request: str) -> str: 
        """
        Processes the credential, and checks if it contains the USC email format.

        Args:
            request (str): The email string to validate.

        Returns:
            str: An error message if validation fails, otherwise the result
                 from the next handler in the chain.
        """



        if '@usc.edu.ph' not in request: # checks if the email format is not in the request, otherwise, proceed to the other handlers.
            return "Invalid email format."
        else:
            return super().handle(request)
        

class CheckIllegalCharactersHandler(AbstractCredentialsHandler):
    """
    Handles illegal character validation for emails, usernames, and passwords.

    Attributes:
        illegal_chars (set): Characters forbidden in emails and passwords.
        illegal_chars_username (set): Characters forbidden in usernames.
        is_username (bool): Flag to determine if the handler is validating a username.
    """

    illegal_chars = {'!', '#', '$', '%', '^', '&', '*'}
    illegal_chars_username = {'!', '#', '$', '%', '^', '&', '*', '(', ')', '^', '.', '+', '-', '>', '<', ',', '/', '?', '\\'}

    is_username = False  # default

    def handle(self, request: str) -> str:
        """
        Validates the credential string based on the is_username flag.

        Args:
            request (str): The credential string to validate.

        Returns:
            str: An error message if validation fails, otherwise passes
                 to the next handler in the chain.
        """
        if self.is_username:
            if any(char in request for char in self.illegal_chars_username):
                return "Username cannot contain illegal characters."
        else:
            if any(char in request for char in self.illegal_chars):
                return "Email/Password cannot contain illegal characters."

        return super().handle(request)
    

class CheckProfanityHandler(AbstractCredentialsHandler):
    """
    Checks if email has profanity.
    """

    
    def handle(self, request:str) -> str:

        """
        Processes the credential string and checks for profanity.

        Args:
            request (str): The email or username stringgit  to validate.

        Returns:
            str: An error message if validation fails, otherwise the result
                 from the next handler in the chain.
        """
        if any(word in request.lower() for word in word_list):
            return "Email/username cannot contain profanity"
        else:
            return super().handle(request)







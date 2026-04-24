# ============================================================================
#  FILE        : UserApi.py
#  AUTHOR      : Samuel T. Yee II
#  DESCRIPTION : Basic API for user accounts.
#  COPYRIGHT   : April 24, 2026
#  REVISION HISTORY
#  Date:            By: 	            Description:
#  4/24/26          Samuel T. Yee II    Finished Writing
#  
# ============================================================================

from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
from api.middleware.CredentialsHandler import CheckProfanityHandler, CheckSchoolEmailHandler, CheckIllegalCharactersHandler
from firebase_admin import auth, firestore


class UserApi:

    @staticmethod
    @api_view(['POST'])
    def create_user(request):
        data = request.data
        
        result = UserApiMiddleware.validateCredentials(data= data)
        if result == True:
            db = firestore.client()

            try:
                user = auth.create_user(
                    email = data["email"],
                    password = data["password"]
                    )
                
                db.collection("users").document(user.uid).set({
                    "username": data["username"],
                    "email": data["email"],
                    "uid": user.uid,
                    "ces_points": 0,
                    "department": "Computer Engineering"
                    })
                user_doc = db.collection("users").document(user.uid).get()

                
            except Exception as e:
                return Response({
                    "status": False,
                    "message": e
                    },
                    status=status.HTTP_400_BAD_REQUEST)
            
            
            return Response({
                "status": True,
                "message": "Account created!",
                "users": user_doc.to_dict(),
                "uid": user.uid},
                status=status.HTTP_201_CREATED)
        
        else:
            return Response({
                "status": False,
                "error": result},
                status=status.HTTP_400_BAD_REQUEST)




class UserApiMiddleware:

    """
    Contains the functions for API middleware.
    """
    
    @staticmethod
    def validateCredentials(data) -> bool | str:

        """
        Function to validate user credentials.

        Args:
            data (json): json contains the user information for validation.

        Returns:
            str: An error message if validation fails.
            bool: When the credentials pass the requirements that is amalgamated by the developers.

        """


        checkIllegalChar = CheckIllegalCharactersHandler()
        checkSchoolEmail = CheckSchoolEmailHandler()
        checkProfanity = CheckProfanityHandler()
        checkIllegalChar.set_next(checkSchoolEmail).set_next(checkProfanity)

        checkIllegalCharUsername = CheckIllegalCharactersHandler()
        checkIllegalCharUsername.is_username = True  
        checkProfanityUsername = CheckProfanityHandler()
        checkIllegalCharUsername.set_next(checkProfanityUsername)  

        checkIllegalCharPassword = CheckIllegalCharactersHandler()

        fields = [
            (checkIllegalChar, data["email"]),
            (checkIllegalCharUsername, data["username"]),
            (checkIllegalCharPassword, data["password"]),
        ]

        for handler, value in fields:
            result = handler.handle(value)
            if result is not None and result is not True:
                return result
        
        return result

            


            
                

        
        

    
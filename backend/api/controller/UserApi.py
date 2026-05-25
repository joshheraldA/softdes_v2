# ============================================================================
#  FILE        : UserApi.py
#  AUTHOR      : Samuel T. Yee II
#  DESCRIPTION : Basic API for user accounts.
#  COPYRIGHT   : April 24, 2026
#  REVISION HISTORY
#  Date:            By:                 Description:
#  4/24/26          Samuel T. Yee II    Finished Writing
#
# ============================================================================

from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response
from api.middleware.CredentialsHandler import CheckProfanityHandler, CheckSchoolEmailHandler, CheckIllegalCharactersHandler
from firebase_admin import auth, firestore
import requests

import random
from django.core.cache import cache

from api.firebase import db

class UserApi:

    @staticmethod
    @api_view(['POST'])
    def create_user(request):
        data = request.data
        
        result = UserApiMiddleware.validateCredentials(data=data)
        if result == True:
            db = firestore.client()

            try:
                user = auth.create_user(
                    email=data["email"],
                    password=data["password"]
                )
                
                db.collection("users").document(user.uid).set({
                    "username": data["username"],
                    "email": data["email"],
                    "uid": user.uid,
                    "ces_points": 0,
                    "department": data.get("course", "Undeclared"),  # ← only change
                    "active_participating_ces_activities": [],
                    "role": "student"
                })
                user_doc = db.collection("users").document(user.uid).get()

            except Exception as e:
                return Response({
                    "status": False,
                    "message": str(e)
                }, status=status.HTTP_400_BAD_REQUEST)

            return Response({
                "status": True,
                "message": "Account created!",
                "users": user_doc.to_dict(),
                "uid": user.uid
            }, status=status.HTTP_201_CREATED)

        else:
            return Response({
                "status": False,
                "message": result
            }, status=status.HTTP_400_BAD_REQUEST)

    @staticmethod
    @api_view(['POST'])
    def login_user(request):
        import random
        data = request.data
        email = data.get('email')
        password = data.get('password')

        if not email or not password:
            return Response({"status": False, "error": "Email and password required"}, status=400)

        try:
            response = requests.post(
                f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBBVORwC933IYYmIOL7Sa56xISlhN4Pr90",
                json={"email": email, "password": password, "returnSecureToken": True}
            )
            result = response.json()

            if "error" in result:
                return Response({
                    "status": False,
                    "error": "Invalid Credentials",
                    "debug": result["error"]
                }, status=status.HTTP_401_UNAUTHORIZED)

            users_query = db.collection("users").where("email", "==", email).get()
            if not users_query:
                return Response({"status": False, "error": "User data not found"}, status=404)

            user_data = users_query[0].to_dict()

            otp_code = str(random.randint(100000, 999999))
            cache.set(f"otp_{email}", otp_code, timeout=300)
            print(f"\n[2FA DEBUG] The OTP for {email} is: {otp_code}\n")

            return Response({
                "status": True,
                "message": "Password verified. OTP generated!",
                "user": user_data,
                "uid": result['localId'],
                "otp": otp_code
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"status": False, "error": str(e)}, status=500)

    @staticmethod
    @api_view(['GET'])
    def get_user_data(request, uid):
        users = db.collection("users").where("uid", "==", uid).get()

        if not users:
            return Response({
                "status": False,
                "error": "User not found."
            }, status=status.HTTP_404_NOT_FOUND)

        return Response(users[0].to_dict(), status=status.HTTP_200_OK)

    @staticmethod
    @api_view(['GET'])
    def get_all_users(request):
        users = db.collection("users").get()

        if not users:
            return Response({
                "status": False,
                "error": "No users found."
            }, status=status.HTTP_404_NOT_FOUND)

        return Response({
            "status": True,
            "data": [user.to_dict() for user in users]
        }, status=status.HTTP_200_OK)


class UserApiMiddleware:
    """Contains the functions for API middleware."""

    @staticmethod
    def validateCredentials(data) -> bool | str:
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
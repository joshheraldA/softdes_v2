from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response

from api.middleware.CredentialsHandler import CheckProfanityHandler
from api.firebase import db
from google.cloud.firestore_v1 import ArrayUnion, ArrayRemove

from api.utils.idFactory import IdFactory

class CesApi:
    @staticmethod
    @api_view(['POST'])
    def post_ces(request):
        """
        Creates a CES activity

        Args:
            request: the necessary input information needed to create a ces activity

        Returns:
            Response: what the user will receive and the information that will be utilized 
        """
        data = request.data

        profanity_handler = CheckProfanityHandler()
        if profanity_handler.handle(data['title']) is True:
            # if there's no profanity

            uid = IdFactory.create_numeric_id(20)

            doc_ref = db.collection("CESArchive").document(str(uid))

            activity_data = {
                "title": data["title"],
                "status": data['status'],
                "date": {
                    "month": data["month"],
                    "day": data["day"],
                    "year": data["year"]
                },
                "volunteers": [],
                "facilitator": [data["uid"]],
                "beneficiaries": data["beneficiaries"],
                "documents": [],
                "private": data["private"],
                "department": data["department"],
                "uid": str(uid),
                "type": {
                    "isStrenuous": data['isStrenuous'],
                    "isOffCampus": data['isOffCampus']
                }
            }

            doc_ref.set(activity_data)

            return Response({
                "status": True,
                "message": "Successfully created the CES Activity",
                "activity": activity_data
            }, status=status.HTTP_201_CREATED)


        return Response({
            "status": False,
            "message": "There is profanity"
        }, status=status.HTTP_400_BAD_REQUEST)
    
    @staticmethod
    @api_view(['GET'])
    def get_ces(request): 
        activity_list = []

        activities = db.collection("CESArchive").get()

        for activity in activities:
            activity_data = activity.to_dict()
            activity_list.append(activity_data)
            

        return Response({
            'status': True,
            'activites': activity_list
        })


    @staticmethod
    @api_view(['GET'])
    def get_display_info(request):
        info_list = []

        doc_ref = db.collection('CESArchive')

        activity_list = doc_ref.get()


        for activity in activity_list:
            data = activity.to_dict()

            date_data = data['date']
            
            month = date_data.get('month', '')
            day = date_data.get('day', '')
            year = date_data.get('year', '')
            
            info_list.append({
                "title": data.get('title', 'no title'),
                "volunteers": len(data['volunteers']),
                "date": f"{month} {day}, {year}".strip()    
            })

        
        return Response({
            'status': True,
            'data': info_list
        }, status=status.HTTP_200_OK)
    

    @staticmethod
    @api_view(['POST'])
    def participate_ces_activity(request):

        
        data = request.data
        ces_ref = db.collection("CESArchive").document(data["ces_uid"])  
        ces_snapshot = ces_ref.get()  # using .get to check if it exists

        user_ref = db.collection("users")
        query = list(user_ref.where("uid", "==", data["uid"]).stream())

        if ces_snapshot.exists:  
            if query:
                user_doc_ref = query[0].reference
                user_doc_ref.update({
                    "active_participating_ces_activities": ArrayUnion([data["ces_uid"]])
                })

                ces_ref.update({  # updating using the reference document
                    "volunteers": ArrayUnion([data["uid"]])
                })

                return Response({
                    "status": True,
                    "message": "Successfully joined the CES activity"
                }, status=status.HTTP_200_OK)

            return Response({
                "status": False,
                "message": "User not found"
            }, status=status.HTTP_404_NOT_FOUND)

        return Response({
            "status": False,
            "message": "CES Activity not found"
        }, status=status.HTTP_404_NOT_FOUND)
        

        


        


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
        data = request.data

        profanity_handler = CheckProfanityHandler()
        if profanity_handler.handle(data['title']) is True:

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
                    "isOffCampus": data['isOffCampus'],
                    "type": data.get("type", "Default"),  # fixed — now stored
                },
                "approval_status" : "pending", # added pending status
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
            if activity_data.get('approval_status') == "approved":               
                activity_list.append(activity_data)


        return Response({
            'status': True,
            'data': activity_list
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
        ces_snapshot = ces_ref.get()

        user_ref = db.collection("users")
        query = list(user_ref.where("uid", "==", data["uid"]).stream())

        if ces_snapshot.exists:  
            if query:
                user_doc_ref = query[0].reference
                user_doc_ref.update({
                    "active_participating_ces_activities": ArrayUnion([data["ces_uid"]])
                })

                ces_ref.update({
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

    @staticmethod
    @api_view(['GET'])
    def find_activity(request):
        uid = request.GET.get("uid")

        ces_ref = db.collection("CESArchive").document(uid)
        ces_snapshot = ces_ref.get()

        if ces_snapshot.exists:
            ces_data = ces_snapshot.to_dict()

            return Response({
                'status': True,
                'data': ces_data
            }, status=status.HTTP_200_OK)
        
        else:
            return Response({
                'status': False,
                'message': "Could not find activity"
            }, status=status.HTTP_404_NOT_FOUND)

    @staticmethod
    @api_view(['POST'])
    def leave_ces_activity(request):
        data = request.data

        user_ref = db.collection("users")
        query = list(user_ref.where("uid", "==", data["uid"]).stream())
        ces_ref = db.collection("CESArchive").document(data["ces_uid"])
        ces_snapshot = ces_ref.get()

        if ces_snapshot.exists:
            if query:
                user_doc_ref = query[0].reference
                user_doc_ref.update({
                    "active_participating_ces_activities": ArrayRemove([data["ces_uid"]])
                })

                ces_ref.update({
                    "volunteers": ArrayRemove([data["uid"]])
                })

                return Response({
                    "status": True,
                    "message": "Successfully unjoined the CES activity"
                }, status=status.HTTP_200_OK)

            return Response({
                "status": False,
                "message": "User not found"
            }, status=status.HTTP_404_NOT_FOUND)

        return Response({
            "status": False,
            "message": "CES Activity not found"
        }, status=status.HTTP_404_NOT_FOUND)
    
    @staticmethod
    @api_view(['GET'])
    def get_calendar(request):
        MONTH_MAP = {
            'january': 1, 'february': 2, 'march': 3, 'april': 4,
            'may': 5, 'june': 6, 'july': 7, 'august': 8,
            'september': 9, 'october': 10, 'november': 11, 'december': 12,
        }

        # activity_ids: comma-separated Firestore doc IDs from the user's
        # activeParticipatingCesActivities list. Replaces the volunteer_uid scan.
        activity_ids_param = request.GET.get('activity_ids', '')
        activity_ids = (
            set(activity_ids_param.split(','))
            if activity_ids_param.strip()
            else None
        )

        activities = db.collection("CESArchive").get()

        # Group activities by ISO date string, capped at 2 per day (business rule)
        grouped = {}

        for doc in activities:
            data = doc.to_dict()

            # Filter by the user's own activity list when provided
            if activity_ids is not None and doc.id not in activity_ids:
                continue

            # Parse the stored month/day/year strings into an ISO date key
            date_data  = data.get('date', {})
            month_str  = date_data.get('month', '').strip().lower()
            day_str    = date_data.get('day', '').strip()
            year_str   = date_data.get('year', '').strip()

            month_num = MONTH_MAP.get(month_str)
            try:
                day_num  = int(day_str)
                year_num = int(year_str)
            except (ValueError, TypeError):
                continue  # skip activities with unparseable dates

            if month_num is None:
                continue

            date_key = f"{year_num:04d}-{month_num:02d}-{day_num:02d}"

            if date_key not in grouped:
                grouped[date_key] = []

            if len(grouped[date_key]) < 2:  # enforce max-2 business rule server-side
                grouped[date_key].append(data)

        # Shape each date bucket into a DayCellData-equivalent dict
        calendar = {}
        for date_key, acts in grouped.items():
            type_0 = (acts[0].get('type') or {}).get('type', 'Default') if len(acts) > 0 else None
            type_1 = (acts[1].get('type') or {}).get('type', 'Default') if len(acts) > 1 else None
            is_split = len(acts) == 2 and type_0 != type_1

            calendar[date_key] = {
                "date":           date_key,
                "primary_type":   type_0,
                "secondary_type": type_1 if is_split else None,
                "is_split":       is_split,
                "activities":     acts,
            }

        return Response({
            'status': True,
            'calendar': calendar,
        }, status=status.HTTP_200_OK)
    

    @staticmethod
    @api_view(['POST'])
    def edit_ces_points(request):
        data = request.data
        uid = data.get('uid')
        ces_points = data.get('ces_points')

        if not uid or ces_points is None:
            return Response({
                'status': False,
                'message': 'uid and ces_points are required'
            }, status=status.HTTP_400_BAD_REQUEST)

        user_ref = db.collection("users")
        query = list(user_ref.where("uid", "==", uid).stream())

        if not query:
            return Response({
                'status': False,
                'message': 'User not found'
            }, status=status.HTTP_404_NOT_FOUND)

        query[0].reference.update({
            'ces_points': int(ces_points)
        })

        return Response({
            'status': True,
            'message': 'CES points updated successfully'
        }, status=status.HTTP_200_OK)
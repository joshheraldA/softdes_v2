from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework.response import Response

from api.firebase import db
class CesApiApproval:


    @staticmethod
    @api_view(['GET'])
    def get_ces_status_filter(request): 
        activity_list = []
        
        status = request.query_params.get('status')

        if status:
            activities = db.collection("CESArchive").where("approval_status", "==", status).get()
        else:
            activities = db.collection("CESArchive").get()

        for activity in activities:
            activity_list.append(activity.to_dict())

        return Response({
            'status': True,
            'data': activity_list
        })
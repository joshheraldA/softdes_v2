from rest_framework.decorators import api_view
from rest_framework import status as http_status
from rest_framework.response import Response
from api.firebase import db
class CesApiApproval:


    @staticmethod
    @api_view(['GET'])
    def get_ces_status_filter(request): 
        activity_list = []
        
        status = request.query_params.get('status')

        if status:
            activities = db.collection("CESArchive").where("approval_status", "==", status).get() # this can be pending, approved, denied
        else:
            activities = db.collection("CESArchive").get()

        for activity in activities:
            activity_list.append(activity.to_dict())

        return Response({
            'status': True,
            'data': activity_list
    })

    @staticmethod
    @api_view(['POST'])
    def approve_activity(request):
        uid = request.data.get('uid')

        if not uid:
            return Response(
                {'status': False, 'message': 'uid is required'},
                status=http_status.HTTP_400_BAD_REQUEST
            )

        db.collection("CESArchive").document(uid).update({
            'approval_status': 'approved'
        })

        return Response({
            'status': True,
            'message': 'Activity approved successfully'
        })
    

    @staticmethod
    @api_view(['POST'])
    def deny_activity(request):
        uid = request.data.get('uid')

        if not uid:
            return Response(
                {'status': False, 'message': 'uid is required'},
                status=http_status.HTTP_400_BAD_REQUEST
            )

        db.collection("CESArchive").document(uid).update({
            'approval_status': 'denied'
        })

        return Response({
            'status': True,
            'message': 'Activity denied successfully'
        })
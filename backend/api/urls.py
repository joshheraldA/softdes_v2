from django.urls import path

# from .views import add_user_view
from api.controller.UserApi import UserApi  
from api.controller.CesApi import CesApi
from api.controller.CesApiApproval import CesApiApproval
from api import views

urlpatterns = [
    # path("add-user/", add_user_view, name="adduser"),
    path("create-user/", UserApi.create_user, name="createuser"),
    path("login-user/", UserApi.login_user, name="loginuser"),
    path("get-user-data/<str:uid>/", UserApi.get_user_data, name="getuserdata"),
    path('verify-2fa/', views.verify_2fa, name='verify_2fa'),
    path("get-all-users/", UserApi.get_all_users, name="getallusers"),

    path("post-ces/", CesApi.post_ces, name='postces'),
    path("get-ces/", CesApi.get_ces, name="getces"),
    path("get-display/", CesApi.get_display_info, name="getinfo"),
    path("add-participant/", CesApi.participate_ces_activity, name="participatecesactivity"),
    path("find-activity/", CesApi.find_activity, name='findactivity'),
    path("leave-activity/", CesApi.leave_ces_activity, name='leaveactivity'),
    path("edit-ces-points/", CesApi.edit_ces_points, name="editcespoints"),
    path("get-calendar/", CesApi.get_calendar, name="getcalendar"),
 
    
    path("get-ces-filter/", CesApiApproval.get_ces_status_filter, name="getcesstatusfilter"),
    path("approve-activity/", CesApiApproval.approve_activity, name="approveactivity"),
    path("deny-activity/", CesApiApproval.deny_activity, name="denyactivity"),

]
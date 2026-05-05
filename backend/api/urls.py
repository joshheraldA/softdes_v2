from django.urls import path

# from .views import add_user_view
from api.controller.UserApi import UserApi  
from api.controller.CesApi import CesApi

urlpatterns = [
    # path("add-user/", add_user_view, name="adduser"),
    path("create-user/", UserApi.create_user, name="createuser"),
    path("login-user/", UserApi.login_user, name="loginuser"),
    path("get-user-data/<str:uid>/", UserApi.get_user_data, name="getuserdata"),

    path("post-ces/", CesApi.post_ces, name='postces'),
    path("get-ces/", CesApi.get_ces, name="getces"),
    path("get-display/", CesApi.get_display_info, name="getinfo"),
    path("add-participant/", CesApi.participate_ces_activity, name="participatecesactivity")
]

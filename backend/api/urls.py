from django.urls import path

# from .views import add_user_view
from api.controller.UserApi import UserApi  


urlpatterns = [
    # path("add-user/", add_user_view, name="adduser"),
    path("create-user/", UserApi.create_user, name="createuser"),
    path("login-user/", UserApi.login_user, name="loginuser"),
    path("get-user-data/<str:uid>/", UserApi.get_user_data, name="getuserdata"),
]

from django.urls import path

from .views import add_user_view

urlpatterns = [
    path("add-user/", add_user_view, name="adduser")
]

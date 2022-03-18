from django.urls import path
from . import views

app_name = 'user'

#all of these paths start with '/user/' already
urlpatterns = [
    path('register/', views.CustomUserCreate.as_view(), name="register_user"),
    path('<str:pk>/', views.User.as_view(), name='user_detail'),
    path('admin/<str:pk>/', views.AdminEditUser.as_view(), name="user-update-by-admin")
]
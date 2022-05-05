from django.urls import path
from . import views

app_name = 'user'

#all of these paths start with '/user/' already
urlpatterns = [
    path('register/', views.CustomUserCreate.as_view(), name="register_user"),
    path('change-password/', views.ChangeUserPassword.as_view(), name="change-password"),
    path('verify-code/', views.VerifyOTPCode.as_view(), name="verify-code"),
    path('verify-user/', views.VerifyUser.as_view(), name='verify-user'),
    path('reset-password/', views.ResetUserPassword.as_view(), name='reset-password'),
    path('change-pin/', views.ChangeUserPIN.as_view(), name='change-pin'),
    path('<str:pk>/', views.User.as_view(), name='user_detail'),
    path('admin/<str:pk>/', views.AdminEditUser.as_view(), name="user-update-by-admin")
]
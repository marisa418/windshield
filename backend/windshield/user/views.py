from rest_framework import status, generics, permissions
from rest_framework.response import Response
from rest_framework.views import APIView
from . import serializers
from .models import NewUser, VerifyCodeLog
from .email import send_otp_to_email

class CustomUserCreate(APIView):
    permission_classes = [permissions.AllowAny]

    def __validated_password__(self, password):
        if len(password) < 8: return False
        if all(char.isdigit() for char in password): return False
        if not any(char.isdigit() for char in password): return False
        return True

    def post(self, request):
        if not self.__validated_password__(request.data["password"]):
            return Response({"message": "invalid password"}, status=status.HTTP_400_BAD_REQUEST)
        serializer = serializers.RegisterUserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            if user:
                json = serializer.data
                return Response(json, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class User(generics.RetrieveUpdateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = NewUser.objects.all()
    serializer_class = serializers.UserSerializer
    
class AdminEditUser(generics.RetrieveUpdateAPIView):
    permission_classes = [permissions.IsAdminUser]
    serializer_class = serializers.AdimEditUserSerializer
    queryset = NewUser.objects.all()

class VerifyRegisterOTP(generics.RetrieveAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = serializers.VerificationCodeSerializer
    queryset = VerifyCodeLog.objects.all()
    
    def get_object(self):
        verify_log = send_otp_to_email(self.request.user.email, "register")
        if verify_log:
            print(f'[{verify_log.timestamp.strftime("%d/%b/%Y %H:%M:%S")}] "send OTP to {verify_log.user.email} for verify {verify_log.activity}" {verify_log.code}')
        return verify_log
from datetime import datetime, timedelta
import pytz
import random
from rest_framework import status, generics, permissions
from rest_framework.response import Response
from rest_framework.views import APIView
from . import serializers
from .models import NewUser, VerifyCodeLog, VerifyTokenLog
from .email import send_otp_to_email

def validated_password(password):
    if len(password) < 8: return False
    if all(char.isdigit() for char in password): return False
    if not any(char.isdigit() for char in password): return False
    return True

class CustomUserCreate(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        if not validated_password(request.data["password"]):
            return Response("invalid password", status=status.HTTP_400_BAD_REQUEST)
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

class VerifyOTPCode(APIView):
    permission_classes = [permissions.AllowAny]
    
    def _generate_token(self):
        seeds = "1234567890abcdefghijklmnopqrstuvwxyz"
        token = "".join([ random.choice(seeds) for _ in range(32) ])
        return token
    
    def get(self, request):
        if request.user.is_anonymous:
            email = request.query_params.get("email", None)
            if email is None:
                return Response('email is required', status=status.HTTP_400_BAD_REQUEST)
        else:
            email = request.user.email
        verify_log = send_otp_to_email(email)
        if verify_log:
            print(f'[{verify_log.send_at.strftime("%d/%b/%Y %H:%M:%S")}] "send OTP to {verify_log.user.email}" {verify_log.ref_code}')
            res = serializers.VerificationCodeSerializer(verify_log, many=False).data
            return Response(res)
        return Response("not found an email or user", status=status.HTTP_404_NOT_FOUND)
    
    def post(self, request):
        if request.user.is_anonymous:
            email = request.data.get("email", None)
            if email is None:
                return Response('email is required', status=status.HTTP_400_BAD_REQUEST)
        else:
            email = request.user.email
        otp = request.data.get('otp', None)
        ref = request.data.get('ref', None)
        if otp is None: return Response("required otp", status=status.HTTP_400_BAD_REQUEST)
        if ref is None: return Response("required ref", status=status.HTTP_400_BAD_REQUEST)
        verify_log = VerifyCodeLog.objects.filter(user__email=email, ref_code=ref).last()
        expired_time = verify_log.send_at + timedelta(minutes=5)
        now = datetime.now()
        if verify_log is None:
            return Response(None, status=status.HTTP_404_NOT_FOUND)
        
        if now > expired_time or verify_log.count > 5:
            return Response({
                "massage": "verify code is expired",
                "expired_at": expired_time,
                "submit_count": verify_log.count
            },status=status.HTTP_400_BAD_REQUEST)
        if verify_log.is_used:
            return Response("this OTP is already used", status=status.HTTP_400_BAD_REQUEST)
        
        verify_log.count = verify_log.count + 1
        if otp != verify_log.code:
            verify_log.save()
            return Response("invalid verify code", status=status.HTTP_400_BAD_REQUEST)
        token = self._generate_token()
        VerifyTokenLog.objects.create(token=token, code_log=verify_log)
        verify_log.is_used = True
        verify_log.save()
        return Response({
            "massage": "verification success",
            "otp": otp,
            "ref": ref,
            "verify": token
        })
        
class ChangeUserPassword(APIView):
    permission_classes = [permissions.IsAuthenticated]
    
    def post(self, request):
        old_password = request.data.get("old_password")
        new_password = request.data.get("new_password")
        if new_password is None or old_password is None:
            return Response("password can't be none", status=status.HTTP_400_BAD_REQUEST)
        if old_password == new_password:
            return Response("new password must be different to old password", status=status.HTTP_400_BAD_REQUEST)
        user = NewUser.objects.get(uuid=request.user.uuid)
        if not user.check_password(old_password):
            return Response("old password is not match", status=status.HTTP_400_BAD_REQUEST)
        if not validated_password(new_password):
            return Response("invalid password", status=status.HTTP_400_BAD_REQUEST)
        user.set_password(new_password)
        user.save()
        return Response("password has changed successly")


def check_verify_token(request):
    verify_token = request.headers.get('X-VERIFY-TOKEN', None)
    ref_code = request.headers.get('X-REF-CODE', None)
    if verify_token is None or ref_code is None: 
        return "header doesn't include verify token or reference code", status.HTTP_400_BAD_REQUEST, None
    token_log = VerifyTokenLog.objects.filter(code_log__ref_code=ref_code).last()
    if token_log is None:
        return f"not found an reference code: {ref_code}", status.HTTP_404_NOT_FOUND, None
    expired_time = token_log.create_at + timedelta(minutes=10)
    now = datetime.now()
    if now > expired_time or token_log.count > 5:
        return {
            "massage": "verify token is expired",
            "expired_at": expired_time,
            "submit_count": token_log.count
        }, status.HTTP_400_BAD_REQUEST, None
    if token_log.is_used:
        return "this token is already used", status.HTTP_400_BAD_REQUEST, None
    
    token_log.count = token_log.count + 1
    if token_log.token != verify_token:
        token_log.save()
        return f"invalid verify token: {verify_token}", status.HTTP_400_BAD_REQUEST, None
    token_log.is_used = True
    token_log.save()
    return "verify successly", status.HTTP_200_OK, token_log

class VerifyUser(APIView):
    permission_classes = [permissions.IsAuthenticated]
    
    def post(self, request):
        massage, http_status, _ = check_verify_token(request)
        if http_status != status.HTTP_200_OK:
            return Response(massage, status=http_status)
        user = NewUser.objects.get(uuid=request.user.uuid)
        user.is_verify = True
        user.save()
        return Response("user has been verified successly")

class ResetUserPassword(APIView):
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        massage, http_status, token = check_verify_token(request)
        if http_status != status.HTTP_200_OK:
            return Response(massage, status=http_status)
        new_password = request.data.get("new_password", None)
        if new_password is None:
            return Response("password can't be none", status=status.HTTP_400_BAD_REQUEST)
        if not validated_password(new_password):
            return Response("invalid password", status=status.HTTP_400_BAD_REQUEST)
        user = NewUser.objects.get(uuid=token.code_log.user.uuid)
        user.set_password(new_password)
        user.save()
        return Response("password has reset successly")

class ChangeUserPIN(APIView):
    permission_classes = [permissions.IsAuthenticated]
    
    def post(self, request):
        massage, http_status, _ = check_verify_token(request)
        if http_status != status.HTTP_200_OK:
            return Response(massage, status=http_status)
        new_pin = request.data.get("pin", "")
        if len(new_pin) != 6:
            return Response("invalid PIN", status=status.HTTP_400_BAD_REQUEST)
        user = NewUser.objects.get(uuid=request.user.uuid)
        user.pin = new_pin
        user.save()
        return Response({
            "message": "PIN has changed successly",
            "pin": new_pin
            })
        
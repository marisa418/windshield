import pytz
from rest_framework import serializers
from user.models import *


class ProvinceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Province
        fields = ('id', 'name_in_thai')

class RegisterUserSerializer(serializers.ModelSerializer):
    user_id = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)
    password = serializers.CharField(required=True, write_only=True)
    
    class Meta:
        model = NewUser
        fields = ('user_id', 'email', 'password')
        extra_kwargs = {'password' : {'write_only': True}}

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        instance = self.Meta.model(**validated_data)
        if password is not None:
            instance.set_password(password)
        instance.save()
        return instance


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = NewUser
        exclude = ['password']
        read_only = ["user_id", "uuid", "points"]

class AdimEditUserSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = NewUser
        exclude = ['password']
        read_only = ["uuid", "user_id", "email", "pin"]
        
class VerificationCodeSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    timestamp = serializers.DateTimeField(default_timezone=pytz.timezone('Asia/Bangkok'))
    
    class Meta:
        model = VerifyCodeLog
        exclude = ['code']


from rest_framework import serializers
from user.models import NewUser
from user.models import Province
from api.models import Category, FinancialType

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
    # user_id = serializers.CharField()
    # email = serializers.EmailField()
    # pin = serializers.CharField()
    # tel = serializers.CharField()
    # occu_type = serializers.CharField()
    # status = serializers.CharField() 
    # age = serializers.IntegerField()
    # province = serializers.IntegerField()
    # family = serializers.IntegerField()
    # points = serializers.IntegerField()

    class Meta:
        model = NewUser
        exclude = ('password',)

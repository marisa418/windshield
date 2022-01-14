
from rest_framework import serializers
from user.models import NewUser
from api.models import Province

class ProvinceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Province
        fields = ('id', 'name_in_thai')

class RegisterUserSerializer(serializers.ModelSerializer):
    user_id = serializers.CharField(required=True)
    name = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)
    pin = serializers.CharField(required=True)
    tel = serializers.CharField(required=True)
    occu_type = serializers.CharField(required=True)
    age = serializers.IntegerField(required=True)
    family = serializers.IntegerField(required=True)
    points = serializers.IntegerField(required=True)
    password = serializers.CharField(required=True, write_only=True)
    # province = ProvinceSerializer(required=True)

    class Meta:
        model = NewUser
        fields = ('user_id', 'name', 'email', 'pin', 'tel', 'occu_type', 'age', 'family', 'points', 'password')
        extra_kwargs = {'password' : {'write_only': True}}

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        instance = self.Meta.model(**validated_data)
        if password is not None:
            instance.set_password(password)
        instance.save()
        return instance

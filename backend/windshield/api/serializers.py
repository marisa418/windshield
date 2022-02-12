from pyexpat import model
from rest_framework import serializers
from . import models

class StatementSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.FinancialStatementPlan
        fields = '__all__'

class CategorySerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Category
        exclude = ["user_id"]
        read_only_fields = ["id"]
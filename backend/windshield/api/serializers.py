from pyexpat import model
from rest_framework import serializers
from . import models

class StatementSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.FinancialStatementPlan
        exclude = ["owner_id"]
        read_only_fields = ['id']

class CategorySerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Category
        exclude = ["user_id"]
        read_only_fields = ["id"]
        
class BalanceSheetSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.BalanceSheet
        fields = '__all__'
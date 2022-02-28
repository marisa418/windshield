from dataclasses import fields
from pyexpat import model
from rest_framework import serializers
from . import models

class DailyFlowSheetSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.DailyFlowSheet
        exclude = ["owner_id"]
        read_only_fields = ['id']

class MethodSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Method
        exclude = ["user_id"]

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

class BudgetSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Budget
        fields = "__all__"
        read_only_fields = ["id"]
        # fields = ('id', 'fplan', 'balance', 'total_budget', 'budget_per_period', 'frequency')
from dataclasses import fields
from pyexpat import model
from unicodedata import category
from rest_framework import serializers
from . import models

class DailyFlowSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.DailyFlow
        fields = '__all__'
        read_only_fields = ['id']

class DailyFlowSheetSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.DailyFlowSheet
        exclude = ["owner_id"]
        read_only_fields = ['id']

class MethodSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Method
        exclude = ["user_id"]

class CategorySerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Category
        exclude = ["user_id"]
        read_only_fields = ["id"]
        
class BalanceSheetSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.BalanceSheet
        fields = '__all__'

class BudgetCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Budget
        read_only_fields = ["id", "total_budget"]
        fields = "__all__"

class BudgetSerializer(serializers.ModelSerializer):
    cat_id = CategorySerializer(read_only=True)

    class Meta:
        model = models.Budget
        fields = "__all__"
        
class StatementSerializer(serializers.ModelSerializer):
    budgets = BudgetSerializer(many=True, read_only=True)
    
    class Meta:
        model = models.FinancialStatementPlan
        exclude = ["owner_id"]
        read_only_fields = ['id', 'chosen', 'budgets']
        
class StatementUpdateSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.FinancialStatementPlan
        exclude = ['owner_id']
        read_only_fields = ['id', 'start', 'end', 'month']
from rest_framework import serializers
from . import models

class MethodSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Method
        exclude = ["user_id"]

class DailyFlowSerializer(serializers.ModelSerializer):
    method = MethodSerializer
    
    class Meta:
        model = models.DailyFlow
        fields = '__all__'
        read_only_fields = ['id']

class DailyFlowSheetCreateSerializer(serializers.ModelSerializer):
    date = serializers.DateTimeField(format="%Y-%m-%d")
    
    class Meta:
        model = models.DailyFlowSheet
        exclude = ["owner_id"]
        read_only_fields = ['id']

class DailyFlowSheetSerializer(serializers.ModelSerializer):
    flows = DailyFlowSerializer(many=True, read_only=True)
    
    class Meta:
        model = models.DailyFlowSheet
        exclude = ["owner_id"]
        read_only_fields = ['id']

class CategorySerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Category
        exclude = ["user_id"]
        read_only_fields = ["id"]
        
class AssetSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Asset
        fields = '__all__'
        read_only_fields = ['id']
        
class DebtSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Debt
        fields = '__all__'
        read_only_fields = ['id', 'imp_ranking']

class BalanceSheetSerializer(serializers.ModelSerializer):
    assets = AssetSerializer(many=True, read_only=True)
    debts = DebtSerializer(many=True, read_only=True)
    
    class Meta:
        model = models.BalanceSheet
        fields = ['id', 'owner_id', 'assets', 'debts']

class BudgetSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Budget
        read_only_fields = ["id", "total_budget"]
        fields = "__all__"

class BudgetUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Budget
        read_only_fields = ["id", "total_budget", "cat_id", "fplan"]
        fields = "__all__"

class BudgetCategorySerializer(serializers.ModelSerializer):
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
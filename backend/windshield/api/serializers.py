from rest_framework import serializers
from . import models

class BalanceSheetLogSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.BalanceSheetLog
        fields = "__all__"

class DefaultCategoriesSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.DefaultCategory
        fields = "__all__"

class MethodSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Method
        exclude = ["user_id"]

class DailyFlowCreateSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.DailyFlow
        fields = '__all__'
        read_only_fields = ['id']

class DailyFlowSerializer(serializers.ModelSerializer):
    method = MethodSerializer(read_only=True)
    
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
        read_only_fields = ["id", "used_count", "isDeleted"]
        
class FinancialTypeSerializer(serializers.ModelSerializer):
    categories = CategorySerializer(many=True, read_only=True)
    
    class Meta:
        model = models.FinancialType
        fields = '__all__'

class AssetSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Asset
        fields = '__all__'
        read_only_fields = ['id', 'bsheet_id']
        
class AssetsSerializer(serializers.ModelSerializer):
    cat_id = CategorySerializer(read_only=True)
    
    class Meta:
        model = models.Asset
        fields = '__all__'
        read_only_fields = ['id', 'bsheet_id', 'isDeleted']

class DebtSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.Debt
        fields = '__all__'
        read_only_fields = ['id', 'imp_ranking', 'bsheet_id']  

class DebtsSerializer(serializers.ModelSerializer):
    cat_id = CategorySerializer(read_only=True)
    
    class Meta:
        model = models.Debt
        fields = '__all__'
        read_only_fields = ['id', 'imp_ranking', 'bsheet_id']

class BalanceSheetSerializer(serializers.ModelSerializer):
    assets = AssetsSerializer(many=True, read_only=True)
    debts = DebtsSerializer(many=True, read_only=True)
    
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

class BudgetDeleteSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Budget
        fields = ['id']

class BudgetCategorySerializer(serializers.ModelSerializer):
    cat_id = CategorySerializer(read_only=True)

    class Meta:
        model = models.Budget
        fields = "__all__"
        
class StatementSerializer(serializers.ModelSerializer):
    budgets = BudgetCategorySerializer(many=True, read_only=True)
    
    class Meta:
        model = models.FinancialStatementPlan
        exclude = ["owner_id"]
        read_only_fields = ['id', 'chosen', 'budgets']
        
class StatementUpdateSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = models.FinancialStatementPlan
        exclude = ['owner_id']
        read_only_fields = ['id', 'start', 'end', 'month']
        
class CategoryWithBudgetAndFlowsSerializer(serializers.ModelSerializer):
    budgets = BudgetSerializer(many=True)
    flows = DailyFlowSerializer(many=True)
    
    class Meta:
        model = models.Category
        exclude = ["user_id"]
        read_only_fields = ["id", "budgets", "flows", "isDeleted"]
        
class FinancialGoalsSerializer(serializers.ModelSerializer):
    category_id = CategorySerializer(read_only=True)
    
    class Meta:
        model = models.FinancialGoal
        exclude = ["user_id"]
        read_only_fields = ["id", "reward", "total_progress"]
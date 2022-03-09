from datetime import datetime
from operator import mod
from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.db.models.deletion import CASCADE
from django.utils.timezone import now
from user.models import NewUser, Province
from django.core.exceptions import ValidationError
import math

class BalanceSheet(models.Model):
    id = models.CharField(max_length=13, primary_key=True)
    owner_id = models.ForeignKey(NewUser, on_delete = CASCADE)

    class Meta:
        db_table = 'balance_sheet'

    def __str__(self):
        return self.id + " " + str(self.owner_id)

class BalanceSheetLog(models.Model):
    id = models.AutoField(primary_key=True)
    bsheet_id = models.ForeignKey(BalanceSheet, on_delete=CASCADE)
    timestamp = models.DateTimeField(default=now)
    asset_value = models.DecimalField(max_digits=12, decimal_places=2)
    debt_balance = models.DecimalField(max_digits=12, decimal_places=2)

    class Meta:
        db_table = 'balance_sheet_log'

    def __str__(self):
        return str(self.timestamp) + " " + str(self.bsheet_id) + "(" +  str(self.id) + ")"

class FinancialType(models.Model):
    domain_choices = [
        ('INC', 'Income'),
        ('EXP', 'Expense'),
        ('ASS', 'Asset'),
        ('DEB', 'Debt'),
        ('GOL', 'Goal'),
        ('ACH', 'Achievement'),
    ]
    id = models.CharField(max_length=4, primary_key=True)
    name = models.CharField(max_length=30, unique=True)
    domain = models.CharField(max_length=3, choices=domain_choices)

    class Meta:
        db_table = 'financial_type'

    def __str__(self):
        return self.id + " " + self.name + "(" + self.domain + ")" 

class DefaultCategory(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=30)
    ftype = models.ForeignKey(FinancialType, on_delete=CASCADE)
    icon = models.CharField(max_length=30, default="shield-alt")
    
    class Meta:
        db_table = 'default_category'
        
    def __str__(self):
        return str(self.id) + " " + self.name

@receiver(post_save, sender=DefaultCategory, dispatch_uid="add_new_category_to_all_user")
def add_default_cat(sender, instance, created, *args, **kwargs):
    if created:
        users = NewUser.objects.all()
        for user in users:
            n_cats = Category.objects.filter(user_id=user.uuid).count()
            if n_cats != 0:
                Category.objects.create(name=instance.name, ftype=instance.ftype, user_id=user, icon=instance.icon)

class Category(models.Model):
    id = models.CharField(max_length=15, primary_key=True)
    name = models.CharField(max_length=30)
    # status = 
    ftype = models.ForeignKey(FinancialType, related_name='categories',on_delete=CASCADE)
    user_id = models.ForeignKey(NewUser, on_delete = CASCADE)
    used_count = models.PositiveIntegerField(default=0)
    icon = models.CharField(max_length=30, default="shield-alt")

    class Meta:
        db_table = 'category'

    def __str__(self):
        return self.id + " " + self.name
    
    def save(self, *args, **kwargs):
        if not self.id:
            last_id = Category.objects.filter(user_id=self.user_id.uuid).last()
            if last_id == None: no_id = 0
            else: no_id = int(last_id.id[-2:]) + 1
            self.id =  "CAT" + str(self.user_id.uuid)[:10] + str("0" + str(no_id))[-2:]
        return super(Category, self).save(*args, **kwargs)

class Asset(models.Model):
    benefit_type_choice = [
        ('ITR', 'Interest'),
        ('DIV', 'Dividend'),
        ('RTF', 'Rental Fee'),
        ('SEL', 'Sell')
    ]
    id = models.CharField(max_length=17, primary_key=True)
    cat_id = models.ForeignKey(Category, on_delete=CASCADE)
    bsheet_id = models.ForeignKey(BalanceSheet, related_name='assets', on_delete=CASCADE)
    source = models.CharField(max_length=30)
    recent_value = models.DecimalField(max_digits=12, decimal_places=2)
    benefit_type = models.CharField(max_length=3, choices=benefit_type_choice, null=True)
    benefit_value = models.DecimalField(decimal_places=2, max_digits=12, null=True)

    class Meta:
        db_table = 'asset'

    def __str__(self):
        return self.id + " " + self.source
    
    def __save_log__(self, new_value):
        logs = BalanceSheetLog.objects.filter(bsheet_id=self.bsheet_id).order_by('-timestamp')
        if len(logs) > 0:
            last_log = logs[0]
            debt_value = last_log.debt_balance
        else:
            debt_value = 0
        BalanceSheetLog.objects.create(
            bsheet_id = self.bsheet_id, 
            asset_value = new_value, 
            debt_balance = debt_value
        )
    
    def delete(self, *args, **kwargs):
        aggr = Asset.objects.filter(bsheet_id=self.bsheet_id).aggregate(sum_value=models.Sum('recent_value'))
        if aggr["sum_value"] is None:
            aggr["sum_value"] = 0
        new_value = aggr["sum_value"] - self.recent_value
        self.__save_log__(new_value)
        return super(Asset, self).delete(*args, kwargs)
    
    def save(self, *args, **kwargs):
        if not self.id:
            last_id = Asset.objects.filter(cat_id=self.cat_id.id).last()
            if last_id == None: no_id = 0
            else: no_id = int(last_id.id[-2:]) + 1
            self.id =  "ASS" + str(self.cat_id.id)[3:] + str("0" + str(no_id))[-2:]
            old_value = 0
        else:
            old_value = Asset.objects.get(id=self.id).recent_value
        aggr = Asset.objects.filter(bsheet_id=self.bsheet_id).aggregate(sum_value=models.Sum('recent_value'))
        if aggr["sum_value"] is None:
            aggr["sum_value"] = 0
        new_value = aggr["sum_value"] - old_value + self.recent_value
        self.__save_log__(new_value)
        return super(Asset, self).save(*args, **kwargs)

class Debt(models.Model):
    id = models.CharField(max_length=17, primary_key=True)
    cat_id = models.ForeignKey(Category, on_delete=CASCADE)
    bsheet_id = models.ForeignKey(BalanceSheet, related_name='debts', on_delete=CASCADE)
    balance = models.DecimalField(max_digits=12, decimal_places=2)
    creditor = models.CharField(max_length=30)
    interest = models.DecimalField(decimal_places=2, max_digits=5, null=True)
    debt_term = models.DateField(null=True)
    minimum = models.DecimalField(max_digits=12, decimal_places=2, null=True)
    suspend = models.PositiveIntegerField(null=True)
    imp_ranking = models.IntegerField(default=0)
    
    class Meta:
        db_table = 'debt'

    def __str__(self):
        return self.id + " " + self.creditor
    
    def __save_log__(self, new_value):
        logs = BalanceSheetLog.objects.filter(bsheet_id=self.bsheet_id).order_by('-timestamp')
        if len(logs) > 0:
            last_log = logs[0]
            asset_value = last_log.asset_value
        else:
            asset_value = 0
        BalanceSheetLog.objects.create(
            bsheet_id = self.bsheet_id, 
            asset_value = asset_value, 
            debt_balance = new_value
        )
    
    def delete(self, *args, **kwargs):
        aggr = Debt.objects.filter(bsheet_id=self.bsheet_id).aggregate(sum_value=models.Sum('balance'))
        if aggr["sum_value"] is None:
            aggr["sum_value"] = 0
        new_value = aggr["sum_value"] - self.balance
        self.__save_log__(new_value)
        return super(Debt, self).delete(*args, kwargs)
    
    def save(self, *args, **kwargs):
        if not self.id:
            last_id = Debt.objects.filter(cat_id=self.cat_id.id).last()
            if last_id == None: no_id = 0
            else: no_id = int(last_id.id[-2:]) + 1
            self.id =  "DEB" + str(self.cat_id.id)[3:] + str("0" + str(no_id))[-2:]
            old_value = 0
        else:
            old_value = Debt.objects.get(id=self.id).balance
        aggr = Debt.objects.filter(bsheet_id=self.bsheet_id).aggregate(sum_value=models.Sum('balance'))
        if aggr["sum_value"] is None:
            aggr["sum_value"] = 0
        new_value = aggr["sum_value"] - old_value + self.balance
        self.__save_log__(new_value)
        return super(Debt, self).save(*args, **kwargs)

class Month(models.Model):
    id = models.SmallIntegerField(primary_key=True)
    name = models.CharField(max_length=20)
    days = models.PositiveSmallIntegerField()

    class Meta:
        db_table = 'month'

    def __str__(self):
        return str(self.id) + " " + self.name

class FinancialStatementPlan(models.Model):
    id = models.CharField(max_length=23, primary_key=True)
    owner_id = models.ForeignKey(NewUser, on_delete = CASCADE)
    name = models.CharField(max_length=30)
    chosen = models.BooleanField()
    start = models.DateField()
    end = models.DateField()
    month = models.ForeignKey(Month, on_delete=CASCADE)

    class Meta:
        db_table = 'financial_statement_plan'

    def __str__(self):
        return self.id

class Budget(models.Model):
    freq_choices = [
        ('DLY', 'Daily'),
        ('WLY', 'Weekly'),
        ('MLY', 'Monthly'),
        ('ALY', 'Annually'),
    ]
    id = models.CharField(max_length=24, primary_key=True)
    cat_id = models.ForeignKey(Category, related_name="budgets",on_delete=CASCADE)
    fplan = models.ForeignKey(FinancialStatementPlan, related_name="budgets", on_delete=CASCADE)
    used_balance = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    total_budget = models.DecimalField(max_digits=12, decimal_places=2)
    budget_per_period = models.DecimalField(max_digits=12, decimal_places=2)
    frequency = models.CharField(max_length=3, choices=freq_choices, default=freq_choices[2][0])
    # due_date = models.DateTimeField(null=True)

    class Meta:
        db_table = 'budget'
    
    def save(self, *args, **kwargs):
        if self.frequency == 'DLY':
            fplan = FinancialStatementPlan.objects.get(id=self.fplan)
            delta = fplan.end - fplan.start
            expect_total = (delta.days + 1) * self.budget_per_period
            self.total_budget = expect_total
        elif self.frequency == 'WLY':
            fplan = FinancialStatementPlan.objects.get(id=self.fplan)
            delta = fplan.end - fplan.start
            expect_total = math.ceil((delta.days + 1)/7) * self.budget_per_period
            self.total_budget = expect_total
        else:
            self.total_budget = self.budget_per_period
        if not self.id:
            self.id = "BUD" + str(self.cat_id.id)[3:] + "-" + str(self.fplan.id)[-8:]
        return super(Budget, self).save(*args, **kwargs)
    
    def __str__(self):
        return str(self.id)

class DailyFlowSheet(models.Model):
    id = models.CharField(max_length=19, primary_key=True)
    owner_id = models.ForeignKey(NewUser, on_delete = CASCADE)
    date = models.DateField(default=now)

    class Meta:
        db_table = 'daily_flow_sheet'

    def __str__(self):
        return self.id
    
    def save(self, *args, **kwargs):
        if not self.id:
            if isinstance(self.date, str):
                self.date = datetime.strptime(self.date, "%Y-%m-%d")
            self.id = "DFS" + str(self.owner_id.uuid)[:10] + self.date.strftime("%y%m%d")
        return super(DailyFlowSheet, self).save(*args, **kwargs)

class Method(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=30)
    user_id = models.ForeignKey(NewUser, on_delete=CASCADE, null=True, blank=True)
    icon = models.CharField(max_length=20, default="money-bill")
    
    class Meta:
        db_table = "method"
    
    def __str__(self):
        return str(self.id) + " " + self.name + " (" + str(self.user_id) + ")"

class DailyFlow(models.Model):
    id = models.CharField(max_length=21, primary_key=True)
    df_id = models.ForeignKey(DailyFlowSheet, related_name='flows', on_delete=CASCADE)
    category = models.ForeignKey(Category, related_name='flows', on_delete=CASCADE)
    name = models.CharField(max_length=30)
    value = models.DecimalField(max_digits=12, decimal_places=2)
    method = models.ForeignKey(Method, on_delete=CASCADE)
    detail = models.TextField(null=True)
    # photo = models.FilePathField()

    class Meta:
        db_table = 'daily_flow'

    def __str__(self):
        return self.id + " " + self.name
    
    def __update_budget__(self, date, category, change):
        try:
            plan = FinancialStatementPlan.objects.get(chosen=True, start__lte=date, end__gte=date)
            budget = Budget.objects.get(fplan=plan.id, cat_id=category.id)
        except (FinancialStatementPlan.DoesNotExist, Budget.DoesNotExist):
            return False
        budget.used_balance += change
        budget.save()
        return True
    
    def delete(self):
        dfsheet = DailyFlowSheet.objects.get(id=self.df_id.id)
        if dfsheet is None:
            raise ValidationError("daily flow sheet is not exist")
        cat = Category.objects.get(id=self.category.id)
        if cat is None:
            raise ValidationError("category is not exist")
        change = -self.value
        cat.used_count -= 1
        cat.save()
        self.__update_budget__(dfsheet.date, cat, change)
        return super(DailyFlow, self).delete()
    
    def save(self, *args, **kwargs):
        dfsheet = DailyFlowSheet.objects.get(id=self.df_id.id)
        if dfsheet is None:
            raise ValidationError("daily flow sheet is not exist")
        cat = Category.objects.get(id=self.category.id)
        if cat is None:
            raise ValidationError("category is not exist")
        if not self.id:
            prefix = str(cat.id)[-2:] + "F" + str(self.df_id)[3:]
            last_id = DailyFlow.objects.filter(id__startswith=prefix).last()
            if last_id == None: no_id = 0
            else: no_id = int(last_id.id[-2:]) + 1
            self.id = prefix + str("00" + str(no_id))[-3:]
            change = self.value - 0
            cat.used_count += 1
            cat.save()
        else:
            flow = DailyFlow.objects.get(id=self.id)
            change = self.value - flow.value
        self.__update_budget__(dfsheet.date, cat, change)
        return super(DailyFlow, self).save(*args, **kwargs)

class FinancialGoal(models.Model):
    id = models.CharField(max_length=15, primary_key=True)
    name = models.CharField(max_length=30)
    detail = models.TextField(null=True)
    category_id = models.ForeignKey(Category, on_delete=CASCADE)
    term = models.PositiveIntegerField(null=True)
    goal = models.DecimalField(max_digits=12, decimal_places=2)
    total_progress = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    start = models.DateField()
    # strategy = 
    period_term = models.PositiveIntegerField(null=True)
    progress_per_period = models.DecimalField(max_digits=12, decimal_places=2, null=True)
    reward = models.PositiveIntegerField(null=True)

    class Meta:
        db_table = 'financial_goal'

    def __str__(self):
        return self.id

# class Admin(models.Model):
#     id = models.CharField(max_length=3, primary_key=True)
#     name = models.CharField(max_length=30)
#     email = models.EmailField()
#     password = models.CharField(max_length=21)
#     pin = models.IntegerField()
#     tel = models.CharField(max_length=10)

#     class Meta:
#         db_table = 'admin'

#     def __str__(self):
#         return self.id

class Achievement(models.Model):
    id = models.CharField(max_length=5, primary_key=True)
    name = models.CharField(max_length=30)
    detail = models.TextField()
    reward = models.PositiveIntegerField(null=True)
    recomm_count = models.PositiveIntegerField(default=0)
    achieve_count = models.PositiveIntegerField(default=0)
    complete_count = models.PositiveIntegerField(default=0)
    creator = models.ForeignKey(NewUser, on_delete=CASCADE)

    class Meta:
        db_table = 'achievement'

    def __str__(self):
        return self.id

class RecommendBoard(models.Model):
    status_choices = [
        ('UNA', 'Unachived'),
        ('ACH', 'Achived'),
        ('COM', 'Complete'),
    ]
    id = models.AutoField(primary_key=True)
    ach_id = models.ForeignKey(Achievement, on_delete=CASCADE)
    recomm_user = models.ForeignKey(NewUser, on_delete=CASCADE)
    status = models.CharField(max_length=3, choices=status_choices, default=status_choices[0][0])

    class Meta:
        db_table = 'recommend_board'

    def __str__(self):
        return self.id

class Suggestion(models.Model):
    id = models.CharField(max_length=5, primary_key=True)
    name = models.CharField(max_length=30)
    detail = models.TextField()
    # image = models.FilePathField()
    like = models.PositiveIntegerField()
    recomm_count = models.PositiveIntegerField()
    creator = models.ForeignKey(NewUser, on_delete=CASCADE)

    class Meta:
        db_table = 'suggestion'

    def __str__(self):
        return self.id

class SuggestionBoard(models.Model):
    id = models.AutoField(primary_key=True)
    sugg_id = models.ForeignKey(Suggestion, on_delete=CASCADE)
    sugg_user = models.ForeignKey(NewUser, on_delete=CASCADE)
    liked = models.BooleanField()

    class Meta:
        db_table = 'suggestion_board'

    def __str__(self):
        return self.id

class KnowledgeArticle(models.Model):
    id = models.CharField(max_length=5, primary_key=True)
    topic = models.CharField(max_length=30)
    # subject = ArrayField(models.CharField(), size=10)
    detail = models.TextField()
    # body = models.FilePathField()
    like = models.PositiveIntegerField()
    view = models.PositiveIntegerField()
    creator = models.ForeignKey(NewUser, on_delete=CASCADE)

    class Meta:
        db_table = 'knowledge_article'

    def __str__(self):
        return self.id
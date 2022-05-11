from api.models import *
from user.models import *
from django.contrib import admin
from django.urls import reverse
from django.utils.http import urlencode
from django.utils.html import format_html
from django.urls import re_path
from django.contrib import messages
from django.utils.translation import ngettext
from django.http import HttpResponseRedirect
from django.db.models import IntegerField
from django.db.models.functions import Cast

@admin.register(FinancialType)
class FinancialTypeAdmin(admin.ModelAdmin):
    list_display = ('show_id_uint', 'name', 'domain')
    list_filter = ('domain',)
    fieldsets = (
        (None, {'fields': ('name', 'domain')}),
    )
    
    def has_delete_permission(self, request, obj=None):
        return False
    
    def get_queryset(self, request):
        queryset = FinancialType.objects.all()
        queryset = queryset.annotate(id_uint=Cast('id', IntegerField())).order_by('id_uint')
        return queryset
    
    def show_id_uint(self, obj):
        return obj.id_uint
    
    show_id_uint.short_description = 'id'
    show_id_uint.admin_order_field = 'id_uint'

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_filter = ('isDeleted', 'ftype')
    list_display = ('id', 'name', 'ftype', 'lookup_user', 'used_count', 'change_is_deleted', 'action_box')
    search_fields = ('name', 'user_id__user_id')
    search_help_text = "Enter the category's name or user id"
    fieldsets = (
        (None, {'fields': ('name', 'ftype', 'user_id', 'icon', 'isDeleted')}),
    )
    actions = ('recover_selected',)
    
    def has_add_permission(self, request, obj=None):
        return False
    
    @admin.action(permissions=['change'], description='Recover seleted categories')
    def recover_selected(self, request, queryset):
        updated = queryset.update(isDeleted=False)
        self.message_user(request, ngettext(
            '%d category was successfully recoverd.',
            '%d categories were successfully recoverd',
            updated,
        ) % updated, messages.SUCCESS)
        
    def recover_process(self, request, category_id):
        try:
            category = self.get_object(request, object_id=category_id)
            category.isDeleted = False
            category.save()
            self.message_user(request, f'{category_id} category was successfully recovered.', messages.SUCCESS)
        except:
            self.message_user(request, f'{category_id} category was unsuccessful recovered.', messages.ERROR)
        return HttpResponseRedirect(request.META.get('HTTP_REFERER', '/'))
            
    def delete_process(self, request, category_id):
        try:
            category = self.get_object(request, object_id=category_id)
            category.isDeleted = True
            category.save()
            self.message_user(request, f'{category_id} category was successfully deactivated.', messages.SUCCESS)
        except:
            self.message_user(request, f'{category_id} category was unsuccessful deactivated.', messages.ERROR)
        return HttpResponseRedirect(request.META.get('HTTP_REFERER', '/'))
        
    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            re_path(
                r'^(?P<category_id>.+)/recover/$',
                self.admin_site.admin_view(self.recover_process),
                name='api_category_recover',
            ),
            re_path(
                r'^(?P<category_id>.+)/deactivate/$',
                self.admin_site.admin_view(self.delete_process),
                name='api_category_deactivate',
            ),
        ]
        return custom_urls + urls

    def lookup_user(self, obj):
        url = (
            reverse("admin:user_newuser_change", args=(obj.user_id.uuid,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.user_id)
    
    def action_box (self, obj):
        if obj.isDeleted:
            return format_html(
                '<a class="deletelink button" href="{}">obiterate</a>&nbsp;'
                '<a class="recoverlink button" href="{}">recover</a>',
                reverse("admin:api_category_delete", args=(obj.id,)),
                reverse("admin:api_category_recover", args=(obj.id,))
            )
        else:
            return format_html(
                '<a class="deletelink button" href="{}">delete</a>',
                reverse("admin:api_category_deactivate", args=(obj.id,))
            )
    
    action_box.short_description = 'Action'
    recover_selected.short_description = 'Recover seleted categories'
    lookup_user.short_description = 'user'
    
    def change_is_deleted(self, obj):
        yes_icon = '<img src="/static/admin/icon/circle-check-solid.svg" alt="True" >'
        no_icon = '<img src="/static/admin/icon/circle-xmark-solid.svg" alt="False" >'
        
        if obj.isDeleted:
            return format_html(yes_icon)
        else:
            return format_html(no_icon)
    
    change_is_deleted.short_description = "is deleted"

@admin.register(DefaultCategory) 
class DefaultCategoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'ftype', 'icon', 'delete_action')
    list_filter = ('ftype',)
    search_fields = ('name',)
    search_help_text = "Enter category's name"
    fieldsets = (
        (None, {'fields': ('name', 'ftype', 'icon')}),
    )
    ordering = ('id',)
    
    def delete_action(self, obj):
        url = (
            reverse("admin:api_defaultcategory_delete", args=(obj.id,))
        )
        return format_html('<a class="deletelink button" href="{}">delete</a>', url)
    
    delete_action.short_description = "delete"
  
@admin.register(Asset)
class AssetAdmin(admin.ModelAdmin):
    list_display = ('id', 'lookup_category', 'lookup_owner', 'source', 'recent_value', 'delete_action')
    search_fields = ('bsheet_id__owner_id__user_id', 'cat_id__name')
    search_help_text = "Enter the category's name or user id"
    fieldsets = (
        (None, {'fields': ('cat_id', 'bsheet_id', 'source', 'recent_value')}),
    )
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def delete_action(self, obj):
        url = (
            reverse("admin:api_asset_delete", args=(obj.id,))
        )
        return format_html('<a class="deletelink button" href="{}">delete</a>', url)
    
    delete_action.short_description = "delete"
    
    def get_form(self, request, obj=None, **kwargs):
        form = super().get_form(request, obj, **kwargs)
        unrequired_fields = ['source']
        for field in unrequired_fields:
            base_field = form.base_fields.get(field, None)
            if base_field is not None:
                base_field.required = False
        return form
    
    def lookup_owner(self, obj):
        url = (
            reverse("admin:api_balancesheet_change", args=(obj.bsheet_id.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.bsheet_id.owner_id)
    
    def lookup_category(self, obj):
        url = (
            reverse("admin:api_category_change", args=(obj.cat_id.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.cat_id.name)
    
    lookup_owner.short_description = 'owner'
    lookup_category.short_description = 'category'
    
@admin.register(Debt)
class DebtAdmin(admin.ModelAdmin):
    list_display = ('id', 'lookup_category', 'lookup_owner', 'creditor', 'balance', 'delete_action')
    search_fields = ('bsheet_id__owner_id__user_id', 'cat_id__name')
    search_help_text = "Enter the category's name or user id"
    fieldsets = (
        (None, {'fields': ('cat_id', 'bsheet_id', 'creditor', 'balance', 'interest', 'debt_term', 'minimum')}),
    )
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def delete_action(self, obj):
        url = (
            reverse("admin:api_debt_delete", args=(obj.id,))
        )
        return format_html('<a class="deletelink button" href="{}">delete</a>', url)
    
    delete_action.short_description = "delete"
    
    def get_form(self, request, obj=None, **kwargs):
        form = super().get_form(request, obj, **kwargs)
        unrequired_fields = ['interest', 'debt_term', 'minimum']
        for field in unrequired_fields:
            base_field = form.base_fields.get(field, None)
            if base_field is not None:
                base_field.required = False
        return form
    
    def lookup_owner(self, obj):
        url = (
            reverse("admin:api_balancesheet_change", args=(obj.bsheet_id.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.bsheet_id.owner_id)
    
    def lookup_category(self, obj):
        url = (
            reverse("admin:api_category_change", args=(obj.cat_id.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.cat_id.name)
    
    lookup_owner.short_description = 'owner'
    lookup_category.short_description = 'category'

@admin.register(BalanceSheetLog)
class BalanceSheetLogAdmin(admin.ModelAdmin):
    list_display = ('id', 'lookup_owner', 'asset_value', 'debt_balance', 'timestamp')
    search_fields = ('bsheet_id__owner_id__user_id',)
    search_help_text = "Enter the user id"
    list_filter = (('timestamp', admin.DateFieldListFilter),)
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False
    
    def has_delete_permission(self, request, obj=None):
        return False
    
    def lookup_owner(self, obj):
        url = (
            reverse("admin:api_balancesheet_change", args=(obj.bsheet_id.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.bsheet_id.owner_id)
    
    lookup_owner.short_description = 'owner'

@admin.register(BalanceSheet)
class BalanceSheetAdmin(admin.ModelAdmin):
    list_display = ('id', 'lookup_user', 'lookup_assets', 'lookup_debts', 'last_update')
    search_fields = ('owner_id__user_id',)
    search_help_text = "Enter the user id"
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False

    def lookup_user(self, obj):
        url = (
            reverse("admin:user_newuser_change", args=(obj.owner_id.uuid,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.owner_id)
    
    def lookup_assets(self, obj):
        count = Asset.objects.filter(bsheet_id__id=obj.id).count()
        url = (
            reverse("admin:api_asset_changelist")
            + "?"
            + urlencode({"bsheet_id__id": f"{obj.id}"})
        )
        return format_html('<a href="{}">{} Assets</a>', url, count)
    
    def lookup_debts(self, obj):
        count = Debt.objects.filter(bsheet_id__id=obj.id).count()
        url = (
            reverse("admin:api_debt_changelist")
            + "?"
            + urlencode({"bsheet_id__id": f"{obj.id}"})
        )
        return format_html('<a href="{}">{} Debts</a>', url, count)
    
    def last_update(self, obj):
        last_log = BalanceSheetLog.objects.filter(bsheet_id__id=obj.id).last()
        if last_log:
            url = (
                reverse("admin:api_balancesheetlog_changelist")
                + "?"
                + urlencode({"bsheet_id__id": f"{obj.id}"})
            )
            return format_html('<a href="{}">{}</a>', url, 
                               last_log.timestamp.strftime('%B %-d, %Y, %I:%M %p').replace("PM",'p.m.').replace("AM", 'a.m.')
                               )
    
    lookup_user.short_description = 'owner'
    lookup_assets.short_description = 'assets'
    lookup_debts.short_description = 'debts'

@admin.register(Budget)
class BudgetAdmin(admin.ModelAdmin):
    list_display = ('id', 'lookup_category', 'lookup_plan', 'start_plan', 'end_plan', 'total_budget', 'delete_action',)
    search_fields = ('cat_id__name', 'fplan__owner_id__user_id', 'fplan__id')
    search_help_text = "Enter category's name or user id or statement plan id"
    fieldsets = (
        (None, {'fields': ('cat_id', 'fplan', 'budget_per_period', 'frequency',)}),
    )
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def delete_action(self, obj):
        url = (
            reverse("admin:api_budget_delete", args=(obj.id,))
        )
        return format_html('<a class="deletelink button" href="{}">delete</a>', url)
    
    delete_action.short_description = "delete"
    
    def lookup_plan(self, obj):
        url = (
            reverse("admin:api_financialstatementplan_change", args=(obj.fplan.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.fplan.name)
    
    def start_plan(self, obj):
        return obj.fplan.start
    
    def end_plan(self, obj):
        return obj.fplan.end
    
    def lookup_category(self, obj):
        url = (
            reverse("admin:api_category_change", args=(obj.cat_id.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.cat_id.name)
    
    lookup_category.short_description = 'category'
    lookup_plan.short_description = 'statement plan'

@admin.register(FinancialStatementPlan)
class FinancialStatementPlanAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'lookup_user', 'start', 'end', 'change_is_active', 'lookup_budgets')
    search_fields = ('owner_id__user_id', 'name')
    search_help_text = "Enter the statement plan's name or user id"
    list_filter = ('chosen', ('start', admin.DateFieldListFilter), ('end', admin.DateFieldListFilter),)
    ordering = ('-start',)
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        if obj is None or obj.chosen:
            return False
        else:
            return True

    def lookup_user(self, obj):
        url = (
            reverse("admin:user_newuser_change", args=(obj.owner_id.uuid,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.owner_id)
    
    def lookup_budgets(self, obj):
        count = Budget.objects.filter(fplan__id=obj.id).count()
        url = (
            reverse("admin:api_budget_changelist")
            + "?"
            + urlencode({"fplan__id": f"{obj.id}"})
        )
        return format_html('<a href="{}">{} Budgets</a>', url, count)
    
    lookup_user.short_description = 'owner'
    lookup_budgets.short_description = 'budgets'
    
    def change_is_active(self, obj):
        yes_icon = '<img src="/static/admin/icon/circle-check-solid.svg" alt="True" >'
        no_icon = '<img src="/static/admin/icon/circle-xmark-solid.svg" alt="False" >'
        
        if obj.chosen:
            return format_html(yes_icon)
        else:
            return format_html(no_icon)
    
    change_is_active.short_description = "is active"
    
@admin.register(Method)
class MethodAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'icon', 'lookup_user')
    fieldsets = (
        (None, {'fields': ('name', 'icon', 'user_id')}),
    )
    
    def has_delete_permission(self, request, obj=None):
        return False
    
    def lookup_user(self, obj):
        if obj.user_id:
            url = (
                reverse("admin:user_newuser_change", args=(obj.user_id.uuid,))
            )
            return format_html('<a href="{}">{}</a>', url, obj.user_id)
        
    lookup_user.short_description = 'owner'
    
@admin.register(DailyFlow)
class DailyFlowAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'lookup_category', 'lookup_dfsheet', 'value', 'method', 'delete_action')
    search_fields = ('category__name', 'name', 'df_id__owner_id__user_id')
    search_help_text = "Enter the flow's name or category's name or user id"
    list_filter = (('df_id__date', admin.DateFieldListFilter), 'method')
    ordering = ('-df_id__date',)
    fieldsets = (
        (None, {'fields': ('name', 'value', 'method')}),
    )
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def delete_action(self, obj):
        url = (
            reverse("admin:api_dailyflow_delete", args=(obj.id,))
        )
        return format_html('<a class="deletelink button" href="{}">delete</a>', url)
    
    delete_action.short_description = "delete"
    
    def lookup_category(self, obj):
        url = (
            reverse("admin:api_category_change", args=(obj.category.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.category.name)
    
    lookup_category.short_description = 'category'
    
    def lookup_dfsheet(self, obj):
        url = (
            reverse("admin:api_dailyflowsheet_change", args=(obj.df_id.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.df_id.date.strftime('%B %-d, %Y'))
    
    lookup_dfsheet.short_description = 'date'
    lookup_dfsheet.admin_order_field = 'df_id__date'

@admin.register(DailyFlowSheet)
class DailyFlowSheetAdmin(admin.ModelAdmin):
    list_display = ('id', 'lookup_user', 'date', 'lookup_flows', 'delete_action')
    search_fields = ('owner_id__user_id',)
    search_help_text = "Enter the user id"
    list_filter = (('date', admin.DateFieldListFilter),)
    ordering = ('-date',)
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False
    
    def delete_action(self, obj):
        url = (
            reverse("admin:api_dailyflowsheet_delete", args=(obj.id,))
        )
        return format_html('<a class="deletelink button" href="{}">delete</a>', url)
    
    delete_action.short_description = "delete"
    
    def lookup_user(self, obj):
        url = (
            reverse("admin:user_newuser_change", args=(obj.owner_id.uuid,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.owner_id)
        
    lookup_user.short_description = 'owner'
    
    def lookup_flows(self, obj):
        count = DailyFlow.objects.filter(df_id__id=obj.id).count()
        url = (
            reverse("admin:api_dailyflow_changelist")
            + "?"
            + urlencode({"df_id__id": f"{obj.id}"})
        )
        return format_html('<a href="{}">{} Flows</a>', url, count)
    
    lookup_flows.short_description = 'flows'
    
@admin.register(FinancialGoal)
class FinancialGoalAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'lookup_category', 'lookup_user', 'progress', 'start', 'goal_date', 'delete_action')
    search_fields = ('user_id__user_id', 'category_id__name')
    search_help_text = "Enter the category's name or user id"
    ordering = ('-start',)
    fieldsets = (
        (None, {'fields': ('name', 'icon', 'goal', 'start', 'goal_date', 'progress_per_period', 'period_term', 'reward')}),
    )
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def delete_action(self, obj):
        url = (
            reverse("admin:api_financialgoal_delete", args=(obj.id,))
        )
        return format_html('<a class="deletelink button" href="{}">delete</a>', url)
    
    delete_action.short_description = "delete"
    
    def lookup_user(self, obj):
        url = (
            reverse("admin:user_newuser_change", args=(obj.user_id.uuid,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.user_id)
        
    lookup_user.short_description = 'owner'
    
    def progress(self, obj):
        return f'{obj.total_progress:.2f}/{obj.goal:.2f} ({obj.total_progress/obj.goal:.2f}%)'
    
    def lookup_category(self, obj):
        url = (
            reverse("admin:api_category_change", args=(obj.category_id.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.category_id.name)
    
    lookup_category.short_description = 'category'

@admin.register(Viewer)
class ViewerAdmin(admin.ModelAdmin):
    list_display = ('id', 'lookup_user', 'lookup_article', 'timestamp')
    search_fields = ('viewer__user_id', 'article__topic')
    search_help_text = "Enter the article's topic or user id"
    list_filter = (('timestamp', admin.DateFieldListFilter),)
    empty_value_display = "(unknow user)"
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False
    
    def has_delete_permission(self, request, obj=None):
        if obj is None or obj.viewer is not None:
            return False
        else:
            return True
    
    def lookup_user(self, obj):
        if obj.viewer is not None:
            url = (
                reverse("admin:user_newuser_change", args=(obj.viewer.uuid,))
            )
            return format_html('<a href="{}">{}</a>', url, obj.viewer)
        
    lookup_user.short_description = 'viewer'
    
    def lookup_article(self, obj):
        url = (
            reverse("admin:api_knowledgearticle_change", args=(obj.article.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.article.topic)
        
    lookup_user.short_description = 'viewer'
    lookup_article.short_description = 'article'

@admin.register(Liker)
class LikerAdmin(admin.ModelAdmin):
    list_display = ('id', 'lookup_user', 'lookup_article')
    search_fields = ('liker__user_id', 'article__topic')
    search_help_text = "Enter the article's topic or user id"
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False
    
    def has_delete_permission(self, request, obj=None):
        return False
    
    def lookup_user(self, obj):
        url = (
            reverse("admin:user_newuser_change", args=(obj.liker.uuid,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.liker)
        
    lookup_user.short_description = 'liker'
    
    def lookup_article(self, obj):
        url = (
            reverse("admin:api_knowledgearticle_change", args=(obj.article.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.article.topic)
    
    lookup_article.short_description = 'article'
    
@admin.register(ExclusiveArticleOwner)
class ExclusiveArticleOwnerAdmin(admin.ModelAdmin):
    list_display = ('id', 'lookup_user', 'lookup_article', 'delete_action')
    search_fields = ('liker__user_id', 'article__topic')
    search_help_text = "Enter the article's topic or user id"
    
    def delete_action(self, obj):
        url = (
            reverse("admin:api_exclusivearticleowner_delete", args=(obj.id,))
        )
        return format_html('<a class="deletelink button" href="{}">delete</a>', url)
    
    delete_action.short_description = 'delete'
    
    def lookup_user(self, obj):
        url = (
            reverse("admin:user_newuser_change", args=(obj.owner.uuid,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.owner)
        
    lookup_user.short_description = 'owner'
    
    def lookup_article(self, obj):
        url = (
            reverse("admin:api_knowledgearticle_change", args=(obj.article.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.article.topic)
    
    lookup_article.short_description = 'article'

@admin.register(KnowledgeArticle)
class KnowledgeAritcleAdmin(admin.ModelAdmin):
    list_display = ('id', 'topic', 'lookup_view', 'lookup_like', 'lookup_owner', 'subjects', 'exclusive_price', 'upload_on', 'delete_action')
    search_fields = ('topic', 'subject__name')
    search_help_text = "Enter article's topic or subject"
    list_filter = ('subject',)
    
    def subjects(self, obj):
        return ", ".join([p.name for p in obj.subject.all()])
    
    def delete_action(self, obj):
        url = (
            reverse("admin:api_knowledgearticle_delete", args=(obj.id,))
        )
        return format_html('<a class="deletelink button" href="{}">delete</a>', url)
    
    def lookup_view(self, obj):
        queryset = Viewer.objects.filter(article__id=obj.id)
        count = queryset.count()
        url = (
            reverse("admin:api_viewer_changelist")
            + "?"
            + urlencode({"article": f"{obj.id}"})
        )
        return format_html('<a href="{}">{} Views</a>', url, count)
    
    def lookup_like(self, obj):
        queryset = Liker.objects.filter(article__id=obj.id)
        count = queryset.count()
        url = (
            reverse("admin:api_liker_changelist")
            + "?"
            + urlencode({"article": f"{obj.id}"})
        )
        return format_html('<a href="{}">{} Likes</a>', url, count)
    
    def lookup_owner(self, obj):
        queryset = ExclusiveArticleOwner.objects.filter(article__id=obj.id)
        count = queryset.count()
        url = (
            reverse("admin:api_exclusivearticleowner_changelist")
            + "?"
            + urlencode({"article": f"{obj.id}"})
        )
        return format_html('<a href="{}">{} Owner</a>', url, count)
    
    def get_deleted_objects(self, objs, request):
        deleted_objects, model_count, perms_needed, protected = \
            super().get_deleted_objects(objs, request)
        return deleted_objects, model_count, set(), protected
    
    delete_action.short_description = 'delete'
    lookup_view.short_description = 'views'
    lookup_like.short_description = 'likes'
    lookup_owner.short_description = 'owned'
  
@admin.register(Subject)
class SubjectAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'articles')
    
    def has_delete_permission(self, request, obj=None):
        if obj is None:
            return False
        queryset = KnowledgeArticle.objects.filter(subject__id=obj.id).distinct()
        count = queryset.count()
        if count != 0:
            return False
        return True
    
    def articles(self, obj):
        queryset = KnowledgeArticle.objects.filter(subject__id=obj.id).distinct()
        count = queryset.count()
        url = (
            reverse("admin:api_knowledgearticle_changelist")
            + "?"
            + urlencode({"subject__id": f"{obj.id}"})
        )
        return format_html('<a href="{}">{} Articles</a>', url, count)
from django.contrib import admin
from user.models import *
from django.contrib.auth.models import Group
from django.contrib.auth.admin import UserAdmin
from django.forms import TextInput, Textarea, CharField
from django import forms
from django.db import models
from django.apps import apps
from django.urls import reverse
from django.utils.http import urlencode
from django.utils.html import format_html
from admin_numeric_filter.admin import NumericFilterModelAdmin, RangeNumericFilter

class UserAdminConfig(UserAdmin):
    model = NewUser
    search_fields = ('user_id', 'uuid', 'email',)
    list_filter = ('is_active', 'is_verify', 'is_staff',)
    ordering = ('user_id',)
    list_display = ('user_id', 'uuid', 'is_active', 'is_staff', 'is_verify', 'points', 'delete_action')
    fieldsets = (
        (None, {'fields': ('user_id', 'email',)}),
        ('Permissions', {'fields': ('is_staff', 'is_active', 'is_verify')}),
        ('Personal', {'fields': ('born_year', 'pin', 'tel', 'occu_type','status', 'province', 'family', 'points')}),
    )
    formfield_overrides = {
        models.TextField: {'widget': Textarea(attrs={'rows': 20, 'cols': 60})},
    }
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('user_id', 'password1', 'password2', 'email', 'pin', 'tel')}
         ),
    )
    
    def get_form(self, request, obj=None, **kwargs):
        form = super().get_form(request, obj, **kwargs)
        unrequired_fields = ['born_year', 'pin', 'tel', 'occu_type', 'status', 'province', 'family', 'points']
        for field in unrequired_fields:
            base_field = form.base_fields.get(field, None)
            if base_field is not None:
                base_field.required = False
        return form
    
    def delete_action(self, obj):
        url = (
            reverse("admin:user_newuser_delete", args=(obj.uuid,))
        )
        return format_html('<a class="deletelink" href="{}">delete</a>', url)
    
    delete_action.short_description = "Delete"

admin.site.register(NewUser, UserAdminConfig)

@admin.register(VerifyCodeLog)
class VerifyCodeLogAdmin(NumericFilterModelAdmin):
    list_display = ('id', 'ref_code', 'lookup_user', 'show_email', 'code', 'is_used', 'count','send_at')
    search_fields = ('ref_code' ,'user__email',)
    list_filter = ('is_used', ('send_at', admin.DateFieldListFilter), ('count', RangeNumericFilter))
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False
    
    def show_email(self, obj):
        return obj.user.email
    
    def lookup_user(self, obj):
        url = (
            reverse("admin:user_newuser_change", args=(obj.user.uuid,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.user)
    
    show_email.short_description = "Email"
    lookup_user.short_description = "User"

@admin.register(VerifyTokenLog)
class VerifyTokenLogAdmin(NumericFilterModelAdmin):
    list_display = ('id', 'lookup_code_log', 'show_email', 'token', 'create_at', 'is_used', 'count')
    search_fields = ('code_log__ref_code', 'code_log__user__email',)
    list_filter = ('is_used', ('create_at', admin.DateFieldListFilter), ('count', RangeNumericFilter))
    
    def has_add_permission(self, request, obj=None):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False
    
    def show_ref_code(self, obj):
        return obj.code_log.ref_code
    
    def show_email(self, obj):
        return obj.code_log.user.email
    
    def lookup_code_log(self, obj):
        url = (
            reverse("admin:user_verifycodelog_change", args=(obj.code_log.id,))
        )
        return format_html('<a href="{}">{}</a>', url, obj.code_log.ref_code)
    
    lookup_code_log.short_description = 'ref code'
    show_email.short_description = 'email'

@admin.register(Province)
class ProvinceAdmin(admin.ModelAdmin):
    list_display = ('code', 'name_in_thai', 'name_in_eng')
    search_fields = ('code', 'name_in_thai', 'name_in_eng')
    ordering = ('code',)

admin.site.unregister(Group)

# Model = apps.get_models()

# for model in Model:
#     try:
#         admin.site.register(model)
#     except admin.sites.AlreadyRegistered:
#         pass
from django.contrib import admin
from user.models import NewUser
from django.contrib.auth.admin import UserAdmin
from django.forms import TextInput, Textarea, CharField
from django import forms
from django.db import models
from django.apps import apps

class UserAdminConfig(UserAdmin):
    model = NewUser
    search_fields = ('user_id', 'name')
    list_filter = ('user_id', 'name', 'is_active', 'is_staff')
    ordering = ('user_id',)
    list_display = ('user_id', 'uuid', 'name', 'is_active', 'is_staff')
    fieldsets = (
        (None, {'fields': ('user_id',)}),
        ('Permissions', {'fields': ('is_staff', 'is_active')}),
        ('Personal', {'fields': ('name', 'email', 'pin', 'tel')}),
    )
    formfield_overrides = {
        models.TextField: {'widget': Textarea(attrs={'rows': 20, 'cols': 60})},
    }
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('user_id', 'password1', 'password2', 'name', 'email', 'pin', 'tel')}
         ),
    )

admin.site.register(NewUser, UserAdminConfig)

Model = apps.get_models()

for model in Model:
    try:
        admin.site.register(model)
    except admin.sites.AlreadyRegistered:
        pass
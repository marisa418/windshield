from django.db import models
from django.utils import timezone
from django.utils.translation import gettext_lazy as _
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager
from django.db.models.deletion import CASCADE
import uuid

class Province(models.Model):
    id = models.CharField(max_length=3, primary_key='true')
    code = models.IntegerField(default=0)
    name_in_thai = models.CharField(max_length=30)
    name_in_eng = models.CharField(max_length=30, null=True)

    class Meta:
        db_table = 'provinces'

    def __str__(self):
        return self.name_in_thai

class CustomAccountManager(BaseUserManager):

    def create_user(self, user_id, password, email, **other_fields):
        email = self.normalize_email(email)
        user = self.model(
            user_id=user_id, 
            email=email,
            **other_fields
        )
        user.set_password(password)
        user.save()
        return user

    def create_superuser(self, user_id, password, email, **other_fields):
        other_fields.setdefault('is_staff', True)
        other_fields.setdefault('is_superuser', True)
        other_fields.setdefault('is_active', True)
        other_fields.setdefault('is_verify', True)

        if other_fields.get('is_staff') is not True:
            raise ValueError('Superuser must be assigned to is_staff=True.')
        if other_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must be assigned to is_superser=True.')

        return self.create_user(user_id, password, email, **other_fields)

status_chocies = [
    ('SIN', 'Single'),
    ('PAR', 'Partner'),
    ('MAR', 'Married'),
    ('DIV', 'Divorced'),
]

occu_choices = [
    ('GOV', 'Government'),
    ('COM', 'Company'),
    ('DLY', 'Daily'),
    ('FRL', 'Freelance'),
    ('BUS', 'Business'),
    ('LES', 'Jobless')
]

class NewUser(AbstractBaseUser, PermissionsMixin):
    user_id = models.CharField(max_length=21, unique=True)
    email = models.EmailField(unique=True)
    pin = models.CharField(max_length=6, null=True)
    tel = models.CharField(max_length=10, null=True)
    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    is_verify = models.BooleanField(default=False)
    uuid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)

    # Might be choice field later
    occu_type = models.CharField(max_length=3, choices=occu_choices, null=True)
    status = models.CharField(max_length=3, choices=status_chocies, null=True) 
    #

    born_year = models.IntegerField(null=True)
    province = models.ForeignKey(Province, on_delete=CASCADE, null=True)
    family = models.PositiveSmallIntegerField(null=True)
    points = models.PositiveIntegerField(default=0)

    objects = CustomAccountManager()

    USERNAME_FIELD = 'user_id'
    REQUIRED_FIELDS = ['email']

    def __str__(self):
        return self.user_id

class VerifyCodeLog(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey(NewUser, on_delete=CASCADE)
    code = models.CharField(max_length=6, verbose_name='OTP')
    send_at = models.DateTimeField(auto_now_add=True)
    ref_code = models.CharField(max_length=8)
    is_used = models.BooleanField(default=False)
    count = models.IntegerField(default=0)
    
    class Meta:
        db_table = 'verify_code_log'
    
    def __str__(self):
        return f"[{self.ref_code}] {self.user.email}"

class VerifyTokenLog(models.Model):
    id = models.AutoField(primary_key=True)
    code_log = models.ForeignKey(VerifyCodeLog, on_delete=CASCADE)
    token = models.CharField(max_length=32)
    create_at = models.DateTimeField(auto_now_add=True, verbose_name='timestamp')
    is_used = models.BooleanField(default=False)
    count = models.SmallIntegerField(default=0)
    
    class Meta:
        db_table = 'verify_token_log'
    
    def __str__(self):
        return f"{self.id}: {self.token}"
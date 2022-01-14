# Generated by Django 4.0.1 on 2022-01-13 12:00

from django.db import migrations, models
import django.db.models.deletion
import uuid


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.CreateModel(
            name='Province',
            fields=[
                ('id', models.CharField(max_length=3, primary_key='true', serialize=False)),
                ('code', models.IntegerField(default=0)),
                ('name_in_thai', models.CharField(max_length=30)),
                ('name_in_eng', models.CharField(max_length=30, null=True)),
            ],
            options={
                'db_table': 'provinces',
            },
        ),
        migrations.CreateModel(
            name='NewUser',
            fields=[
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('is_superuser', models.BooleanField(default=False, help_text='Designates that this user has all permissions without explicitly assigning them.', verbose_name='superuser status')),
                ('user_id', models.CharField(max_length=21, unique=True)),
                ('name', models.CharField(max_length=30)),
                ('email', models.EmailField(max_length=254)),
                ('pin', models.CharField(max_length=6)),
                ('tel', models.CharField(max_length=10)),
                ('is_staff', models.BooleanField(default=False)),
                ('is_active', models.BooleanField(default=True)),
                ('uuid', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('occu_type', models.CharField(max_length=10)),
                ('age', models.PositiveSmallIntegerField()),
                ('family', models.PositiveSmallIntegerField()),
                ('points', models.PositiveIntegerField()),
                ('groups', models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.Group', verbose_name='groups')),
                ('province', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='user.province')),
                ('user_permissions', models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.Permission', verbose_name='user permissions')),
            ],
            options={
                'abstract': False,
            },
        ),
    ]

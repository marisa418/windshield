# Generated by Django 4.0.1 on 2022-05-10 15:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('user', '0016_remove_newuser_age_newuser_born_year'),
    ]

    operations = [
        migrations.AlterField(
            model_name='verifycodelog',
            name='code',
            field=models.CharField(max_length=6, verbose_name='OTP'),
        ),
        migrations.AlterField(
            model_name='verifytokenlog',
            name='create_at',
            field=models.DateTimeField(auto_now_add=True, verbose_name='timestamp'),
        ),
    ]
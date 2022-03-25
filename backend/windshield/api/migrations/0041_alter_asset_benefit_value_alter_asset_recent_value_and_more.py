# Generated by Django 4.0.1 on 2022-03-14 10:42

import api.models
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0040_alter_budget_budget_per_period_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='asset',
            name='benefit_value',
            field=models.DecimalField(decimal_places=2, max_digits=12, null=True, validators=[api.models.validate_ispositive]),
        ),
        migrations.AlterField(
            model_name='asset',
            name='recent_value',
            field=models.DecimalField(decimal_places=2, max_digits=12, validators=[api.models.validate_ispositive]),
        ),
        migrations.AlterField(
            model_name='balancesheetlog',
            name='asset_value',
            field=models.DecimalField(decimal_places=2, max_digits=12, validators=[api.models.validate_ispositive]),
        ),
        migrations.AlterField(
            model_name='dailyflow',
            name='value',
            field=models.DecimalField(decimal_places=2, max_digits=12, validators=[api.models.validate_ispositive]),
        ),
        migrations.AlterField(
            model_name='debt',
            name='balance',
            field=models.DecimalField(decimal_places=2, max_digits=12, validators=[api.models.validate_ispositive]),
        ),
        migrations.AlterField(
            model_name='financialgoal',
            name='goal',
            field=models.DecimalField(decimal_places=2, max_digits=12, validators=[api.models.validate_ispositive]),
        ),
    ]
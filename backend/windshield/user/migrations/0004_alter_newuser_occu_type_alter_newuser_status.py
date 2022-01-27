# Generated by Django 4.0.1 on 2022-01-25 08:40

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('user', '0003_remove_newuser_name_newuser_status_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='newuser',
            name='occu_type',
            field=models.CharField(choices=[('GOV', 'Government'), ('COM', 'Company'), ('DLY', 'Daily'), ('FRL', 'Freelance'), ('BUS', 'Business'), ('LES', 'Jobless')], max_length=3, null=True),
        ),
        migrations.AlterField(
            model_name='newuser',
            name='status',
            field=models.CharField(choices=[('SIN', 'Single'), ('PAR', 'Partner'), ('MAR', 'Married'), ('DIV', 'Divorced')], max_length=3, null=True),
        ),
    ]

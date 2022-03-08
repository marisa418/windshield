# Generated by Django 4.0.1 on 2022-03-07 16:51

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0032_remove_balancesheetlog_asset_value_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='category',
            name='ftype',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='categories', to='api.financialtype'),
        ),
        migrations.CreateModel(
            name='DefaultCategory',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=30)),
                ('icon', models.CharField(default='shield-alt', max_length=30)),
                ('ftype', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.financialtype')),
            ],
            options={
                'db_table': 'default_category',
            },
        ),
    ]

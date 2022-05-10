# Generated by Django 4.0.1 on 2022-05-10 15:51

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('api', '0057_knowledgearticle_upload_on'),
    ]

    operations = [
        migrations.AlterField(
            model_name='asset',
            name='bsheet_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='assets', to='api.balancesheet', verbose_name='balance sheet'),
        ),
        migrations.AlterField(
            model_name='asset',
            name='cat_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.category', verbose_name='category'),
        ),
        migrations.AlterField(
            model_name='balancesheet',
            name='owner_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL, verbose_name='owner'),
        ),
        migrations.AlterField(
            model_name='category',
            name='ftype',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='categories', to='api.financialtype', verbose_name='type'),
        ),
        migrations.AlterField(
            model_name='category',
            name='isDeleted',
            field=models.BooleanField(default=False, verbose_name='is deleted'),
        ),
        migrations.AlterField(
            model_name='category',
            name='user_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL, verbose_name='user'),
        ),
        migrations.AlterField(
            model_name='defaultcategory',
            name='ftype',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.financialtype', verbose_name='type'),
        ),
        migrations.AlterField(
            model_name='financialstatementplan',
            name='chosen',
            field=models.BooleanField(verbose_name='is active'),
        ),
        migrations.AlterField(
            model_name='financialstatementplan',
            name='end',
            field=models.DateField(verbose_name='end date'),
        ),
        migrations.AlterField(
            model_name='financialstatementplan',
            name='start',
            field=models.DateField(verbose_name='start date'),
        ),
        migrations.AlterField(
            model_name='knowledgearticle',
            name='exclusive_price',
            field=models.PositiveIntegerField(default=0, verbose_name='price'),
        ),
        migrations.AlterField(
            model_name='viewer',
            name='viewer',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL),
        ),
    ]

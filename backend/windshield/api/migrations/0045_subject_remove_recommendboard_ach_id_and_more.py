# Generated by Django 4.0.1 on 2022-04-13 14:10

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0044_remove_budget_used_balance'),
    ]

    operations = [
        migrations.CreateModel(
            name='Subject',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=20)),
            ],
            options={
                'db_table': 'subject',
            },
        ),
        migrations.RemoveField(
            model_name='recommendboard',
            name='ach_id',
        ),
        migrations.RemoveField(
            model_name='recommendboard',
            name='recomm_user',
        ),
        migrations.RemoveField(
            model_name='suggestion',
            name='creator',
        ),
        migrations.RemoveField(
            model_name='suggestionboard',
            name='sugg_id',
        ),
        migrations.RemoveField(
            model_name='suggestionboard',
            name='sugg_user',
        ),
        migrations.RenameField(
            model_name='knowledgearticle',
            old_name='detail',
            new_name='body',
        ),
        migrations.AddField(
            model_name='knowledgearticle',
            name='image',
            field=models.FilePathField(default=0),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='knowledgearticle',
            name='id',
            field=models.AutoField(primary_key=True, serialize=False),
        ),
        migrations.AlterField(
            model_name='knowledgearticle',
            name='like',
            field=models.PositiveIntegerField(default=0),
        ),
        migrations.AlterField(
            model_name='knowledgearticle',
            name='view',
            field=models.PositiveIntegerField(default=0),
        ),
        migrations.DeleteModel(
            name='Achievement',
        ),
        migrations.DeleteModel(
            name='RecommendBoard',
        ),
        migrations.DeleteModel(
            name='Suggestion',
        ),
        migrations.DeleteModel(
            name='SuggestionBoard',
        ),
        migrations.AddField(
            model_name='knowledgearticle',
            name='subject',
            field=models.ManyToManyField(to='api.Subject'),
        ),
    ]

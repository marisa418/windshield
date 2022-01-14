# Generated by Django 4.0.1 on 2022-01-13 12:00

from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Achievement',
            fields=[
                ('id', models.CharField(max_length=5, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=30)),
                ('detail', models.TextField()),
                ('reward', models.PositiveIntegerField(null=True)),
                ('recomm_count', models.PositiveIntegerField(default=0)),
                ('achieve_count', models.PositiveIntegerField(default=0)),
                ('complete_count', models.PositiveIntegerField(default=0)),
            ],
            options={
                'db_table': 'achievement',
            },
        ),
        migrations.CreateModel(
            name='BalanceSheet',
            fields=[
                ('id', models.CharField(max_length=13, primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'balance_sheet',
            },
        ),
        migrations.CreateModel(
            name='BalanceSheetLog',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('timestamp', models.DateTimeField(default=django.utils.timezone.now)),
                ('asset_value', models.PositiveIntegerField()),
                ('debt_balance', models.PositiveIntegerField()),
                ('benefit_value', models.DecimalField(decimal_places=2, max_digits=10, null=True)),
                ('debt_interest', models.DecimalField(decimal_places=2, max_digits=10, null=True)),
            ],
            options={
                'db_table': 'balance_sheet_log',
            },
        ),
        migrations.CreateModel(
            name='Category',
            fields=[
                ('id', models.CharField(max_length=15, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=30)),
                ('used_count', models.PositiveIntegerField(default=0)),
                ('icon', models.FilePathField()),
            ],
            options={
                'db_table': 'category',
            },
        ),
        migrations.CreateModel(
            name='DailyFlow',
            fields=[
                ('id', models.CharField(max_length=4, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=30)),
                ('value', models.PositiveIntegerField()),
                ('detail', models.TextField()),
                ('photo', models.FilePathField()),
            ],
            options={
                'db_table': 'daily_flow',
            },
        ),
        migrations.CreateModel(
            name='DailyFlowSheet',
            fields=[
                ('id', models.CharField(max_length=21, primary_key=True, serialize=False)),
                ('date', models.DateField(default=django.utils.timezone.now, null=True)),
            ],
            options={
                'db_table': 'daily_flow_sheet',
            },
        ),
        migrations.CreateModel(
            name='FinancialGoal',
            fields=[
                ('id', models.CharField(max_length=15, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=30)),
                ('detail', models.TextField(null=True)),
                ('term', models.PositiveIntegerField(null=True)),
                ('goal', models.PositiveIntegerField()),
                ('total_progress', models.PositiveIntegerField(default=0)),
                ('start', models.DateField()),
                ('period_term', models.PositiveIntegerField(null=True)),
                ('progress_per_period', models.PositiveIntegerField(null=True)),
                ('reward', models.PositiveIntegerField(null=True)),
            ],
            options={
                'db_table': 'financial_goal',
            },
        ),
        migrations.CreateModel(
            name='FinancialStatementPlan',
            fields=[
                ('id', models.CharField(max_length=15, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=30)),
                ('chosen', models.BooleanField()),
                ('start', models.DateTimeField()),
                ('end', models.DateTimeField()),
            ],
            options={
                'db_table': 'financial_statement_plan',
            },
        ),
        migrations.CreateModel(
            name='FinancialType',
            fields=[
                ('id', models.CharField(max_length=4, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=30, unique=True)),
                ('domain', models.CharField(choices=[('INC', 'Income'), ('EXP', 'Expense'), ('ASS', 'Asset'), ('DEB', 'Debt'), ('GOL', 'Goal'), ('ACH', 'Achievement')], max_length=3)),
            ],
            options={
                'db_table': 'financial_type',
            },
        ),
        migrations.CreateModel(
            name='KnowledgeArticle',
            fields=[
                ('id', models.CharField(max_length=5, primary_key=True, serialize=False)),
                ('topic', models.CharField(max_length=30)),
                ('detail', models.TextField()),
                ('body', models.FilePathField()),
                ('like', models.PositiveIntegerField()),
                ('view', models.PositiveIntegerField()),
            ],
            options={
                'db_table': 'knowledge_article',
            },
        ),
        migrations.CreateModel(
            name='Month',
            fields=[
                ('id', models.SmallIntegerField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=20)),
                ('days', models.PositiveSmallIntegerField()),
            ],
            options={
                'db_table': 'month',
            },
        ),
        migrations.CreateModel(
            name='RecommendBoard',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('status', models.CharField(choices=[('UNA', 'Unachived'), ('ACH', 'Achived'), ('COM', 'Complete')], default='UNA', max_length=3)),
            ],
            options={
                'db_table': 'recommend_board',
            },
        ),
        migrations.CreateModel(
            name='Suggestion',
            fields=[
                ('id', models.CharField(max_length=5, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=30)),
                ('detail', models.TextField()),
                ('image', models.FilePathField()),
                ('like', models.PositiveIntegerField()),
                ('recomm_count', models.PositiveIntegerField()),
            ],
            options={
                'db_table': 'suggestion',
            },
        ),
        migrations.CreateModel(
            name='Asset',
            fields=[
                ('id', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='api.category')),
                ('source', models.CharField(max_length=30)),
                ('recent_value', models.PositiveIntegerField()),
                ('benefit_value', models.DecimalField(decimal_places=2, max_digits=10, null=True)),
            ],
            options={
                'db_table': 'asset',
            },
        ),
        migrations.CreateModel(
            name='Budget',
            fields=[
                ('id', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='api.category')),
                ('balance', models.PositiveIntegerField()),
                ('total_budget', models.PositiveIntegerField()),
                ('budget_per_period', models.PositiveIntegerField()),
                ('frequency', models.CharField(choices=[('DLY', 'Daily'), ('WKY', 'Weekly'), ('MNY', 'Monthly'), ('ANY', 'Annually')], default='MNY', max_length=3)),
                ('due_date', models.DateTimeField(null=True)),
            ],
            options={
                'db_table': 'budget',
            },
        ),
        migrations.CreateModel(
            name='Debt',
            fields=[
                ('id', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='api.category')),
                ('balance', models.PositiveIntegerField()),
                ('creditor', models.CharField(max_length=30)),
                ('interest', models.DecimalField(decimal_places=2, max_digits=5, null=True)),
                ('debt_term', models.PositiveIntegerField()),
                ('minimum', models.PositiveIntegerField(null=True)),
                ('settlement', models.PositiveIntegerField(null=True)),
                ('imp_ranking', models.IntegerField()),
            ],
            options={
                'db_table': 'debt',
            },
        ),
        migrations.CreateModel(
            name='SuggestionBoard',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('liked', models.BooleanField()),
                ('sugg_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.suggestion')),
            ],
            options={
                'db_table': 'suggestion_board',
            },
        ),
    ]

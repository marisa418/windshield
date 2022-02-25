from django.urls import path
from . import views

app_name = 'api'

#all of these paths start with '/api/' already
urlpatterns = [
    path('provinces/', views.Provinces.as_view(), name='provinces'),

    #FINANCIAL STATEMENT PLAN
    path('statement/', views.Statement.as_view(), name='statement'),

    #CATEGORY
    path('categories/', views.Category.as_view(), name='categories_list'),
    
    #BALANCE SHEET
    path('balance-sheet/', views.BalanceSheet.as_view(), name='balance_sheet'),

    #BUDGET
    path('budget/', views.Budget.as_view(), name='budget')
]
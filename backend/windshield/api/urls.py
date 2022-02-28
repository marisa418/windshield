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
    path('budget/', views.Budget.as_view(), name='budget'),
    
    #DAILY FLOW SHEET
    path('daily-flow-sheet/', views.DailyFlowSheet.as_view(), name="daily_flow_sheet"),
    path('daily-flow-sheet/list/', views.DailyFlowSheetList.as_view(), name="daily_flow_sheet_list"),
    
    #METHOD
    path('method/', views.Method.as_view(), name='method'),
    
    #DAILY FLOW
    path('daily-flow/', views.DailyFlow.as_view(), name="daily_flow")
]
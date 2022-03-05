from django.urls import path
from . import views

app_name = 'api'

#all of these paths start with '/api/' already
urlpatterns = [
    path('provinces/', views.Provinces.as_view(), name='provinces'),

    #FINANCIAL STATEMENT PLAN
    path('statement/', views.Statement.as_view(), name='statement'),
    path('statement/<str:pk>/', views.StatementInstance.as_view(), name='statement-instance'),
    path('statement/<str:pk>/name/', views.StatementChangeName.as_view(), name='statement-change-name'),

    #CATEGORY
    path('categories/', views.Category.as_view(), name='categories-list'),
    
    #BALANCE SHEET
    path('balance-sheet/', views.BalanceSheet.as_view(), name='balance-sheet'),

    #BUDGET
    path('budget/', views.Budget.as_view(), name='budget'),
    
    #DAILY FLOW SHEET
    path('daily-flow-sheet/', views.DailyFlowSheet.as_view(), name="daily-flow_sheet"),
    path('daily-flow-sheet/list/', views.DailyFlowSheetList.as_view(), name="daily-flow-sheet-list"),
    
    #METHOD
    path('method/', views.Method.as_view(), name='method'),
    
    #DAILY FLOW
    path('daily-flow/', views.DailyFlow.as_view(), name="daily-flow")
]
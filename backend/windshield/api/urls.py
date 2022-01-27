from django.urls import path
from . import views

app_name = 'api'

#all of these paths start with '/api/' already
urlpatterns = [
    path('provinces/', views.Provinces.as_view(), name='provinces'),

    #FINANCIAL STATEMENT PLAN
    path('statement/', views.StatementList.as_view(), name='statement'),

    #CATEGORY
    path('category/', views.Category.as_view(), name='category'),
]
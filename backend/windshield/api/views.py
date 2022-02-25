from email import message
from uuid import uuid4
from rest_framework import status, generics, permissions
from rest_framework.response import Response
from rest_framework.views import APIView
from . import serializers
from . import models
from user.models import Province, NewUser
from user.serializers import ProvinceSerializer
from rest_framework.filters import OrderingFilter

class Provinces(generics.ListAPIView):
    permission_classes = [permissions.AllowAny]
    queryset = Province.objects.all()
    serializer_class = ProvinceSerializer

class StatementList(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = serializers.StatementSerializer
    filter_backends = [OrderingFilter]
    # queryset = models.FinancialStatementPlan.objects.all()

    def get_queryset(self):
        uuid = self.request.user.uuid
        if uuid is not None:
            queryset = models.FinancialStatementPlan.objects.filter(owner_id=uuid)
            return queryset
        else :
            return Response(status=status.HTTP_400_BAD_REQUEST, message='uuid not found')

class Statement(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serialzer_class = serializers.StatementSerializer(many=True)
    queryset = models.FinancialStatementPlan.objects.all()

class Category(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = serializers.CategorySerializer

    def get_queryset(self):
        uuid = self.request.user.uuid
        if uuid is not None: 
            queryset = models.Category.objects.filter(user_id=uuid).order_by("used_count")
            return queryset
        else :
            return Response(status=status.HTTP_400_BAD_REQUEST)
    
    def perform_create(self, serializer):
        uuid = self.request.user.uuid
        if uuid is not None:
            owner = NewUser.objects.get(uuid=uuid)
            cat_id = models.Category.objects.filter(user_id=uuid).count()
            serializer.save( id ='CAT' + str(uuid)[:10] + str("0" + str(cat_id))[-2:], 
                            user_id = owner
                            )
        else :
            return Response(status=status.HTTP_400_BAD_REQUEST)
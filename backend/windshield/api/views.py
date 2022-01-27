from uuid import uuid4
from rest_framework import status, generics, permissions
from rest_framework.response import Response
from rest_framework.views import APIView
from . import serializers
from . import models
from user.models import Province
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
        queryset = models.FinancialStatementPlan.objects.all()
        uuid = self.request.query_params.get('uuid')
        if uuid is not None:
            queryset = queryset.filter(owner_id=uuid)
            return queryset
        else :
            return Response(status=status.HTTP_400_BAD_REQUEST)

class Statement(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serialzer_class = serializers.StatementSerializer(many=True)
    queryset = models.FinancialStatementPlan.objects.all()

class Category(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = serializers.CategorySerializer
    queryset = models.Category.objects.all()

    def perform_create(self, serializer):
        serializer.save( id ='CAT' + str(uuid4())[:10] + self.request.data['id'])
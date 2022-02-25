from urllib import response
from uuid import uuid4
from rest_framework import status, generics, permissions
from rest_framework.response import Response
from rest_framework.views import APIView
from . import serializers
from . import models
from user.models import Province, NewUser
from user.serializers import ProvinceSerializer
from rest_framework.filters import OrderingFilter

DEFUALT_CAT = [
            ('เงินเดือน', 1, 'briefcase'),
            ('ค่าจ้าง', 1, 'hand-holding-usd'),
            ('ค่าล่วงเวลา', 1, 'business-time'),
            ('โบนัส', 1, 'briefcase'),
            ('ค่าคอมมิชชั่น', 1, 'comment-dollar'),
            ('กำไรจากธุรกิจ', 1, 'dollar-sign'),
            ('ดอกเบี้ย', 2, 'percentage'),
            ('เงินปันผล', 2, 'chart-line'),
            ('ค่าเช่า', 2, 'building'),
            ('ขายสินทรัพย์', 2, 'hand-holding-usd'),
            ('เงินรางวัล', 3, 'trophy'),
            ('ค่าเลี้ยงดู', 3, 'hand-holding-usd'),
            ('อาหาร/เครื่่องดื่ม', 4, 'utensils'),
            ('ภายในครัวเรือน', 4, 'house-user'),
            ('ความบันเทิง/ความสุขส่วนบุคคล', 4, 'music'),
            ('สาธารณูปโภค', 4, 'bolt'),
            ('ดูแลตัวเอง', 4, 'heart'),
            ('ค่าเดินทาง', 4, 'route'),
            ('รักษาพยาบาล', 4, 'hand-holding-medical'),
            ('ดูแลบุพการี', 4, 'user-friends'),
            ('ดูแลบุตร', 4, 'baby'),
            ('ภาษี', 4, 'donate'),
            ('ชำระหนี้', 4, 'hand-holding-usd'),
            ('เสี่ยงดวง', 4, 'dice'),
            ('กิจกรรมทางศาสนา ', 4, 'praying-hands'),
            ('เช่าบ้าน', 5, 'home'),
            ('หนี้ กยศ. กองทุน กยศ.', 5, 'graduation-cap'),
            ('ผ่อนรถ', 5, 'car'),
            ('ผ่อนสินค้า', 5, 'shopping-cart'),
            ('ผ่อนหนี้นอกระบบ', 5, 'comments-dollar'),
            ('ผ่อนสินเชื่อส่วนบุคคล', 5, 'comments-dollar'),
            ('ผ่อนหนี้สหกรณ์', 5, 'comments-dollar'),
            ('เบี้ยประกัน', 5, 'file-contract'),
            ('ประกันสังคม', 6, 'building'),
            ('กองทุนสำรองเลี้ยงชีพ', 6, 'coins'),
            ('กอนทุน กบข.', 6, 'coins'),
            ('สหกรณ์ออมทรัพย์', 6, 'comments-dollar'),
            ('เงินออม', 6, 'piggy-bank'),
            ('เงินลงทุน', 6, 'chart-line')
            ]

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

class BalanceSheet(generics.RetrieveAPIView):
    permissions_classes = [permissions.IsAuthenticated]
    serializer_class = serializers.BalanceSheetSerializer
    
    def get_object(self):
        uuid = self.request.user.uuid
        if uuid is not None:
            try:
                bsheet = models.BalanceSheet.objects.get(owner_id = uuid)
            except models.BalanceSheet.DoesNotExist:
                owner = models.NewUser.objects.get(uuid=uuid)
                bsheet = models.BalanceSheet.objects.create(id = "BSH" + str(uuid)[:10],
                                                   owner_id = owner)
        return bsheet
    

class Statement(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = serializers.StatementSerializer(many=True)
    queryset = models.FinancialStatementPlan.objects.all()

class Category(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = serializers.CategorySerializer

    def get_queryset(self):
        uuid = self.request.user.uuid
        if uuid is not None: 
            queryset = models.Category.objects.filter(user_id=uuid).order_by("used_count")
            if not queryset:
                owner = models.NewUser.objects.get(uuid=uuid)
                for i in range(len(DEFUALT_CAT)):
                    ftype_instance = models.FinancialType.objects.get(id=str(DEFUALT_CAT[i][1]))
                    models.Category.objects.create(id = "CAT" + str(owner.pk)[:10] + ("0" + str(i))[-2:],
                                            name = DEFUALT_CAT[i][0],
                                            ftype = ftype_instance,
                                            user_id = owner,
                                            icon = DEFUALT_CAT[i][2]
                                            )
                queryset = models.Category.objects.filter(user_id=uuid).order_by("used_count")
            return queryset
        else :
            return Response(status=status.HTTP_401_UNAUTHORIZED)
    
    def perform_create(self, serializer):
        uuid = self.request.user.uuid
        if uuid is not None:
            owner = NewUser.objects.get(uuid=uuid)
            cat_id = models.Category.objects.filter(user_id=uuid).count()
            ftype = str(self.request.data.pop("ftype"))
            ftype_instance = models.FinancialType.objects.get(id=ftype)
            return serializer.save( id ='CAT' + str(uuid)[:10] + str("0" + str(cat_id))[-2:], 
                            user_id = owner,
                            ftype = ftype_instance,
                            **self.request.data
                            )
        else :
            return Response(status=status.HTTP_401_UNAUTHORIZED)
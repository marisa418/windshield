
from rest_framework import serializers
from user.models import NewUser
from user.models import Province
from api.models import Category, FinancialType

class ProvinceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Province
        fields = ('id', 'name_in_thai')

DEFUALT_CAT = [
            ('เงินเดือน', 1),
            ('ค่าจ้าง', 1),
            ('ค่าล่วงเวลา', 1),
            ('โบนัส', 1),
            ('ค่าคอมมิชชั่น', 1),
            ('กำไรจากธุรกิจ', 1),
            ('ดอกเบี้ย', 2),
            ('เงินปันผล', 2),
            ('ค่าเช่า', 2),
            ('ขายสินทรัพย์', 2),
            ('เงินรางวัล', 3),
            ('ค่าเลี้ยงดู', 3),
            ('อาหาร/เครื่่องดื่ม', 4),
            ('ภายในครัวเรือน', 4),
            ('ความบันเทิง/ความสุขส่วนบุคคล', 4),
            ('สาธารณูปโภค', 4),
            ('ดูแลตัวเอง', 4),
            ('ค่าเดินทาง', 4),
            ('รักษาพยาบาล', 4),
            ('ดูแลบุพการี', 4),
            ('ดูแลบุตร', 4),
            ('ภาษี', 4),
            ('ชำระหนี้', 4),
            ('เสี่ยงดวง', 4),
            ('กิจกรรมทางศาสนา ', 4),
            ('เช่าบ้าน', 5),
            ('หนี้ กยศ. กองทุน กยศ.', 5),
            ('ผ่อนรถ', 5),
            ('ผ่อนสินค้า', 5),
            ('ผ่อนหนี้นอกระบบ', 5),
            ('ผ่อนสินเชื่อส่วนบุคคล', 5),
            ('ประกันสังคม', 6),
            ('กองทุนสำรองเลี้ยงชีพ', 6),
            ('กอนทุน กบข.', 6),
            ('สหกรณ์ออมทรัพย์', 6),
            ('เงินออม', 6),
            ('เงินลงทุน', 6)
            ]

class RegisterUserSerializer(serializers.ModelSerializer):
    user_id = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)
    password = serializers.CharField(required=True, write_only=True)
    
    class Meta:
        model = NewUser
        fields = ('user_id', 'email', 'password', 'tel')
        extra_kwargs = {'password' : {'write_only': True}}

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        instance = self.Meta.model(**validated_data)
        if password is not None:
            instance.set_password(password)
        instance.save()
        for i in range(len(DEFUALT_CAT)):
            ftype_instance = FinancialType.objects.get(id=str(DEFUALT_CAT[i][1]))
            Category.objects.create(id = "CAT" + str(instance.pk)[:10] + ("0" + str(i))[-2:],
                                    name = DEFUALT_CAT[i][0],
                                    ftype = ftype_instance,
                                    user_id = instance
                                    )
        return instance

test_data = {
    "user_id" : "test_api_cat_init",
    "email" : "cat_init@mail.com",
    "password" : "12345678"
}

class UserSerializer(serializers.ModelSerializer):
    # user_id = serializers.CharField()
    # email = serializers.EmailField()
    # pin = serializers.CharField()
    # tel = serializers.CharField()
    # occu_type = serializers.CharField()
    # status = serializers.CharField() 
    # age = serializers.IntegerField()
    # province = serializers.IntegerField()
    # family = serializers.IntegerField()
    # points = serializers.IntegerField()

    class Meta:
        model = NewUser
        exclude = ('password',)

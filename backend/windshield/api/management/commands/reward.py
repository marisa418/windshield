from operator import mod
from django.core.management.base import BaseCommand, CommandError
from user.models import NewUser
from ... import models
from datetime import datetime
from pytz import timezone
from django.db.models import Exists, OuterRef, Q

class Command(BaseCommand):
    help = "give daily reward to users who done thier daily flow sheet"
    
    def handle(self, *args, **options):
        today = datetime.now(tz= timezone('Asia/Bangkok'))
        self.stdout.write("reward of " + today.strftime('%a %d %b %Y'))
        dailysheets = models.DailyFlowSheet.objects.filter(date=today)
        dailysheets = dailysheets.filter(Exists(models.DailyFlow.objects.filter(df_id=OuterRef('pk'))))
        reward = 100
        for sheet in dailysheets:
            try:
                owner = NewUser.objects.get(uuid=sheet.owner_id.uuid)
            except NewUser.DoesNotExist:
                self.stdout.write(self.style.ERROR('fail: give reward'))
                continue
            owner.points = reward + owner.points
            owner.save()
            self.stdout.write(self.style.SUCCESS('success: give reward to "%s"' % str(owner.uuid)))
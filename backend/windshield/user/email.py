import random
from django.core.mail import BadHeaderError, send_mail
from django.conf import settings
from .models import NewUser, VerifyCodeLog
from .serializers import VerificationCodeSerializer

def send_otp_to_email(email, activity):
    subject = "Windsheild's Verification Code"
    otp = random.choice((0, 999999))
    otp = ('0'*5 + str(otp))[-6:]
    message = f'OTP: {otp}'
    email_from = settings.EMAIL_HOST
    # try:
    send_mail(subject, message, email_from, [email])
    # except:
    #     return None
    user = NewUser.objects.get(email=email)
    verifylog = VerifyCodeLog.objects.create(user=user, code=otp, activity=activity)
    return verifylog
import random
from django.core.mail import send_mail
from django.conf import settings
from .models import NewUser, VerifyCodeLog

def _OTP_generate():
    otp = random.choice(range(0, 999999))
    otp = ('0'*5 + str(otp))[-6:]
    seeds = "1234567890abcdefghijklmnopqrstuvwxyz"
    ref = "".join([ random.choice(seeds) for _ in range(8) ])
    return otp, ref

def send_otp_to_email(email):
    subject = "Windsheild's Verification Code"
    otp, ref = _OTP_generate()
    message = f'รหัส OTP ของคุณคือ: {otp}\nรหัสอ้างอิง: {ref}'
    email_from = settings.EMAIL_HOST
    try:
        user = NewUser.objects.get(email=email)
    except NewUser.DoesNotExist:
        return None
    try:
        send_mail(subject, message, email_from, [user.email], fail_silently=False)
    except:
        return None
    verifylog = VerifyCodeLog.objects.create(user=user, code=otp, ref_code=ref)
    verifylog.email = user.email
    return verifylog
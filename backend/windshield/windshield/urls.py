from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

admin.site.site_header = "WINDSHIELD Administration"
admin.site.index_title = "Administration Index"
admin.site.site_title = "windshield admin"
admin.site.site_url = None

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls', namespace='api')),
    path('user/', include('user.urls', namespace='user')),

    path('api-auth/', include('rest_framework.urls')),

    # Token URL
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

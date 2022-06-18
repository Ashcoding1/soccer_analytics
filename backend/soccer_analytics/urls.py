"""soccer_analytics URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import URLPattern, URLResolver, include, path
from django.views.generic import RedirectView

urlpatterns: list[URLResolver | URLPattern] = [
    path(route="admin/", view=admin.site.urls),
    # below ensures main page redirects to a useful app
    path(route="", view=RedirectView.as_view(url="country/", permanent=True)),
    # this delegates handling of URLs with prefix "country/" to `country_stats`` app
    path(route="country/", view=include("country_stats.urls")),
    # this just blindly serves up anything in the `backend/static` folder, for testing
    *static(settings.STATIC_URL, document_root=settings.STATIC_ROOT),
]

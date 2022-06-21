from django.urls import path

from country_stats import views

urlpatterns = [
    path("", views.index, name="index"),
    path("<str:country>", views.get_seasons, name="seasons"),
]

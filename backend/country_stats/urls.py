from django.urls import path

from country_stats import views

urlpatterns = [
    path("", views.index, name="index"),
]

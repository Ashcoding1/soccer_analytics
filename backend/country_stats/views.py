import json

from django.http.request import HttpRequest
from django.http.response import HttpResponse, JsonResponse
from django.shortcuts import render

from dbmodels.models import Country

# Create your views here.


def index(request: HttpRequest) -> HttpResponse:
    countries = Country.objects.values_list("name", flat=True)
    context: dict[str, list[str]] = dict(countries=[*countries])

    # to use a template
    # return render(request, template_name="index.html", context=context)

    return JsonResponse(data=context)

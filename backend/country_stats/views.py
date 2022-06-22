import json

from django.http.request import HttpRequest
from django.http.response import HttpResponse, JsonResponse
from django.shortcuts import render

from dbmodels.models import Country, Match

# Create your views here.


def index(request: HttpRequest) -> HttpResponse:
    countries = Country.objects.values_list("name", flat=True)
    context: dict[str, list[str]] = dict(countries=[*countries])

    # just return the string in a HttpResponse
    # return HttpResponse(content=json.dumps(context))

    # to use a template
    return render(request, template_name="index.html", context=context)

    # return JsonResponse(data=context)


def get_seasons(request: HttpRequest, country: str) -> HttpResponse:
    seasons = (
        Match.objects.filter(country__name__iexact=country)
        .order_by()
        .values_list("season", flat=True)
        .distinct()
    )
    return JsonResponse(data=dict(seasons=[*seasons]))

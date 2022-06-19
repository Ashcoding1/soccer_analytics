from django.contrib import admin

from dbmodels.models import Country, League, Match, Player, PlayerAttr, Team, TeamAttr

# Register your models here.
admin.site.register(Country)
admin.site.register(League)
admin.site.register(Team)
admin.site.register(TeamAttr)
admin.site.register(Player)
admin.site.register(PlayerAttr)
admin.site.register(Match)

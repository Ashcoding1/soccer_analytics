from dbmodels.models import Country, League, Match, Player, PlayerAttr, Team, TeamAttr
from django.test import TestCase

# Create your tests here.


class PrintingTestCase(TestCase):
    def setUp(self) -> None:
        pass

    def test_country(self) -> None:
        c1 = Country.objects.get(pk=1)
        s = str(c1)
        assert s == "Belgium"

    def test_league(self) -> None:
        s = str(League.objects.get(pk=1))
        assert s == "Belgium Jupiler League (Belgium)", s

    def test_match(self) -> None:
        s = str(Match.objects.get(pk=1))
        correct = """Belgium Jupiler League (Belgium)
2008/2009 Stage 1 - 2008-08-17
KRC Genk vs Beerschot AC - 1 / 1"""
        assert s == correct, s

    def test_player(self) -> None:
        s = str(Player.objects.all()[0])
        assert s == "Patryk Rachwal,18, DoB: 1981-01-27 00:00:00", s

    def test_player_attr(self) -> None:
        s = str(PlayerAttr.objects.get(pk=1))
        assert s == "PlayerAttr(name=Aaron Appindangoye, date=2016-02-18, rating=67)", s

    def test_team(self) -> None:
        s = str(Team.objects.all()[1])
        assert s == "Oud-Heverlee Leuven", s

    def test_team_attr(self) -> None:
        s = str(TeamAttr.objects.get(pk=1))
        assert s == "TeamAttr(team=FC Aarau, date=2010-02-22)", s

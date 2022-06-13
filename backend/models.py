# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.db.models import Model

SHARED_ARGS = dict(blank=False, null=False, editable=False)
UNIQUE_ARGS = SHARED_ARGS | dict(unique=True)


class Countries(Model):
    id = models.IntegerField(primary_key=True)
    name = models.TextField(verbose_name="country name", **SHARED_ARGS)

    class Meta:
        managed = False
        db_table = "countries"


class Leagues(Model):
    id = models.IntegerField(primary_key=True)
    country_id = models.ForeignKey(Countries, **UNIQUE_ARGS)
    name = models.TextField(verbose_name="league name", **SHARED_ARGS)

    class Meta:
        managed = False
        db_table = "leagues"


class Teams(Model):
    tid = models.IntegerField(primary_key=True)
    name = models.TextField(**SHARED_ARGS)
    code = models.CharField(max_length=3, **SHARED_ARGS)

    class Meta:
        managed = False
        db_table = "teams"


class Players(Model):
    pid = models.IntegerField(primary_key=True)
    name = models.TextField(**SHARED_ARGS)
    pfid = models.IntegerField(**UNIQUE_ARGS)
    birthday = models.TextField(**SHARED_ARGS)
    height = models.IntegerField(**SHARED_ARGS)
    weight = models.IntegerField(**SHARED_ARGS)

    class Meta:
        managed = False
        db_table = "players"


class Matches(Model):
    """
    Note if we use pandas, then columns without NaN are:

    [
        'id',
        'country_id',
        'league_id',
        'season',
        'stage',
        'date',
        'match_id',
        'home_tid',
        'away_tid',
        'home_goal',
        'away_goal'
    ]

    """

    # fmt: off
    id         = models.IntegerField(primary_key=True)
    country_id = models.ForeignKey(Countries)
    league_id  = models.ForeignKey(Leagues)
    season     = models.TextField(**SHARED_ARGS)
    stage      = models.IntegerField(**SHARED_ARGS)
    date       = models.TextField(**SHARED_ARGS)
    match_id   = models.IntegerField(**UNIQUE_ARGS)

    home_tid  = models.ForeignKey(Teams, models.DO_NOTHING, db_column="home_tid", **SHARED_ARGS)
    away_tid  = models.ForeignKey(Teams, models.DO_NOTHING, db_column="away_tid", **SHARED_ARGS)
    home_goal = models.IntegerField(**SHARED_ARGS)
    away_goal = models.IntegerField(**SHARED_ARGS)

    home_x1  = models.IntegerField(db_column="home_X1",  blank=True, null=True)
    home_x2  = models.IntegerField(db_column="home_X2",  blank=True, null=True)
    home_x3  = models.IntegerField(db_column="home_X3",  blank=True, null=True)
    home_x4  = models.IntegerField(db_column="home_X4",  blank=True, null=True)
    home_x5  = models.IntegerField(db_column="home_X5",  blank=True, null=True)
    home_x6  = models.IntegerField(db_column="home_X6",  blank=True, null=True)
    home_x7  = models.IntegerField(db_column="home_X7",  blank=True, null=True)
    home_x8  = models.IntegerField(db_column="home_X8",  blank=True, null=True)
    home_x9  = models.IntegerField(db_column="home_X9",  blank=True, null=True)
    home_x10 = models.IntegerField(db_column="home_X10", blank=True, null=True)
    home_x11 = models.IntegerField(db_column="home_X11", blank=True, null=True)
    away_x1  = models.IntegerField(db_column="away_X1",  blank=True, null=True)
    away_x2  = models.IntegerField(db_column="away_X2",  blank=True, null=True)
    away_x3  = models.IntegerField(db_column="away_X3",  blank=True, null=True)
    away_x4  = models.IntegerField(db_column="away_X4",  blank=True, null=True)
    away_x5  = models.IntegerField(db_column="away_X5",  blank=True, null=True)
    away_x6  = models.IntegerField(db_column="away_X6",  blank=True, null=True)
    away_x7  = models.IntegerField(db_column="away_X7",  blank=True, null=True)
    away_x8  = models.IntegerField(db_column="away_X8",  blank=True, null=True)
    away_x9  = models.IntegerField(db_column="away_X9",  blank=True, null=True)
    away_x10 = models.IntegerField(db_column="away_X10", blank=True, null=True)
    away_x11 = models.IntegerField(db_column="away_X11", blank=True, null=True)
    home_y1  = models.IntegerField(db_column="home_Y1",  blank=True, null=True)
    home_y2  = models.IntegerField(db_column="home_Y2",  blank=True, null=True)
    home_y3  = models.IntegerField(db_column="home_Y3",  blank=True, null=True)
    home_y4  = models.IntegerField(db_column="home_Y4",  blank=True, null=True)
    home_y5  = models.IntegerField(db_column="home_Y5",  blank=True, null=True)
    home_y6  = models.IntegerField(db_column="home_Y6",  blank=True, null=True)
    home_y7  = models.IntegerField(db_column="home_Y7",  blank=True, null=True)
    home_y8  = models.IntegerField(db_column="home_Y8",  blank=True, null=True)
    home_y9  = models.IntegerField(db_column="home_Y9",  blank=True, null=True)
    home_y10 = models.IntegerField(db_column="home_Y10", blank=True, null=True)
    home_y11 = models.IntegerField(db_column="home_Y11", blank=True, null=True)
    away_y1  = models.IntegerField(db_column="away_Y1",  blank=True, null=True)
    away_y2  = models.IntegerField(db_column="away_Y2",  blank=True, null=True)
    away_y3  = models.IntegerField(db_column="away_Y3",  blank=True, null=True)
    away_y4  = models.IntegerField(db_column="away_Y4",  blank=True, null=True)
    away_y5  = models.IntegerField(db_column="away_Y5",  blank=True, null=True)
    away_y6  = models.IntegerField(db_column="away_Y6",  blank=True, null=True)
    away_y7  = models.IntegerField(db_column="away_Y7",  blank=True, null=True)
    away_y8  = models.IntegerField(db_column="away_Y8",  blank=True, null=True)
    away_y9  = models.IntegerField(db_column="away_Y9",  blank=True, null=True)
    away_y10 = models.IntegerField(db_column="away_Y10", blank=True, null=True)
    away_y11 = models.IntegerField(db_column="away_Y11", blank=True, null=True)
    home_1  = models.ForeignKey(Players, models.DO_NOTHING, db_column="home_1",  blank=True, null=True)
    home_2  = models.ForeignKey(Players, models.DO_NOTHING, db_column="home_2",  blank=True, null=True)
    home_3  = models.ForeignKey(Players, models.DO_NOTHING, db_column="home_3",  blank=True, null=True)
    home_4  = models.ForeignKey(Players, models.DO_NOTHING, db_column="home_4",  blank=True, null=True)
    home_5  = models.ForeignKey(Players, models.DO_NOTHING, db_column="home_5",  blank=True, null=True)
    home_6  = models.ForeignKey(Players, models.DO_NOTHING, db_column="home_6",  blank=True, null=True)
    home_7  = models.ForeignKey(Players, models.DO_NOTHING, db_column="home_7",  blank=True, null=True)
    home_8  = models.ForeignKey(Players, models.DO_NOTHING, db_column="home_8",  blank=True, null=True)
    home_9  = models.ForeignKey(Players, models.DO_NOTHING, db_column="home_9",  blank=True, null=True)
    home_10 = models.ForeignKey(Players, models.DO_NOTHING, db_column="home_10", blank=True, null=True)
    home_11 = models.ForeignKey(Players, models.DO_NOTHING, db_column="home_11", blank=True, null=True)
    away_1  = models.ForeignKey(Players, models.DO_NOTHING, db_column="away_1",  blank=True, null=True)
    away_2  = models.ForeignKey(Players, models.DO_NOTHING, db_column="away_2",  blank=True, null=True)
    away_3  = models.ForeignKey(Players, models.DO_NOTHING, db_column="away_3",  blank=True, null=True)
    away_4  = models.ForeignKey(Players, models.DO_NOTHING, db_column="away_4",  blank=True, null=True)
    away_5  = models.ForeignKey(Players, models.DO_NOTHING, db_column="away_5",  blank=True, null=True)
    away_6  = models.ForeignKey(Players, models.DO_NOTHING, db_column="away_6",  blank=True, null=True)
    away_7  = models.ForeignKey(Players, models.DO_NOTHING, db_column="away_7",  blank=True, null=True)
    away_8  = models.ForeignKey(Players, models.DO_NOTHING, db_column="away_8",  blank=True, null=True)
    away_9  = models.ForeignKey(Players, models.DO_NOTHING, db_column="away_9",  blank=True, null=True)
    away_10 = models.ForeignKey(Players, models.DO_NOTHING, db_column="away_10", blank=True, null=True)
    away_11 = models.ForeignKey(Players, models.DO_NOTHING, db_column="away_11", blank=True, null=True)
    goal       = models.TextField(blank=True, null=True)
    shoton     = models.TextField(blank=True, null=True)
    shotoff    = models.TextField(blank=True, null=True)
    foulcommit = models.TextField(blank=True, null=True)
    card       = models.TextField(blank=True, null=True)
    cross      = models.TextField(blank=True, null=True)
    corner     = models.TextField(blank=True, null=True)
    possession = models.TextField(blank=True, null=True)
    b365h = models.TextField(db_column="B365H", blank=True, null=True)
    b365d = models.TextField(db_column="B365D", blank=True, null=True)
    b365a = models.TextField(db_column="B365A", blank=True, null=True)
    bwh   = models.TextField(db_column="BWH",   blank=True, null=True)
    bwd   = models.TextField(db_column="BWD",   blank=True, null=True)
    bwa   = models.TextField(db_column="BWA",   blank=True, null=True)
    iwh   = models.TextField(db_column="IWH",   blank=True, null=True)
    iwd   = models.TextField(db_column="IWD",   blank=True, null=True)
    iwa   = models.TextField(db_column="IWA",   blank=True, null=True)
    lbh   = models.TextField(db_column="LBH",   blank=True, null=True)
    lbd   = models.TextField(db_column="LBD",   blank=True, null=True)
    lba   = models.TextField(db_column="LBA",   blank=True, null=True)
    psh   = models.TextField(db_column="PSH",   blank=True, null=True)
    psd   = models.TextField(db_column="PSD",   blank=True, null=True)
    psa   = models.TextField(db_column="PSA",   blank=True, null=True)
    whh   = models.TextField(db_column="WHH",   blank=True, null=True)
    whd   = models.TextField(db_column="WHD",   blank=True, null=True)
    wha   = models.TextField(db_column="WHA",   blank=True, null=True)
    sjh   = models.TextField(db_column="SJH",   blank=True, null=True)
    sjd   = models.TextField(db_column="SJD",   blank=True, null=True)
    sja   = models.TextField(db_column="SJA",   blank=True, null=True)
    vch   = models.TextField(db_column="VCH",   blank=True, null=True)
    vcd   = models.TextField(db_column="VCD",   blank=True, null=True)
    vca   = models.TextField(db_column="VCA",   blank=True, null=True)
    gbh   = models.TextField(db_column="GBH",   blank=True, null=True)
    gbd   = models.TextField(db_column="GBD",   blank=True, null=True)
    gba   = models.TextField(db_column="GBA",   blank=True, null=True)
    bsh   = models.TextField(db_column="BSH",   blank=True, null=True)
    bsd   = models.TextField(db_column="BSD",   blank=True, null=True)
    bsa   = models.TextField(db_column="BSA",   blank=True, null=True)
    # fmt: on

    class Meta:
        managed = False
        db_table = "matches"


class PlayerAttrs(Model):
    """Only columns without any nulls are id, pid, date"""

    # fmt: off
    pid = models.ForeignKey("Players", models.DO_NOTHING, db_column="pid", **SHARED_ARGS)
    date = models.TextField(**SHARED_ARGS)
    overall_rating      = models.IntegerField(blank=True, null=True)
    potential           = models.IntegerField(blank=True, null=True)
    preferred_foot      = models.TextField(blank=True, null=True)
    attacking_work_rate = models.TextField(blank=True, null=True)
    defensive_work_rate = models.TextField(blank=True, null=True)
    crossing            = models.IntegerField(blank=True, null=True)
    finishing           = models.IntegerField(blank=True, null=True)
    heading_accuracy    = models.IntegerField(blank=True, null=True)
    short_passing       = models.IntegerField(blank=True, null=True)
    volleys             = models.IntegerField(blank=True, null=True)
    dribbling           = models.IntegerField(blank=True, null=True)
    curve               = models.IntegerField(blank=True, null=True)
    free_kick_accuracy  = models.IntegerField(blank=True, null=True)
    long_passing        = models.IntegerField(blank=True, null=True)
    ball_control        = models.IntegerField(blank=True, null=True)
    acceleration        = models.IntegerField(blank=True, null=True)
    sprint_speed        = models.IntegerField(blank=True, null=True)
    agility             = models.IntegerField(blank=True, null=True)
    reactions           = models.IntegerField(blank=True, null=True)
    balance             = models.IntegerField(blank=True, null=True)
    shot_power          = models.IntegerField(blank=True, null=True)
    jumping             = models.IntegerField(blank=True, null=True)
    stamina             = models.IntegerField(blank=True, null=True)
    strength            = models.IntegerField(blank=True, null=True)
    long_shots          = models.IntegerField(blank=True, null=True)
    aggression          = models.IntegerField(blank=True, null=True)
    interceptions       = models.IntegerField(blank=True, null=True)
    positioning         = models.IntegerField(blank=True, null=True)
    vision              = models.IntegerField(blank=True, null=True)
    penalties           = models.IntegerField(blank=True, null=True)
    marking             = models.IntegerField(blank=True, null=True)
    standing_tackle     = models.IntegerField(blank=True, null=True)
    sliding_tackle      = models.IntegerField(blank=True, null=True)
    gk_diving           = models.IntegerField(blank=True, null=True)
    gk_handling         = models.IntegerField(blank=True, null=True)
    gk_kicking          = models.IntegerField(blank=True, null=True)
    gk_positioning      = models.IntegerField(blank=True, null=True)
    gk_reflexes         = models.IntegerField(blank=True, null=True)
    # fmt: on

    class Meta:
        managed = False
        db_table = "player_attrs"


class TeamAttrs(Model):
    # fmt: off
    tid = models.ForeignKey("Teams", models.DO_NOTHING, db_column="tid", blank=True, null=True)
    date = models.TextField(blank=True, null=True)
    buildup_play_dribbling            = models.IntegerField(blank=True, null=True)  # this has nulls
    buildup_play_speed                = models.IntegerField(**SHARED_ARGS)
    buildup_play_passing              = models.IntegerField(**SHARED_ARGS)
    buildup_play_speed_class          = models.TextField(**SHARED_ARGS)
    buildup_play_dribbling_class      = models.TextField(**SHARED_ARGS)
    buildup_play_passing_class        = models.TextField(**SHARED_ARGS)
    buildup_play_positioning_class    = models.TextField(**SHARED_ARGS)
    chance_creation_passing           = models.IntegerField(**SHARED_ARGS)
    chance_creation_crossing          = models.IntegerField(**SHARED_ARGS)
    chance_creation_shooting          = models.IntegerField(**SHARED_ARGS)
    chance_creation_passing_class     = models.TextField(**SHARED_ARGS)
    chance_creation_crossing_class    = models.TextField(**SHARED_ARGS)
    chance_creation_shooting_class    = models.TextField(**SHARED_ARGS)
    chance_creation_positioning_class = models.TextField(**SHARED_ARGS)
    defence_pressure                  = models.IntegerField(**SHARED_ARGS)
    defence_aggression                = models.IntegerField(**SHARED_ARGS)
    defence_team_width                = models.IntegerField(**SHARED_ARGS)
    defence_pressure_class            = models.TextField(**SHARED_ARGS)
    defence_aggression_class          = models.TextField(**SHARED_ARGS)
    defence_team_width_class          = models.TextField(**SHARED_ARGS)
    defence_defender_line_class       = models.TextField(**SHARED_ARGS)
    # fmt: on

    class Meta:
        managed = False
        db_table = "team_attrs"

/***************************************************************************************
Everything about this DB is poorly-named, cluttered, and ugly, and with duplicates /
invalid data. We correct the major issues by renaming columns and tables to consistent
lower case names / plurats, reducing excessively long names, and fixing the foreign key
constraints. We ultimately have X tables to fix:

Team - Primary lookup table for team names, fifa ids are useless, and there are dupes
Team_Attributes - dupes due to dupes in `Team`, must be removed, fifa_id must be removed
Player - useless fifa ids again
Player_Attributes - foreign key constraints are messed
Match - various dupes due to dupes above
Country - OK
League - OK

****************************************************************************************/

/***************************************************************************************
* Start by de-duping Team data. If you run:

SELECT * FROM TEAM WHERE team_fifa_api_id in
    (SELECT team_fifa_api_id FROM
        (SELECT *, COUNT(team_fifa_api_id) as CNT FROM Team GROUP BY team_fifa_api_id HAVING CNT > 1));

  you will see there are three dupes to deal with:

    id     team_api_id  team_fifa_api_id  team_long_name        team_short_name
    -----  -----------  ----------------  --------------------  ---------------
    16     9996         111560            Royal Excel Mouscron  MOU
    2510   274581       111560            Royal Excel Mouscron  MOP
    31444  8031         111429            Polonia Bytom         POB
    31445  8020         111429            Polonia Bytom         GOR
    31451  8244         301               Widzew Łódź           LOD
    32409  8024         301               Widzew Łódź           WID

  However, team_short_name has many non-unique values (dupes). So the real problem is
  duplicated team_api_ids. What tables besies Team do these team_api_ids appear in?

    Team
    Team_Attributes
    Match

  Of the above table, what do the data look like for the duped team_api_ids?
*/

CREATE TABLE dupe_tids (tid INTEGER);
INSERT INTO dupe_tids (tid) VALUES (274581);
INSERT INTO dupe_tids (tid) VALUES (8031);
INSERT INTO dupe_tids (tid) VALUES (8244);
INSERT INTO dupe_tids (tid) VALUES (9996);
INSERT INTO dupe_tids (tid) VALUES (8020);
INSERT INTO dupe_tids (tid) VALUES (8024);


/*

SELECT team_api_id, team_fifa_api_id, date from Team_Attributes where team_api_id IN dupe_tids ORDER BY team_fifa_api_id, date;

id    team_api_id  team_fifa_api_id  date
----  -----------  ----------------  -------------------
755   8244         301               2011-02-22 00:00:00
1395  8024         301               2011-02-22 00:00:00
756   8244         301               2012-02-22 00:00:00
1396  8024         301               2012-02-22 00:00:00
757   8244         301               2013-09-20 00:00:00
1397  8024         301               2013-09-20 00:00:00
758   8244         301               2014-09-19 00:00:00
1398  8024         301               2014-09-19 00:00:00
523   8020         111429            2010-02-22 00:00:00
996   8031         111429            2010-02-22 00:00:00
524   8020         111429            2011-02-22 00:00:00
997   8031         111429            2011-02-22 00:00:00
859   274581       111560            2015-09-10 00:00:00
860   9996         111560            2015-09-10 00:00:00
861   9996         111560            2015-09-10 00:00:00

If you load rest of columns, it is clear these are dupes. We remove them manually, keeping rows with
lowest team_api_ids, so we delete:

    755, 756, 757, 758, 996, 997, 859, 861

and then we will remap the higher dupe team_api_ids:

    8244 -> 8024
    8031 -> 8020
    274581 -> 9996
*/
UPDATE Match SET home_team_api_id = 8024 WHERE home_team_api_id = 8244;
UPDATE Match SET home_team_api_id = 8020 WHERE home_team_api_id = 8031;
UPDATE Match SET home_team_api_id = 9996 WHERE home_team_api_id = 274581;
UPDATE Match SET away_team_api_id = 8024 WHERE away_team_api_id = 8244;
UPDATE Match SET away_team_api_id = 8020 WHERE away_team_api_id = 8031;
UPDATE Match SET away_team_api_id = 9996 WHERE away_team_api_id = 274581;

UPDATE Team_Attributes SET team_api_id = 8024 WHERE team_api_id = 8244;
UPDATE Team_Attributes SET team_api_id = 8020 WHERE team_api_id = 8031;
UPDATE Team_Attributes SET team_api_id = 9996 WHERE team_api_id = 274581;

DELETE FROM Team WHERE team_api_id IN (8244, 8031, 275581);

DELETE FROM Team_Attributes WHERE id IN (755, 756, 757, 758, 996, 997, 859, 861);


/*

Now low for dupes in Match

SELECT m.id, m.date, m.season, m.stage, m.home_team_api_id, m.away_team_api_id, t1.team_long_name as home_team, t2.team_long_name as away_team
FROM
    Match as m
    INNER JOIN Team as t1 ON
        m.home_team_api_id = t1.team_api_id
    INNER JOIN Team as t2 ON
        m.away_team_api_id = t2.team_api_id
WHERE home_team_api_id IN dupe_tids AND away_team_api_id IN dupe_tids
ORDER BY date, home_team_api_id, away_team_api_id, stage;

id     date                 season     stage  home_team_api_id  away_team_api_id  home_team      away_team
-----  -------------------  ---------  -----  ----------------  ----------------  -------------  -------------
15945  2008-09-26 00:00:00  2008/2009  7      8020              8020              Polonia Bytom  Polonia Bytom
15730  2008-10-25 00:00:00  2008/2009  10     8020              8024              Polonia Bytom  Widzew Łódź
15777  2008-11-21 00:00:00  2008/2009  15     8020              8024              Polonia Bytom  Widzew Łódź
15850  2009-04-18 00:00:00  2008/2009  24     8020              8020              Polonia Bytom  Polonia Bytom
15880  2009-05-09 00:00:00  2008/2009  27     8024              8020              Widzew Łódź    Polonia Bytom
15908  2009-05-30 00:00:00  2008/2009  30     8024              8020              Widzew Łódź    Polonia Bytom
16432  2010-10-01 00:00:00  2010/2011  8      8020              8024              Polonia Bytom  Widzew Łódź
16231  2010-11-06 00:00:00  2010/2011  12     8020              8020              Polonia Bytom  Polonia Bytom
16252  2010-11-27 00:00:00  2010/2011  15     8024              8020              Widzew Łódź    Polonia Bytom
16328  2011-04-23 00:00:00  2010/2011  23     8024              8020              Widzew Łódź    Polonia Bytom
16359  2011-05-13 00:00:00  2010/2011  27     8020              8020              Polonia Bytom  Polonia Bytom
16388  2011-05-29 00:00:00  2010/2011  30     8020              8024              Polonia Bytom  Widzew Łódź
16532  2011-08-05 00:00:00  2011/2012  2      8020              8024              Polonia Bytom  Widzew Łódź
16661  2011-09-17 00:00:00  2011/2012  7      8024              8020              Widzew Łódź    Polonia Bytom
16455  2011-10-17 00:00:00  2011/2012  10     8024              8024              Widzew Łódź    Widzew Łódź
16512  2011-12-10 00:00:00  2011/2012  17     8024              8020              Widzew Łódź    Polonia Bytom
16555  2012-03-17 00:00:00  2011/2012  22     8020              8024              Polonia Bytom  Widzew Łódź
16584  2012-04-09 00:00:00  2011/2012  25     8024              8024              Widzew Łódź    Widzew Łódź
16888  2012-09-24 00:00:00  2012/2013  5      8024              8020              Widzew Łódź    Polonia Bytom
16779  2013-03-28 00:00:00  2012/2013  20     8020              8024              Polonia Bytom  Widzew Łódź
17118  2013-08-10 00:00:00  2013/2014  4      8024              8020              Widzew Łódź    Polonia Bytom
17003  2013-12-03 00:00:00  2013/2014  19     8020              8024              Polonia Bytom  Widzew Łódź

Clearly, rows where home = away are garbage.

*/
DELETE FROM Match WHERE home_team_api_id = away_team_api_id;

-- since we now have used the team_fifa_api_id to identify dupes, there is no need for it in any table
-- only Team_Attributes and Team use it. `Team` is no problem, as it is not a key. The other one requires
-- workarounds... But first let's make `Team` into a sane table.
ALTER TABLE Team DROP COLUMN team_fifa_api_id;
ALTER TABLE Team RENAME COLUMN team_api_id to tid;
ALTER TABLE Team RENAME COLUMN team_long_name to name;
ALTER TABLE Team RENAME COLUMN team_short_name to code;
CREATE TABLE teams (
    tid INTEGER PRIMARY KEY,
    name TEXT,
    code VARCHAR(3)
);
INSERT INTO teams (tid, name, code) SELECT tid, name, code FROM Team;

CREATE TABLE IF NOT EXISTS team_attrs (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    tid INTEGER,
    date    TEXT,
    buildUpPlaySpeed    INTEGER,
    buildUpPlaySpeedClass    TEXT,
    buildUpPlayDribbling    INTEGER,
    buildUpPlayDribblingClass    TEXT,
    buildUpPlayPassing    INTEGER,
    buildUpPlayPassingClass    TEXT,
    buildUpPlayPositioningClass    TEXT,
    chanceCreationPassing    INTEGER,
    chanceCreationPassingClass    TEXT,
    chanceCreationCrossing    INTEGER,
    chanceCreationCrossingClass    TEXT,
    chanceCreationShooting    INTEGER,
    chanceCreationShootingClass    TEXT,
    chanceCreationPositioningClass    TEXT,
    defencePressure    INTEGER,
    defencePressureClass    TEXT,
    defenceAggression    INTEGER,
    defenceAggressionClass    TEXT,
    defenceTeamWidth    INTEGER,
    defenceTeamWidthClass    TEXT,
    defenceDefenderLineClass    TEXT,
    FOREIGN KEY (tid) REFERENCES teams(tid)
);
INSERT INTO team_attrs (
    id,
    tid,
    date,
    buildUpPlaySpeed,
    buildUpPlaySpeedClass,
    buildUpPlayDribbling,
    buildUpPlayDribblingClass,
    buildUpPlayPassing,
    buildUpPlayPassingClass,
    buildUpPlayPositioningClass,
    chanceCreationPassing,
    chanceCreationPassingClass,
    chanceCreationCrossing,
    chanceCreationCrossingClass,
    chanceCreationShooting,
    chanceCreationShootingClass,
    chanceCreationPositioningClass,
    defencePressure,
    defencePressureClass,
    defenceAggression,
    defenceAggressionClass,
    defenceTeamWidth,
    defenceTeamWidthClass,
    defenceDefenderLineClass
) SELECT
    id,
    team_api_id,
    date,
    buildUpPlaySpeed,
    buildUpPlaySpeedClass,
    buildUpPlayDribbling,
    buildUpPlayDribblingClass,
    buildUpPlayPassing,
    buildUpPlayPassingClass,
    buildUpPlayPositioningClass,
    chanceCreationPassing,
    chanceCreationPassingClass,
    chanceCreationCrossing,
    chanceCreationCrossingClass,
    chanceCreationShooting,
    chanceCreationShootingClass,
    chanceCreationPositioningClass,
    defencePressure,
    defencePressureClass,
    defenceAggression,
    defenceAggressionClass,
    defenceTeamWidth,
    defenceTeamWidthClass,
    defenceDefenderLineClass
FROM Team_Attributes;

ALTER TABLE team_attrs RENAME COLUMN buildUpPlaySpeed TO buildup_play_speed;
ALTER TABLE team_attrs RENAME COLUMN buildUpPlaySpeedClass TO buildup_play_speed_class;
ALTER TABLE team_attrs RENAME COLUMN buildUpPlayDribbling TO buildup_play_dribbling;
ALTER TABLE team_attrs RENAME COLUMN buildUpPlayDribblingClass TO buildup_play_dribbling_class;
ALTER TABLE team_attrs RENAME COLUMN buildUpPlayPassing TO buildup_play_passing;
ALTER TABLE team_attrs RENAME COLUMN buildUpPlayPassingClass TO buildup_play_passing_class;
ALTER TABLE team_attrs RENAME COLUMN buildUpPlayPositioningClass TO buildup_play_positioning_class;
ALTER TABLE team_attrs RENAME COLUMN chanceCreationPassing TO chance_creation_passing;
ALTER TABLE team_attrs RENAME COLUMN chanceCreationPassingClass TO chance_creation_passing_class;
ALTER TABLE team_attrs RENAME COLUMN chanceCreationCrossing TO chance_creation_crossing;
ALTER TABLE team_attrs RENAME COLUMN chanceCreationCrossingClass TO chance_creation_crossing_class;
ALTER TABLE team_attrs RENAME COLUMN chanceCreationShooting TO chance_creation_shooting;
ALTER TABLE team_attrs RENAME COLUMN chanceCreationShootingClass TO chance_creation_shooting_class;
ALTER TABLE team_attrs RENAME COLUMN chanceCreationPositioningClass TO chance_creation_positioning_class;
ALTER TABLE team_attrs RENAME COLUMN defencePressure TO defence_pressure;
ALTER TABLE team_attrs RENAME COLUMN defencePressureClass TO defence_pressure_class;
ALTER TABLE team_attrs RENAME COLUMN defenceAggression TO defence_aggression;
ALTER TABLE team_attrs RENAME COLUMN defenceAggressionClass TO defence_aggression_class;
ALTER TABLE team_attrs RENAME COLUMN defenceTeamWidth TO defence_team_width;
ALTER TABLE team_attrs RENAME COLUMN defenceTeamWidthClass TO defence_team_width_class;
ALTER TABLE team_attrs RENAME COLUMN defenceDefenderLineClass TO defence_defender_line_class;


/***************************************************************************************
* Now we de-dupe and fix player data
*
* Note: There seem to be no dupes based on fifa vs other API ids here, like in Team data.
* There are some very suspciously-similar Names and weights, but not enough we can confirm
* a dupe issue just looking at Player. In general, there do not seem to be dupes.
****************************************************************************************/
-- CREATE VIEW dupe_player_names as SELECT player_name from (SELECT *, COUNT(player_name) as CNT FROM Player GROUP BY player_name HAVING CNT > 1);
-- SELECT * FROM Player where player_name in dupe_player_names ORDER BY player_name, birthday;
-- SELECT *, COUNT(birthday) as bday_count FROM Player WHERE player_name in dupe_player_names GROUP BY birthday HAVING bday_count > 1 ORDER BY player_name, birthday;
-- SELECT PA.id, PA.player_api_id, player_name, birthday, date, height, weight FROM Player_Attributes PA INNER JOIN Player on PA.player_api_id = Player.player_api_id WHERE player_name in dupe_player_names ORDER BY PA.player_api_id, player_name, date;
-- SELECT PA.id, PA.player_api_id, player_name, birthday, date, height, weight, COUNT(date) as dupe_days FROM Player_Attributes PA INNER JOIN Player on PA.player_api_id = Player.player_api_id WHERE player_name in dupe_player_names GROUP BY PA.player_api_id ORDER BY PA.player_api_id, player_name, date;
-- SELECT PA.id, PA.player_api_id, player_name, birthday, date, height, weight, COUNT(date) as dupe_days FROM Player_Attributes PA INNER JOIN Player on PA.player_api_id = Player.player_api_id WHERE player_name in dupe_player_names GROUP BY PA.player_api_id, date ORDER BY dupe_days, PA.player_api_id, player_name, date DESC LIMIT 10;
-- SELECT PA.id, PA.player_api_id, player_name, birthday, date, height, weight, COUNT(date) as dupe_days FROM Player_Attributes PA INNER JOIN Player on PA.player_api_id = Player.player_api_id WHERE player_name in dupe_player_names GROUP BY PA.player_api_id, date ORDER BY dupe_days, PA.player_api_id, player_name, date ASC LIMIT 10;

CREATE TABLE IF NOT EXISTS players (
    pid INTEGER PRIMARY KEY,
    name TEXT,
    pfid INTEGER UNIQUE,
    birthday TEXT,
    height INTEGER,
    weight INTEGER
);
INSERT INTO players (pid, name, pfid, birthday, height, weight) SELECT player_api_id, player_name, player_fifa_api_id, birthday, height, weight FROM Player;

CREATE TABLE IF NOT EXISTS player_attrs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pid INTEGER,
    date TEXT,
    overall_rating INTEGER,
    potential INTEGER,
    preferred_foot TEXT,
    attacking_work_rate TEXT,
    defensive_work_rate TEXT,
    crossing INTEGER,
    finishing INTEGER,
    heading_accuracy INTEGER,
    short_passing INTEGER,
    volleys INTEGER,
    dribbling INTEGER,
    curve INTEGER,
    free_kick_accuracy INTEGER,
    long_passing INTEGER,
    ball_control INTEGER,
    acceleration INTEGER,
    sprint_speed INTEGER,
    agility INTEGER,
    reactions INTEGER,
    balance INTEGER,
    shot_power INTEGER,
    jumping INTEGER,
    stamina INTEGER,
    strength INTEGER,
    long_shots INTEGER,
    aggression INTEGER,
    interceptions INTEGER,
    positioning INTEGER,
    vision INTEGER,
    penalties INTEGER,
    marking INTEGER,
    standing_tackle INTEGER,
    sliding_tackle INTEGER,
    gk_diving INTEGER,
    gk_handling INTEGER,
    gk_kicking INTEGER,
    gk_positioning INTEGER,
    gk_reflexes INTEGER,
    FOREIGN KEY(pid) REFERENCES players(pid)
);
INSERT INTO player_attrs (
    id, pid, date, overall_rating, potential, preferred_foot, attacking_work_rate,
    defensive_work_rate, crossing, finishing, heading_accuracy, short_passing,
    volleys, dribbling, curve, free_kick_accuracy, long_passing, ball_control,
    acceleration, sprint_speed, agility, reactions, balance, shot_power, jumping,
    stamina, strength, long_shots, aggression, interceptions, positioning, vision,
    penalties, marking, standing_tackle, sliding_tackle, gk_diving, gk_handling,
    gk_kicking, gk_positioning, gk_reflexes
) SELECT
    id, player_api_id, date, overall_rating, potential, preferred_foot, attacking_work_rate,
    defensive_work_rate, crossing, finishing, heading_accuracy, short_passing,
    volleys, dribbling, curve, free_kick_accuracy, long_passing, ball_control,
    acceleration, sprint_speed, agility, reactions, balance, shot_power, jumping,
    stamina, strength, long_shots, aggression, interceptions, positioning, vision,
    penalties, marking, standing_tackle, sliding_tackle, gk_diving, gk_handling,
    gk_kicking, gk_positioning, gk_reflexes
FROM Player_Attributes;

/***************************************************************************************
* Now we must recreate the `matches` table with correct foreign keys
****************************************************************************************/

CREATE TABLE matches (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    country_id INTEGER,
    league_id INTEGER,
    season TEXT,
    stage INTEGER,
    date TEXT,
    match_id INTEGER UNIQUE,
    home_tid INTEGER,
    away_tid INTEGER,
    home_goal INTEGER,
    away_goal INTEGER,
    home_X1 INTEGER, home_X2 INTEGER, home_X3 INTEGER, home_X4 INTEGER, home_X5 INTEGER, home_X6 INTEGER,
    home_X7 INTEGER, home_X8 INTEGER, home_X9 INTEGER, home_X10 INTEGER, home_X11 INTEGER,
    away_X1 INTEGER, away_X2 INTEGER, away_X3 INTEGER, away_X4 INTEGER, away_X5 INTEGER, away_X6 INTEGER,
    away_X7 INTEGER, away_X8 INTEGER, away_X9 INTEGER, away_X10 INTEGER, away_X11 INTEGER,
    home_Y1 INTEGER, home_Y2 INTEGER, home_Y3 INTEGER, home_Y4 INTEGER, home_Y5 INTEGER, home_Y6 INTEGER,
    home_Y7 INTEGER, home_Y8 INTEGER, home_Y9 INTEGER, home_Y10 INTEGER, home_Y11 INTEGER,
    away_Y1 INTEGER, away_Y2 INTEGER, away_Y3 INTEGER, away_Y4 INTEGER, away_Y5 INTEGER, away_Y6 INTEGER,
    away_Y7 INTEGER, away_Y8 INTEGER, away_Y9 INTEGER, away_Y10 INTEGER, away_Y11 INTEGER,
    home_1 INTEGER, home_2 INTEGER, home_3 INTEGER, home_4 INTEGER, home_5 INTEGER, home_6 INTEGER,
    home_7 INTEGER, home_8 INTEGER, home_9 INTEGER, home_10 INTEGER, home_11 INTEGER,
    away_1 INTEGER, away_2 INTEGER, away_3 INTEGER, away_4 INTEGER, away_5 INTEGER, away_6 INTEGER,
    away_7 INTEGER, away_8 INTEGER, away_9 INTEGER, away_10 INTEGER, away_11 INTEGER,
    goal TEXT, shoton TEXT, shotoff TEXT, foulcommit TEXT, card TEXT, cross TEXT, corner TEXT, possession TEXT,
    B365H NUMERIC, B365D NUMERIC, B365A NUMERIC, BWH NUMERIC, BWD NUMERIC, BWA NUMERIC, IWH NUMERIC, IWD NUMERIC,
    IWA NUMERIC, LBH NUMERIC, LBD NUMERIC, LBA NUMERIC, PSH NUMERIC, PSD NUMERIC, PSA NUMERIC, WHH NUMERIC,
    WHD NUMERIC, WHA NUMERIC, SJH NUMERIC, SJD NUMERIC, SJA NUMERIC, VCH NUMERIC, VCD NUMERIC, VCA NUMERIC,
    GBH NUMERIC, GBD NUMERIC, GBA NUMERIC, BSH NUMERIC, BSD NUMERIC, BSA NUMERIC,
    FOREIGN KEY(country_id) REFERENCES countries(id),
    FOREIGN KEY(league_id) REFERENCES leagues(id),
    FOREIGN KEY(home_tid) REFERENCES teams(tid),
    FOREIGN KEY(away_tid) REFERENCES teams(tid),
    FOREIGN KEY(home_1)  REFERENCES players(pid),
    FOREIGN KEY(home_2)  REFERENCES players(pid),
    FOREIGN KEY(home_3)  REFERENCES players(pid),
    FOREIGN KEY(home_4)  REFERENCES players(pid),
    FOREIGN KEY(home_5)  REFERENCES players(pid),
    FOREIGN KEY(home_6)  REFERENCES players(pid),
    FOREIGN KEY(home_7)  REFERENCES players(pid),
    FOREIGN KEY(home_8)  REFERENCES players(pid),
    FOREIGN KEY(home_9)  REFERENCES players(pid),
    FOREIGN KEY(home_10) REFERENCES players(pid),
    FOREIGN KEY(home_11) REFERENCES players(pid),
    FOREIGN KEY(away_1)  REFERENCES players(pid),
    FOREIGN KEY(away_2)  REFERENCES players(pid),
    FOREIGN KEY(away_3)  REFERENCES players(pid),
    FOREIGN KEY(away_4)  REFERENCES players(pid),
    FOREIGN KEY(away_5)  REFERENCES players(pid),
    FOREIGN KEY(away_6)  REFERENCES players(pid),
    FOREIGN KEY(away_7)  REFERENCES players(pid),
    FOREIGN KEY(away_8)  REFERENCES players(pid),
    FOREIGN KEY(away_9)  REFERENCES players(pid),
    FOREIGN KEY(away_10) REFERENCES players(pid),
    FOREIGN KEY(away_11) REFERENCES players(pid)
);

INSERT INTO matches (
    id, country_id, league_id, season, stage, date, match_id,
    home_tid, away_tid, home_goal, away_goal,
    home_X1, home_X2, home_X3, home_X4, home_X5, home_X6,
    home_X7, home_X8, home_X9, home_X10, home_X11,
    away_X1, away_X2, away_X3, away_X4, away_X5, away_X6,
    away_X7, away_X8, away_X9, away_X10, away_X11,
    home_Y1, home_Y2, home_Y3, home_Y4, home_Y5, home_Y6,
    home_Y7, home_Y8, home_Y9, home_Y10, home_Y11,
    away_Y1, away_Y2, away_Y3, away_Y4, away_Y5, away_Y6,
    away_Y7, away_Y8, away_Y9, away_Y10, away_Y11,
    home_1, home_2, home_3, home_4, home_5, home_6,
    home_7, home_8, home_9, home_10, home_11,
    away_1, away_2, away_3, away_4, away_5, away_6,
    away_7, away_8, away_9, away_10, away_11,
    goal, shoton, shotoff, foulcommit, card, cross, corner, possession,
    B365H, B365D, B365A, BWH, BWD, BWA, IWH, IWD, IWA, LBH, LBD, LBA, PSH, PSD, PSA, WHH,
    WHD, WHA, SJH, SJD, SJA, VCH, VCD, VCA, GBH, GBD, GBA, BSH, BSD, BSA
) SELECT
    id, country_id, league_id, season, stage, date, match_api_id,
    home_team_api_id, away_team_api_id, home_team_goal, away_team_goal,
    home_player_X1, home_player_X2, home_player_X3, home_player_X4, home_player_X5, home_player_X6,
    home_player_X7, home_player_X8, home_player_X9, home_player_X10, home_player_X11,
    away_player_X1, away_player_X2, away_player_X3, away_player_X4, away_player_X5, away_player_X6,
    away_player_X7, away_player_X8, away_player_X9, away_player_X10, away_player_X11,
    home_player_Y1, home_player_Y2, home_player_Y3, home_player_Y4, home_player_Y5, home_player_Y6,
    home_player_Y7, home_player_Y8, home_player_Y9, home_player_Y10, home_player_Y11,
    away_player_Y1, away_player_Y2, away_player_Y3, away_player_Y4, away_player_Y5, away_player_Y6,
    away_player_Y7, away_player_Y8, away_player_Y9, away_player_Y10, away_player_Y11,
    home_player_1, home_player_2, home_player_3, home_player_4, home_player_5, home_player_6,
    home_player_7, home_player_8, home_player_9, home_player_10, home_player_11,
    away_player_1, away_player_2, away_player_3, away_player_4, away_player_5, away_player_6,
    away_player_7, away_player_8, away_player_9, away_player_10, away_player_11,
    goal, shoton, shotoff, foulcommit, card, cross, corner, possession,
    B365H, B365D, B365A, BWH, BWD, BWA, IWH, IWD, IWA, LBH, LBD, LBA, PSH, PSD, PSA, WHH,
    WHD, WHA, SJH, SJD, SJA, VCH, VCD, VCA, GBH, GBD, GBA, BSH, BSD, BSA
FROM Match
;

DROP TABLE dupe_tids;
DROP TABLE Team_Attributes;
DROP TABLE Player_Attributes;
DROP TABLE Player;
DROP TABLE Team;
DROP TABLE Match;
ALTER TABLE Country RENAME TO countries;
ALTER TABLE League RENAME TO leagues;
PRAGMA foreign_key_check;

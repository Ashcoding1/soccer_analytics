CREATE TABLE IF NOT EXISTS TA (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    team_api_id INTEGER,
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
    FOREIGN KEY (team_api_id) REFERENCES Team_Attributes(team_api_id)
);

CREATE TABLE IF NOT EXISTS PA (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    player_fifa_api_id    INTEGER,
    player_api_id    INTEGER,
    date    TEXT,
    overall_rating    INTEGER,
    potential    INTEGER,
    preferred_foot    TEXT,
    attacking_work_rate    TEXT,
    defensive_work_rate    TEXT,
    crossing    INTEGER,
    finishing    INTEGER,
    heading_accuracy    INTEGER,
    short_passing    INTEGER,
    volleys    INTEGER,
    dribbling    INTEGER,
    curve    INTEGER,
    free_kick_accuracy    INTEGER,
    long_passing    INTEGER,
    ball_control    INTEGER,
    acceleration    INTEGER,
    sprint_speed    INTEGER,
    agility    INTEGER,
    reactions    INTEGER,
    balance    INTEGER,
    shot_power    INTEGER,
    jumping    INTEGER,
    stamina    INTEGER,
    strength    INTEGER,
    long_shots    INTEGER,
    aggression    INTEGER,
    interceptions    INTEGER,
    positioning    INTEGER,
    vision    INTEGER,
    penalties    INTEGER,
    marking    INTEGER,
    standing_tackle    INTEGER,
    sliding_tackle    INTEGER,
    gk_diving    INTEGER,
    gk_handling    INTEGER,
    gk_kicking    INTEGER,
    gk_positioning    INTEGER,
    gk_reflexes    INTEGER,
    FOREIGN KEY(player_api_id) REFERENCES Player(player_api_id)
);

DROP TABLE Team_Attributes;
DROP TABLE Player_Attributes;
ALTER TABLE TA RENAME TO team_attrs;
ALTER TABLE PA RENAME TO player_attrs;
ALTER TABLE Country RENAME TO countries;
ALTER TABLE League RENAME TO leagues;
ALTER TABLE Match RENAME TO matches;
ALTER TABLE Player RENAME TO players;
ALTER TABLE Team RENAME TO teams;
PRAGMA foreign_key_check;

CREATE TABLE IF NOT EXISTS "team_attrs" (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    team_api_id INTEGER,
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
    FOREIGN KEY (team_api_id) REFERENCES Team_Attributes(team_api_id)
);

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

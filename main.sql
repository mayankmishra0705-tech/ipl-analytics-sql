-- ============================================================================
-- PROJECT: IPL Analytics Portfolio Project
-- FILE: 01_SCHEMA.sql
-- PURPOSE: Defines the database structure, relationships, and constraints.
-- ARCHITECTURE: Relational schema optimized strictly for SQLite3
-- ============================================================================

-- Enable Foreign Key support in SQLite
PRAGMA foreign_keys = ON;

-- 1. CLEAN REBUILD DROP SYSTEM
DROP TABLE IF EXISTS bowling_stats;
DROP TABLE IF EXISTS batting_stats;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS team_rosters;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS teams;

-- ============================================================================
-- 2. TABLE DEFINITIONS
-- ============================================================================

-- Table A: TEAMS (Core franchise details)
CREATE TABLE teams (
    team_id INTEGER PRIMARY KEY, -- In SQLite, this automatically auto-increments
    team_name TEXT NOT NULL UNIQUE,
    short_name TEXT NOT NULL UNIQUE, 
    home_city TEXT NOT NULL,
    owner TEXT
);

-- Table B: PLAYERS (Master registry of athletes)
CREATE TABLE players (
    player_id INTEGER PRIMARY KEY,
    player_name TEXT NOT NULL,
    country TEXT NOT NULL DEFAULT 'India',
    role TEXT NOT NULL CHECK(role IN ('Batsman', 'Bowler', 'All-Rounder', 'Wicketkeeper-Batsman')),
    batting_style TEXT NOT NULL CHECK(batting_style IN ('Right-hand bat', 'Left-hand bat')),
    bowling_style TEXT DEFAULT 'None'
);

-- Table C: TEAM_ROSTERS (Tracks player-team-salary changes per season)
CREATE TABLE team_rosters (
    roster_id INTEGER PRIMARY KEY,
    team_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    season INTEGER NOT NULL, 
    salary_lakhs REAL NOT NULL, 
    UNIQUE (player_id, season), 
    FOREIGN KEY (team_id) REFERENCES teams (team_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (player_id) REFERENCES players (player_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table D: MATCHES (Fixtures, venues, and match results)
CREATE TABLE matches (
    match_id INTEGER PRIMARY KEY,
    season INTEGER NOT NULL,
    match_date TEXT NOT NULL, 
    team_1_id INTEGER NOT NULL,
    team_2_id INTEGER NOT NULL,
    winner_id INTEGER DEFAULT NULL, 
    venue TEXT NOT NULL,
    toss_winner_id INTEGER NOT NULL,
    toss_decision TEXT NOT NULL CHECK(toss_decision IN ('Bat', 'Field')),
    FOREIGN KEY (team_1_id) REFERENCES teams (team_id),
    FOREIGN KEY (team_2_id) REFERENCES teams (team_id),
    FOREIGN KEY (winner_id) REFERENCES teams (team_id),
    FOREIGN KEY (toss_winner_id) REFERENCES teams (team_id),
    CHECK (team_1_id <> team_2_id)
);

-- Table E: BATTING_STATS (Granular per-match batting performances)
CREATE TABLE batting_stats (
    stat_id INTEGER PRIMARY KEY,
    match_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    runs_scored INTEGER NOT NULL DEFAULT 0 CHECK(runs_scored >= 0),
    balls_faced INTEGER NOT NULL DEFAULT 0 CHECK(balls_faced >= 0),
    fours INTEGER NOT NULL DEFAULT 0,
    sixes INTEGER NOT NULL DEFAULT 0,
    dismissal_type TEXT DEFAULT 'Not Out' CHECK(dismissal_type IN ('Not Out', 'Bowled', 'Caught', 'LBW', 'Run Out', 'Stumped', 'Hit Wicket')),
    UNIQUE (match_id, player_id),
    FOREIGN KEY (match_id) REFERENCES matches (match_id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES players (player_id) ON DELETE RESTRICTP
);

-- Table F: BOWLING_STATS (Granular per-match bowling performances)
CREATE TABLE bowling_stats (
    stat_id INTEGER PRIMARY KEY,
    match_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    overs_bowled REAL NOT NULL, 
    runs_conceded INTEGER NOT NULL DEFAULT 0 CHECK(runs_conceded >= 0),
    wickets_taken INTEGER NOT NULL DEFAULT 0 CHECK(wickets_taken >= 0),
    dot_balls INTEGER NOT NULL DEFAULT 0,
    UNIQUE (match_id, player_id),
    FOREIGN KEY (match_id) REFERENCES matches (match_id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES players (player_id) ON DELETE RESTRICT
);

# 🏏 IPL Analytics & Performance Tuning Platform

A production-ready SQLite database architecture built to analyze Indian Premier League (IPL) match statistics, evaluate player auction valuation, and track team momentum. This project explicitly demonstrates proficiency in relational database design (3NF), advanced analytical window functions, and query performance optimization.

## 📁 Repository Structure
* **`01_SCHEMA.sql`**: Relational database structure mapping 6 highly normalized tables with explicit constraints.
* **`02_SAMPLE_DATA.sql`**: Realistic player metrics, auction values, and match scorecards for verification.
* **`03_ADVANCED_QUERIES.sql`**: 7 advanced analytical scripts solving complex data calculations (CTEs, Gaps-and-Islands, percentiles).
* **`04_INDEXES.sql`**: Secondary composite indexing strategies and query plan audit benchmarks.
* ## 📁 Repository Structure
* **`main.sql`**: Relational database structure mapping 6 highly normalized tables, realistic player data metrics, and core optimization indexes combined into a single, seamless script.
* **`README.md`**: Technical documentation, architecture overview, and project execution guide.

---

## 📊 Database Architecture (3NF)
The schema cleanly handles multi-season data, player transitions, and granular match performances without data redundancy:
* **`teams`** & **`players`**: Core master registries.
* **`team_rosters`**: Tracks historical player shifts and seasonal salaries.
* **`matches`**: Fixture tracking with outcome, toss, and venue details.
* **`batting_stats`** & **`bowling_stats`**: Granular, single-row performance metrics per player per match.

---

## ⚡ Showcase Queries & SQL Techniques
This platform implements complex data manipulations, including:
1. **Rolling Averages & Rank Tracking**: Uses `DENSE_RANK()`, `LAG()`, and `ROWS BETWEEN 2 PRECEDING` to evaluate true player form.
2. **Value-for-Money (VFM) Index**: Combines multi-stage CTEs with `PERCENT_RANK()` to weigh historical auction salaries against real performance impact points.
3. **Streak Detection**: Leverages conditional window metrics to identify momentum shifts and win/loss patterns.
4. **Weighted Efficiency Models**: Employs complex mathematical custom sorting (e.g., scoring custom metrics on dot balls and wickets vs. runs conceded).

---

## 🚀 Performance Optimization Strategy
To ensure quick execution speeds, the database architecture avoids full-table linear scanning by applying targeted composite indexes.

### Query Plan Validation Example:
Before creating indexes, aggregations required a heavy linear sweep (`SCAN TABLE`). By implementing the composite structure in `04_INDEXES.sql`:

```text
SEARCH TABLE batting_stats USING INDEX idx_batting_player_match (player_id=?)

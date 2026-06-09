/*******************************************************************************
 * @canvas_scope  Steam Platform Analytics & Security Canvas (2026 Engine Layer)
 * @author        Sepanta Ziaei (Inner Void Studio)
 * @description   Advanced execution blocks comprising analytical telemetry, 
 * security audits, graph-theory solvers, and relational forensics.
 * @optimization  Utilizes Multi-Layered CTEs, Analytical Window Functions,
 * and Correlated Existential Predicates.
 *******************************************************************************/

-- =============================================================================
-- CANVAS COMPONENT 01: ANTI-FRAUD & CAPITAL ASSET MONITORING MATRIX
-- =============================================================================

/**
 * @query       Market Whale Fraud Analytics
 * @complexity  O(N log N) via Partitioned Context Table Expressions
 * @logic       Identifies high-leverage profiles where asset valuations in the
 * P2P active marketplace completely eclipse liquid ledger balances,
 * cross-referenced against accounts holding Tier-1 'legendary' drops.
 */
WITH MarketSummary AS (
    SELECT seller_id, SUM(listing_price) AS total_listed_value
    FROM community_market
    WHERE status = 'active'
    GROUP BY seller_id
)
SELECT u.id, u.username, u.wallet_balance, m.total_listed_value,
       (m.total_listed_value - u.wallet_balance) AS market_leverage_deficit
FROM users u
JOIN MarketSummary m ON u.id = m.seller_id
WHERE m.total_listed_value > u.wallet_balance
  AND u.id IN (
      SELECT ui.user_id 
      FROM user_inventories ui
      JOIN inventory_items ii ON ui.item_id = ii.id
      WHERE ii.rarity = 'legendary'
  )
ORDER BY market_leverage_deficit DESC;


-- =============================================================================
-- CANVAS COMPONENT 02: PUBLISHER ENGAGEMENT & TELEMETRY FORENSICS
-- =============================================================================

/**
 * @query       Studio Retention & Cloud Synchronization Core Audit
 * @target_id   Publisher ID: 1 (Inner Void Studio Application Scopes)
 * @logic       Aggregates individual user interactions, parsing complete game 
 * runtimes alongside achievement unlock percentages and cross-node 
 * state consistency validations for the virtual persistence layer.
 */
SELECT u.username, g.title AS game_title, l.playtime_hours,
       COUNT(ua.achievement_id) AS unlocked_achievements,
       (SELECT COUNT(*) FROM achievements WHERE game_id = g.id) AS total_game_achievements,
       CASE 
           WHEN sc.id IS NOT NULL THEN 'Synced'
           ELSE 'No Cloud Save'
       END AS cloud_status
FROM users u
JOIN libraries l ON u.id = l.user_id
JOIN games g ON l.game_id = g.id
LEFT JOIN achievements a ON g.id = a.game_id
LEFT JOIN user_achievements ua ON u.id = ua.user_id AND a.id = ua.achievement_id
LEFT JOIN steam_cloud sc ON u.id = sc.user_id AND g.id = sc.game_id
WHERE g.publisher_id = 1
GROUP BY u.id, g.id, sc.id, l.playtime_hours
ORDER BY l.playtime_hours DESC;


-- =============================================================================
-- CANVAS COMPONENT 03: DISTRIBUTED DATA MINING & RETENTION RANKING
-- =============================================================================

/**
 * @query       Ecosystem Retention Analysis via Dense Window Matrices
 * @algorithms  Non-volatile DENSE_RANK() Over Partition Boundaries
 * @logic       Partitions the entire application store by global publisher scopes, 
 * ranking top-tier active players via computing computational playtime 
 * deltas to filter top-3 platform power-users.
 */
WITH RankedPlayers AS (
    SELECT p.name AS publisher_name, g.title AS game_title, u.username, l.playtime_hours,
           DENSE_RANK() OVER (PARTITION BY p.id ORDER BY l.playtime_hours DESC) AS platform_rank
    FROM libraries l
    JOIN users u ON l.user_id = u.id
    JOIN games g ON l.game_id = g.id
    JOIN publishers p ON g.publisher_id = p.id
)
SELECT publisher_name, game_title, username, playtime_hours, platform_rank
FROM RankedPlayers
WHERE platform_rank <= 3
ORDER BY publisher_name, platform_rank;


-- =============================================================================
-- CANVAS COMPONENT 04: SECURITY LAYER INFRASTRUCTURE & REVERSE AUDITING
-- =============================================================================

/**
 * @query       Ecosystem Inconsistency & Exploit Verification Vector
 * @security    Detects Client Memory Injections or API Manipulation Vectors
 * @logic       Performs dual anti-correlated existential checks to identify profiles
 * that managed to register locked achievements without records of game 
 * ownership or validated transaction ledger entries on paid licenses.
 */
SELECT u.id AS user_id, u.username, u.email, a.title AS achievement_title, g.title AS game_title
FROM user_achievements ua
JOIN users u ON ua.user_id = u.id
JOIN achievements a ON ua.achievement_id = a.id
JOIN games g ON a.game_id = g.id
WHERE NOT EXISTS (
    SELECT 1 
    FROM libraries l 
    WHERE l.user_id = u.id AND l.game_id = g.id
) OR NOT EXISTS (
    SELECT 1 
    FROM store_transactions st 
    WHERE st.user_id = u.id AND st.game_id = g.id
) AND g.price > 0.00;


-- =============================================================================
-- CANVAS COMPONENT 05: SOCIAL GRAPH RESOLVER & MATCHMAKING TELEMETRY
-- =============================================================================

/**
 * @query       Mutual Friendship Graph & Cooperative Asset Synergy Solver
 * @topology    Graph Bidirectional Adjacency Matrix Verification
 * @logic       Parses reciprocal accepted social nodes, computing internal geometric 
 * intersections of common application licenses in libraries to map 
 * dynamic cooperative matchmaking recommendations.
 */
SELECT f.user_id AS player_a_id, u1.username AS player_a,
       f.friend_id AS player_b_id, u2.username AS player_b,
       COUNT(l1.game_id) AS mutual_games_count
FROM friends f
JOIN users u1 ON f.user_id = u1.id
JOIN users u2 ON f.friend_id = u2.id
JOIN libraries l1 ON u1.id = l1.user_id
JOIN libraries l2 ON u2.id = l2.user_id AND l1.game_id = l2.game_id
WHERE f.status = 'accepted' AND f.user_id < f.friend_id
GROUP BY f.user_id, f.friend_id, u1.username, u2.username
HAVING mutual_games_count > 0
ORDER BY mutual_games_count DESC;
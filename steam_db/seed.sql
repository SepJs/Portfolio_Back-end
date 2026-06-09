/*******************************************************************************
 * @data_seed    Comprehensive Production Mock Data (2026 Simulation Ecosystem)
 * @description  Inserts multi-layered interconnected relational records for auditing.
 *******************************************************************************/

-- =============================================================================
-- 1. POPULATING USERS (including unique community profiles & balances)
-- =============================================================================
INSERT INTO users (username, email, password_hash, wallet_balance, status) VALUES
('sepanta_ivs', 'sepanta@innervoid.studio', '$argon2id$v=19$m=65536,t=3,p=4$securehash_owner', 750.50, 'ingame'),
('gamer_pro_99', 'pro_gamer@gmail.com', '$bcrypt$v=12$rounds=10$hash_gamer', 45.25, 'online'),
('cyber_hunter', 'hunter@parrot.os', '$argon2id$v=19$m=65536$bounty_hunter_hash', 1200.00, 'away'),
('cozy_cat', 'whiskers@cozygames.com', '$bcrypt$v=12$cozy_hash_value', 12.00, 'offline'),
('matin_narrative', 'matin@innervoid.studio', '$bcrypt$v=12$matin_secure_pass', 150.00, 'ingame'),
('amir_coder', 'amir@innervoid.studio', '$argon2id$v=19$amir_prog_hash', 85.00, 'online'),
('aryan_ue', 'aryan@innervoid.studio', '$bcrypt$v=12$aryan_3d_design', 320.40, 'online'),
('aron_graphics', 'aron@innervoid.studio', '$argon2id$v=19$aron_art_hash', 5.50, 'offline'),
('valve_tester', 'tester@valvesoftware.com', '$bcrypt$v=12$valve_test_acc', 0.00, 'online'),
('shadow_walker', 'shadow@protonmail.com', '$argon2id$v=19$shadow_crypto_fan', 450.00, 'away');

-- =============================================================================
-- 2. POPULATING SOCIAL GRAPH (Friends Matrix)
-- =============================================================================
INSERT INTO friends (user_id, friend_id, status) VALUES
(1, 5, 'accepted'), -- sepanta & matin
(1, 6, 'accepted'), -- sepanta & amir
(1, 7, 'accepted'), -- sepanta & aryan
(1, 8, 'accepted'), -- sepanta & aron
(2, 3, 'accepted'),
(3, 1, 'accepted'), -- cyber_hunter & sepanta
(5, 6, 'accepted'),
(2, 10, 'pending'),
(4, 2, 'accepted'),
(3, 10, 'blocked');

-- =============================================================================
-- 3. POPULATING PUBLISHERS
-- =============================================================================
INSERT INTO publishers (name, verified, website) VALUES
('Inner Void Studio', TRUE, 'https://innervoid.studio'),
('Valve', TRUE, 'https://valvesoftware.com'),
('FromSoftware', TRUE, 'https://fromsoftware.jp'),
('CD Projekt Red', TRUE, 'https://cdprojektred.com'),
('IndieHeaven Games', FALSE, 'https://indieheaven-games.dev');

-- =============================================================================
-- 4. POPULATING GAMES (Catalog 2026)
-- =============================================================================
INSERT INTO games (publisher_id, title, price, discount_percent, is_early_access) VALUES
(1, 'Future Timelines', 29.99, 10, FALSE),  -- IVS flagship
(1, 'Cozy Whiskers', 14.99, 0, TRUE),      -- IVS cozy fishing game
(1, 'Mental', 19.99, 20, FALSE),           -- IVS 2D/3D hybrid
(2, 'Half-Life 3', 69.99, 0, FALSE),        -- The 2026 myth
(2, 'Counter-Strike 3', 0.00, 0, FALSE),    -- Free to Play
(3, 'Elden Ring 2', 59.99, 0, FALSE),
(4, 'Cyberpunk 2077: Remastered', 39.99, 50, FALSE),
(5, 'Pixel Dungeon Adventure', 4.99, 0, FALSE);

-- =============================================================================
-- 5. POPULATING USER LIBRARIES (Ownership & Telemetry)
-- =============================================================================
INSERT INTO libraries (user_id, game_id, playtime_hours, last_played) VALUES
(1, 1, 450.5, '2026-06-09 22:00:00'), -- Owner playing Future Timelines
(1, 2, 120.2, '2026-06-08 18:30:00'),
(2, 4, 12.4, '2026-06-01 12:00:00'),
(3, 1, 88.0, '2026-06-09 15:45:00'),  -- Cyber_hunter playing IVS game
(3, 5, 2300.1, '2026-06-09 23:10:00'),-- CS3 sweat lord
(5, 1, 310.0, '2026-06-09 21:00:00'),
(6, 1, 412.3, '2026-06-09 21:45:00'),
(7, 3, 95.6, '2026-06-07 14:20:00'),
(10, 6, 140.0, '2026-05-20 09:00:00'),
(2, 7, 4.2, '2026-01-15 16:00:00');

-- =============================================================================
-- 6. POPULATING GAME ACHIEVEMENTS
-- =============================================================================
INSERT INTO achievements (game_id, title, description, is_hidden) VALUES
(1, 'Timeline Fixer', 'Successfully repaired the core timeline fracture.', FALSE),
(1, 'Paradox Survivor', 'Survive the temporal loop anomaly.', TRUE),
(2, 'Master Angler', 'Catch the legendary Golden Catfish.', FALSE),
(3, 'Into the Deep', 'Dive past 300 meters in the hybrid abyss.', FALSE),
(4, 'Unforeseen Consequences', 'Wake up and smell the ashes.', FALSE),
(5, 'Global Elite 2026', 'Reach the maximum rank in competitive matchmaking.', FALSE);

-- =============================================================================
-- 7. POPULATING USER ACHIEVEMENTS MATRIX
-- =============================================================================
INSERT INTO user_achievements (user_id, achievement_id) VALUES
(1, 1), -- sepanta unlocked timeline fixer
(1, 2), -- sepanta unlocked hidden paradox survivor
(3, 1),
(3, 6), -- cyber_hunter is global elite
(5, 1),
(6, 1);

-- =============================================================================
-- 8. POPULATING STEAM CLOUD META-LOGS
-- =============================================================================
INSERT INTO steam_cloud (user_id, game_id, file_name, file_size_bytes) VALUES
(1, 1, 'save_slot_01.dat', 4589100),
(1, 2, 'cozy_fish_profile.json', 1048576),
(3, 1, 'hunter_story_state.bin', 2104580),
(3, 5, 'cs3_config.cfg', 15240),
(5, 1, 'matin_script_test.dat', 6891200);

-- =============================================================================
-- 9. POPULATING STORE TRANSACTIONS (The Ledger)
-- =============================================================================
INSERT INTO store_transactions (user_id, game_id, amount_paid, payment_method) VALUES
(2, 4, 69.99, 'credit_card'),
(3, 1, 26.99, 'crypto'),     -- Bought Future Timelines with crypto (price minus 10%)
(5, 1, 26.99, 'wallet'),
(6, 1, 26.99, 'wallet'),
(10, 6, 59.99, 'credit_card');

-- =============================================================================
-- 10. POPULATING INVENTORY MARKETPLACE ITEMS
-- =============================================================================
INSERT INTO inventory_items (game_id, item_name, rarity) VALUES
(5, 'M4A4 | Void Spectre', 'legendary'),
(5, 'Karambit | Cyber Hunter', 'legendary'),
(1, 'Chrono Core Charm', 'rare'),
(2, 'Neon Bobber', 'common'),
(5, 'Sticker | Inner Void 2026', 'rare');

-- =============================================================================
-- 11. POPULATING USER INVENTORIES
-- =============================================================================
INSERT INTO user_inventories (user_id, item_id) VALUES
(1, 5), -- sepanta owns IVS sticker in CS3
(3, 2), -- cyber_hunter owns Karambit
(3, 1), -- cyber_hunter owns Void Spectre
(2, 4), -- gamer_pro owns Neon Bobber
(10, 5);

-- =============================================================================
-- 12. POPULATING COMMUNITY MARKET LISTINGS
-- =============================================================================
INSERT INTO community_market (seller_id, item_id, listing_price, status) VALUES
(3, 1, 450.00, 'active'),  -- cyber_hunter selling M4A4 Void Spectre
(10, 5, 25.50, 'active'),   -- shadow_walker selling IVS sticker
(2, 4, 1.20, 'sold');       -- Sold the common bobber
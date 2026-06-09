/*******************************************************************************
 * @project     Steam Platform Core Database Engine (2026 Production Architecture)
 * @author      Sepanta Ziaei (Inner Void Studio)
 * @description Enterprise-grade relational schema designed for modern game 
 * distribution, community marketplaces, and cloud synchronization.
 * @target_db   MySQL 8.0+ / MariaDB 10.5+
 * @license     MIT License
 *******************************************************************************/

-- =============================================================================
-- SECTION 1: IDENTITY & SOCIAL INFRASTRUCTURE
-- =============================================================================

/**
 * @table users
 * @description Core entity storing user credentials, financial balance, and realtime status.
 * @security Password hashes must utilize Argon2id or bcrypt prior to DML execution.
 */
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(64) UNIQUE NOT NULL,
    email VARCHAR(64) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Secure hash storage (Enterprise-grade)
    wallet_balance DECIMAL(6,2) DEFAULT 0.00, -- Exact numeric type for auditing
    status ENUM('online', 'offline', 'away', 'ingame') DEFAULT 'offline',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/**
 * @table friends
 * @description Resolves many-to-many relationship between users for social graphs.
 * @index Composite Primary Key optimization for fast social query execution paths.
 */
CREATE TABLE friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status ENUM('pending', 'accepted', 'blocked') DEFAULT 'pending',
    established_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =============================================================================
-- SECTION 2: ECOSYSTEM & STOREFRONT CATALOG
-- =============================================================================

/**
 * @table publishers
 * @description Entity representing game studios and distribution companies.
 */
CREATE TABLE publishers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(64) UNIQUE NOT NULL,
    verified BOOLEAN NOT NULL DEFAULT FALSE, -- Trust metric for secure store publishing
    website VARCHAR(255) UNIQUE
);

/**
 * @table games
 * @description Catalog table mapping software products to their respective publishers.
 * @constraint chk_discount Enforces business logic threshold for global sales event parameters.
 */
CREATE TABLE games (
    id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    price DECIMAL(6,2) DEFAULT 0.00,
    discount_percent INT DEFAULT 0,
    release_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_early_access BOOLEAN DEFAULT FALSE,
    
    FOREIGN KEY (publisher_id) REFERENCES publishers(id),
    CONSTRAINT chk_discount CHECK (discount_percent BETWEEN 0 AND 100)
);

/**
 * @table libraries
 * @description Intermediary junction tracking user game ownership, metrics, and application runtimes.
 */
CREATE TABLE libraries (
    user_id INT NOT NULL,
    game_id INT NOT NULL,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    playtime_hours DECIMAL(6,1) DEFAULT 0.0, -- Precise telemetry scaling for user engagement
    last_played TIMESTAMP NULL,
    
    PRIMARY KEY (user_id, game_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

-- =============================================================================
-- SECTION 3: IN-GAME METRICS & PERSISTENCE LAYER
-- =============================================================================

/**
 * @table achievements
 * @description Gamification blueprints linked directly to individual application scopes.
 */
CREATE TABLE achievements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    is_hidden BOOLEAN DEFAULT FALSE, -- Prevents narrative spoilers via API data leakage
    
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

/**
 * @table user_achievements
 * @description Log table tracking user validation milestones and security timestamps.
 */
CREATE TABLE user_achievements (
    user_id INT NOT NULL,
    achievement_id INT NOT NULL,
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (user_id, achievement_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE
);

/**
 * @table steam_cloud
 * @description Encapsulates cloud virtualization file tracking metadata for dynamic client syncs.
 * @constraint uq_user_game_cloud Mitigates concurrent race conditions during local runtime saving.
 */
CREATE TABLE steam_cloud (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    game_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_size_bytes BIGINT NOT NULL, -- Allocated for massive high-capacity open-world binary blobs
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    CONSTRAINT uq_user_game_cloud UNIQUE (user_id, game_id)
);

-- =============================================================================
-- SECTION 4: ECONOMY & TRANSACTION LAYER
-- =============================================================================

/**
 * @table store_transactions
 * @description Ledger accounting for raw primary market fiat/crypto software purchases.
 */
CREATE TABLE store_transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    game_id INT NOT NULL,
    amount_paid DECIMAL(6,2) NOT NULL,
    payment_method ENUM('wallet', 'credit_card', 'crypto') NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (game_id) REFERENCES games(id),
    CONSTRAINT uq_user_game_tx UNIQUE (user_id, game_id)
);

/**
 * @table inventory_items
 * @description Global metadata reference matrix for virtual cosmetic drop mechanics.
 */
CREATE TABLE inventory_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT NOT NULL,
    item_name VARCHAR(150) NOT NULL,
    rarity ENUM('common', 'rare', 'legendary') DEFAULT 'common',
    
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

/**
 * @table user_inventories
 * @description Distributed warehouse mappings linking asset IDs to dynamic client inventories.
 */
CREATE TABLE user_inventories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    item_id INT NOT NULL,
    acquired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES inventory_items(id) ON DELETE CASCADE,
    CONSTRAINT uq_user_item UNIQUE (user_id, item_id)
);

/**
 * @table community_market
 * @description Peer-to-peer real-time digital asset trading marketplace architecture.
 * @security Transaction isolation checks are heavily advised on this table to block race exploits.
 */
CREATE TABLE community_market (
    id INT PRIMARY KEY AUTO_INCREMENT,
    seller_id INT NOT NULL,
    item_id INT NOT NULL,
    listing_price DECIMAL(8,2) NOT NULL,
    status ENUM('active', 'sold', 'canceled') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES inventory_items(id) ON DELETE CASCADE,
    CONSTRAINT uq_seller_item UNIQUE (seller_id, item_id)
);
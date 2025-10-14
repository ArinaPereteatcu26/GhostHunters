-- ========================================
-- Ghost AI Service PostgreSQL Setup Script
-- Creates the ghost_states table (if missing)
-- and populates it only if empty
-- ========================================

-- CREATE DATABASE ghostai_db;
-- \c ghostai_db;
-- ------------------
-- 1️⃣ Create Table
-- ------------------
CREATE TABLE IF NOT EXISTS ghost_states (
                                            id SERIAL PRIMARY KEY,
                                            lobby_id INT NOT NULL,
                                            current_state VARCHAR(50) NOT NULL DEFAULT 'HIDING',
    target_user_id INT,
    last_update TIMESTAMP DEFAULT NOW(),
    current_room_id INT
    );

-- ------------------
-- 2️⃣ Populate Only If Empty
-- ------------------
DO
$$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ghost_states) THEN
        INSERT INTO ghost_states (lobby_id, current_state, target_user_id, last_update, current_room_id)
        VALUES
            (1, 'HIDING', 2, NOW(), 101),
            (1, 'STALKING', 3, NOW(), 102),
            (2, 'ATTACKING', 1, NOW(), 205);

        RAISE NOTICE '✅ ghost_states table was empty. Seed data inserted.';
ELSE
        RAISE NOTICE 'ℹ️ ghost_states table already contains data. Skipping seed.';
END IF;
END
$$;

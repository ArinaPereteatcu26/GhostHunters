CREATE DATABASE users_db;
\c users_db;

CREATE TABLE users (
                       id SERIAL PRIMARY KEY,
                       email VARCHAR(255) NOT NULL UNIQUE,
                       username VARCHAR(100) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       level INT DEFAULT 1 CHECK (level >= 1),
                       currency NUMERIC(18, 2) DEFAULT 0.00 CHECK (currency >= 0),
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);

-- =========================================
-- FRIENDSHIPS TABLE
-- =========================================
CREATE TABLE friends (
                         id SERIAL PRIMARY KEY,
                         requester_id INT NOT NULL,
                         receiver_id INT NOT NULL,
                         status INT DEFAULT 0 CHECK (status IN (0, 1, 2, 3)),
    -- 0 = Pending, 1 = Accepted, 2 = Declined, 3 = Blocked
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Foreign key constraints
                         CONSTRAINT fk_friends_requester
                             FOREIGN KEY (requester_id)
                                 REFERENCES users(id)
                                 ON DELETE CASCADE,

                         CONSTRAINT fk_friends_receiver
                             FOREIGN KEY (receiver_id)
                                 REFERENCES users(id)
                                 ON DELETE CASCADE,

    -- Prevent self-friendship
                         CONSTRAINT chk_no_self_friendship
                             CHECK (requester_id != receiver_id),

    -- Prevent duplicate friendships (requester → receiver)
    CONSTRAINT uq_friendship_pair
        UNIQUE (requester_id, receiver_id)
);

-- Create indexes for performance
CREATE INDEX idx_friends_requester ON friends(requester_id);
CREATE INDEX idx_friends_receiver ON friends(receiver_id);
CREATE INDEX idx_friends_status ON friends(status);

-- =========================================
-- POPULATE SAMPLE DATA
-- =========================================
DO $$
DECLARE
user_count INTEGER;
    friendship_count INTEGER;
BEGIN
    -- Check if users table is empty
SELECT COUNT(*) INTO user_count FROM users;

IF user_count = 0 THEN
        INSERT INTO users (email, username, password, level, currency) VALUES
            ('max.power@example.com', 'max_power', '$2a$11$examplehash1234567890', 5, 1500.00),
            ('lisa.ray@example.com', 'lisa_ray', '$2a$11$examplehash2345678901', 3, 750.50),
            ('pro.gamer@example.com', 'pro_gamer', '$2a$11$examplehash3456789012', 8, 2500.75),
            ('sophia.queen@example.com', 'sophia_q', '$2a$11$examplehash4567890123', 2, 300.25),
            ('john.doe@example.com', 'john_doe', '$2a$11$examplehash5678901234', 4, 950.00),
            ('jane.smith@example.com', 'jane_smith', '$2a$11$examplehash6789012345', 6, 1800.30);
        
        RAISE NOTICE '✅ Users table populated with % records', (SELECT COUNT(*) FROM users);
ELSE
        RAISE NOTICE '⚠️ Users table already contains % records', user_count;
END IF;

    -- Check if friendships table is empty
SELECT COUNT(*) INTO friendship_count FROM friends;

IF friendship_count = 0 THEN
        INSERT INTO friends (requester_id, receiver_id, status) VALUES
            (1, 2, 1),  -- max_power → lisa_ray (Accepted)
            (1, 3, 1),  -- max_power → pro_gamer (Accepted)
            (2, 4, 1),  -- lisa_ray → sophia_q (Accepted)
            (3, 4, 0),  -- pro_gamer → sophia_q (Pending)
            (5, 1, 0),  -- john_doe → max_power (Pending)
            (6, 3, 1),  -- jane_smith → pro_gamer (Accepted)
            (4, 6, 2);  -- sophia_q → jane_smith (Declined)
        
        RAISE NOTICE '✅ Friends table populated with % records', (SELECT COUNT(*) FROM friends);
ELSE
        RAISE NOTICE '⚠️ Friends table already contains % records', friendship_count;
END IF;
    
    -- Display summary
    RAISE NOTICE '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
    RAISE NOTICE '📊 DATABASE SUMMARY';
    RAISE NOTICE '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
    RAISE NOTICE 'Total Users: %', (SELECT COUNT(*) FROM users);
    RAISE NOTICE 'Total Friendships: %', (SELECT COUNT(*) FROM friends);
    RAISE NOTICE 'Accepted: %', (SELECT COUNT(*) FROM friends WHERE status = 1);
    RAISE NOTICE 'Pending: %', (SELECT COUNT(*) FROM friends WHERE status = 0);
    RAISE NOTICE 'Declined: %', (SELECT COUNT(*) FROM friends WHERE status = 2);
    RAISE NOTICE '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
END $$;

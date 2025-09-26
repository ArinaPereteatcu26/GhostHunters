-- ================================
-- Create schema (tables)
-- ================================

CREATE TABLE IF NOT EXISTS "Users" (
                                       "Id" SERIAL PRIMARY KEY,
                                       "Email" TEXT NOT NULL UNIQUE,
                                       "Username" TEXT NOT NULL UNIQUE,
                                       "Password" TEXT NOT NULL,
                                       "Level" INT DEFAULT 1,
                                       "InGameCurrency" NUMERIC(12,2) DEFAULT 0,
    "CreatedAt" TIMESTAMP DEFAULT NOW(),
    "UpdatedAt" TIMESTAMP DEFAULT NOW()
    );

CREATE TABLE IF NOT EXISTS "Friendships" (
                                             "Id" SERIAL PRIMARY KEY,
                                             "RequesterId" INT NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
    "ReceiverId" INT NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
    "Status" TEXT NOT NULL,
    "CreatedAt" TIMESTAMP DEFAULT NOW(),
    "UpdatedAt" TIMESTAMP DEFAULT NOW()
    );

-- ================================
-- Seed data (only if empty)
-- ================================

DO $$
DECLARE
user_count INTEGER;
    friendship_count INTEGER;
BEGIN

    -- Seed Users
SELECT COUNT(*) INTO user_count FROM "Users";

IF user_count = 0 THEN
        RAISE NOTICE 'Users table is empty. Populating sample data...';

INSERT INTO "Users" ("Email", "Username", "Password", "Level", "InGameCurrency", "CreatedAt", "UpdatedAt")
VALUES
    ('max.power@example.com', 'max_power', '$2a$11$hashexample1', 5, 1500.00, NOW(), NOW()),
    ('lisa.ray@example.com', 'lisa_ray', '$2a$11$hashexample2', 3, 750.50, NOW(), NOW()),
    ('pro_gamer@example.com', 'pro_gamer', '$2a$11$hashexample3', 8, 2500.75, NOW(), NOW()),
    ('sophia.queen@example.com', 'sophia_q', '$2a$11$hashexample4', 2, 300.25, NOW(), NOW()),
    ('tony.iron@example.com', 'tony_iron', '$2a$11$hashexample5', 6, 1800.00, NOW(), NOW()),
    ('nina.coder@example.com', 'nina_coder', '$2a$11$hashexample6', 4, 950.30, NOW(), NOW()),
    ('victor.hunt@example.com', 'victor_h', '$2a$11$hashexample7', 7, 2100.80, NOW(), NOW()),
    ('emily.safe@example.com', 'emily_safe', '$2a$11$hashexample8', 9, 3200.15, NOW(), NOW());
ELSE
        RAISE NOTICE 'Users table already has data. Skipping user population.';
END IF;

    -- Seed Friendships
SELECT COUNT(*) INTO friendship_count FROM "Friendships";

IF friendship_count = 0 THEN
        RAISE NOTICE 'Friendships table is empty. Populating sample friendships...';

WITH user_ids AS (
    SELECT "Id", "Username" FROM "Users"
)
INSERT INTO "Friendships" ("RequesterId", "ReceiverId", "Status", "CreatedAt", "UpdatedAt")
SELECT
    u1."Id",
    u2."Id",
    f.status,
    NOW(),
    NOW()
FROM (VALUES
          ('max_power', 'lisa_ray', 'Accepted'),
          ('max_power', 'pro_gamer', 'Accepted'),
          ('lisa_ray', 'sophia_q', 'Accepted'),
          ('pro_gamer', 'tony_iron', 'Pending'),
          ('sophia_q', 'nina_coder', 'Accepted'),
          ('tony_iron', 'victor_h', 'Accepted'),
          ('nina_coder', 'emily_safe', 'Pending'),
          ('victor_h', 'max_power', 'Accepted'),
          ('emily_safe', 'lisa_ray', 'Declined')
     ) AS f(requester_username, receiver_username, status)
         JOIN user_ids u1 ON u1."Username" = f.requester_username
         JOIN user_ids u2 ON u2."Username" = f.receiver_username;
ELSE
        RAISE NOTICE 'Friendships table already has data. Skipping friendship population.';
END IF;

    RAISE NOTICE 'Database population finished.';
END $$;

-- CREATE DATABASE lobby_db;
-- \c lobby_db;

-- 1. Tables (EF Core will also handle schema, but IF NOT EXISTS adds safety)
CREATE TABLE IF NOT EXISTS "Difficulties" (
                                              "Id" SERIAL PRIMARY KEY,
                                              "Name" VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS "Statuses" (
                                          "Id" SERIAL PRIMARY KEY,
                                          "Name" VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS "Lobbies" (
                                         "Id" SERIAL PRIMARY KEY,
                                         "DifficultyId" INT NOT NULL,
                                         "GhostId" INT NOT NULL,
                                         "MapId" INT NOT NULL,
                                         "StatusId" INT NOT NULL,
                                         "Created" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                         "Ended" TIMESTAMP,
                                         FOREIGN KEY ("DifficultyId") REFERENCES "Difficulties"("Id") ON DELETE RESTRICT,
                                         FOREIGN KEY ("StatusId") REFERENCES "Statuses"("Id") ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS "Players" (
                                         "Id" SERIAL PRIMARY KEY,
                                         "UserId" INT NOT NULL,
                                         "Sanity" INT NOT NULL DEFAULT 100,
                                         "IsAlive" BOOLEAN NOT NULL DEFAULT TRUE,
                                         "LobbyId" INT NOT NULL,
                                         "JoinedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                         FOREIGN KEY ("LobbyId") REFERENCES "Lobbies"("Id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Items" (
                                       "Id" SERIAL PRIMARY KEY,
                                       "Name" VARCHAR(100) NOT NULL,
                                       "InventoryId" INT NOT NULL,
                                       "CurrentHolderId" INT,
                                       "LobbyId" INT NOT NULL,
                                       FOREIGN KEY ("LobbyId") REFERENCES "Lobbies"("Id") ON DELETE CASCADE
);

-- 2. Seed lookup tables
DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM "Difficulties") THEN
            INSERT INTO "Difficulties" ("Name") VALUES
                                                    ('Amateur'),
                                                    ('Intermediate'),
                                                    ('Professional'),
                                                    ('Nightmare');
        END IF;
    END $$;

DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM "Statuses") THEN
            INSERT INTO "Statuses" ("Name") VALUES
                                                ('Waiting'),
                                                ('In Progress'),
                                                ('Completed'),
                                                ('Failed'),
                                                ('Abandoned');
        END IF;
    END $$;

-- 3. Seed Lobbies
DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM "Lobbies") THEN
            INSERT INTO "Lobbies" ("DifficultyId", "GhostId", "MapId", "StatusId", "Created")
            SELECT d."Id", 101, 1, s."Id", CURRENT_TIMESTAMP - INTERVAL '2 hours'
            FROM "Difficulties" d, "Statuses" s
            WHERE d."Name" = 'Amateur' AND s."Name" = 'In Progress';

            INSERT INTO "Lobbies" ("DifficultyId", "GhostId", "MapId", "StatusId", "Created")
            SELECT d."Id", 102, 2, s."Id", CURRENT_TIMESTAMP - INTERVAL '30 minutes'
            FROM "Difficulties" d, "Statuses" s
            WHERE d."Name" = 'Intermediate' AND s."Name" = 'Waiting';

            INSERT INTO "Lobbies" ("DifficultyId", "GhostId", "MapId", "StatusId", "Created")
            SELECT d."Id", 103, 1, s."Id", CURRENT_TIMESTAMP - INTERVAL '5 hours'
            FROM "Difficulties" d, "Statuses" s
            WHERE d."Name" = 'Professional' AND s."Name" = 'Completed';
        END IF;
    END $$;

-- 4. Seed Players
DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM "Players") THEN
            INSERT INTO "Players" ("UserId", "Sanity", "IsAlive", "LobbyId", "JoinedAt")
            SELECT 1001, 75, TRUE, l."Id", l."Created"
            FROM "Lobbies" l
            WHERE l."GhostId" = 101;

            INSERT INTO "Players" ("UserId", "Sanity", "IsAlive", "LobbyId", "JoinedAt")
            SELECT 1002, 60, TRUE, l."Id", l."Created"
            FROM "Lobbies" l
            WHERE l."GhostId" = 101;
        END IF;
    END $$;

-- 5. Seed Items
DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM "Items") THEN
            INSERT INTO "Items" ("Name", "InventoryId", "CurrentHolderId", "LobbyId")
            SELECT 'Flashlight', 1, 1001, l."Id"
            FROM "Lobbies" l
            WHERE l."GhostId" = 101;

            INSERT INTO "Items" ("Name", "InventoryId", "CurrentHolderId", "LobbyId")
            SELECT 'EMF Reader', 2, 1002, l."Id"
            FROM "Lobbies" l
            WHERE l."GhostId" = 101;
        END IF;
    END $$;

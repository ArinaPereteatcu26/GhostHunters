CREATE TABLE IF NOT EXISTS "Difficulties" (
                                              "Id" SERIAL PRIMARY KEY,
                                              "Name" VARCHAR(100) NOT NULL
    );

CREATE TABLE IF NOT EXISTS "Ghosts" (
                                        "Id" SERIAL PRIMARY KEY,
                                        "Name" VARCHAR(100) NOT NULL
    );

CREATE TABLE IF NOT EXISTS "GameSessions" (
                                              "Id" SERIAL PRIMARY KEY,
                                              "DifficultyId" INT NOT NULL,
                                              "GhostId" INT NOT NULL,
                                              "MapId" INT NOT NULL,
                                              FOREIGN KEY ("DifficultyId") REFERENCES "Difficulties"("Id") ON DELETE RESTRICT,
    FOREIGN KEY ("GhostId") REFERENCES "Ghosts"("Id") ON DELETE RESTRICT
    );

CREATE TABLE IF NOT EXISTS "Participants" (
                                              "Id" SERIAL PRIMARY KEY,
                                              "Name" VARCHAR(100) NOT NULL,
    "Sanity" INT NOT NULL,
    "IsDead" BOOLEAN NOT NULL,
    "GameSessionId" INT NOT NULL,
    FOREIGN KEY ("GameSessionId") REFERENCES "GameSessions"("Id") ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS "Items" (
                                       "Id" SERIAL PRIMARY KEY,
                                       "Name" VARCHAR(100) NOT NULL,
    "OwnerId" INT NOT NULL,
    "CurrentHolderId" INT NOT NULL,
    "GameSessionId" INT NOT NULL,
    FOREIGN KEY ("OwnerId") REFERENCES "Participants"("Id") ON DELETE RESTRICT,
    FOREIGN KEY ("CurrentHolderId") REFERENCES "Participants"("Id") ON DELETE RESTRICT,
    FOREIGN KEY ("GameSessionId") REFERENCES "GameSessions"("Id") ON DELETE CASCADE
    );


DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "Difficulties") THEN
      INSERT INTO "Difficulties" ("Name") VALUES 
         ('Easy'),
         ('Medium'),
         ('Hard');
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "Ghosts") THEN
      INSERT INTO "Ghosts" ("Name") VALUES 
         ('Spirit'),
         ('Wraith'),
         ('Phantom');
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "GameSessions") THEN
      INSERT INTO "GameSessions" ("DifficultyId", "GhostId", "MapId") VALUES 
         (1, 1, 1);
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "Participants") THEN
      INSERT INTO "Participants" ("Name", "Sanity", "IsDead", "GameSessionId") VALUES 
         ('Player1', 100, false, 1),
         ('Player2', 100, false, 1),
         ('Player3', 100, false, 1);
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "Items") THEN
      INSERT INTO "Items" ("Name", "OwnerId", "CurrentHolderId", "GameSessionId") VALUES 
         ('Flashlight', 1, 1, 1),
         ('EMF Reader', 2, 2, 1),
         ('Spirit Box', 3, 1, 1);
END IF;
END $$;
-- CREATE DATABASE map_db;
-- \c map_db;

CREATE TABLE IF NOT EXISTS "Maps" (
                                      "Id" SERIAL PRIMARY KEY,
                                      "Name" VARCHAR(100) NOT NULL,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS "Rooms" (
                                       "Id" SERIAL PRIMARY KEY,
                                       "Name" VARCHAR(100) NOT NULL,
    "MapId" INT NOT NULL,
    "IsHidingSpot" BOOLEAN NOT NULL DEFAULT FALSE,
    "Temperature" DOUBLE PRECISION,
    "CoordinatesJson" TEXT,
    FOREIGN KEY ("MapId") REFERENCES "Maps"("Id") ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS "Objects" (
                                         "Id" SERIAL PRIMARY KEY,
                                         "Name" VARCHAR(100) NOT NULL,
    "RoomId" INT NOT NULL,
    "IsInteractable" BOOLEAN NOT NULL DEFAULT FALSE,
    "Effect" TEXT,
    FOREIGN KEY ("RoomId") REFERENCES "Rooms"("Id") ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS "Connections" (
                                             "Id" SERIAL PRIMARY KEY,
                                             "RoomFromId" INT NOT NULL,
                                             "RoomToId" INT NOT NULL,
                                             "Direction" VARCHAR(50) NOT NULL,
    FOREIGN KEY ("RoomFromId") REFERENCES "Rooms"("Id") ON DELETE RESTRICT,
    FOREIGN KEY ("RoomToId") REFERENCES "Rooms"("Id") ON DELETE RESTRICT
    );

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "Maps") THEN
      INSERT INTO "Maps" ("Name", "CreatedAt")
      VALUES ('Haunted Mansion', CURRENT_TIMESTAMP);
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "Rooms") THEN
      INSERT INTO "Rooms" ("Name", "MapId", "IsHidingSpot", "Temperature", "CoordinatesJson")
      VALUES
          ('Entrance Hall', 1, FALSE, 18.0, '{"x": 0, "y": 0}'),
          ('Dark Library', 1, TRUE, 15.5, '{"x": 10, "y": 0}'),
          ('Secret Basement', 1, TRUE, 12.0, '{"x": 0, "y": -10}');
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "Objects") THEN
      INSERT INTO "Objects" ("Name", "RoomId", "IsInteractable", "Effect")
      VALUES
          ('Ancient Door', 1, TRUE, 'Opens passage to the library'),
          ('Dusty Bookshelf', 2, TRUE, 'Reveals hidden switch'),
          ('Mysterious Artifact', 2, TRUE, 'Glows in the dark, increases courage'),
          ('Rusty Trap Door', 1, TRUE, 'Leads to the basement');
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "Connections") THEN
      INSERT INTO "Connections" ("RoomFromId", "RoomToId", "Direction")
      VALUES
          (1, 2, 'East'),
          (2, 1, 'West'),
          (1, 3, 'Down'),
          (3, 1, 'Up');
END IF;
END $$;
CREATE TABLE IF NOT EXISTS "Houses" (
                                        "Id" SERIAL PRIMARY KEY,
                                        "Name" VARCHAR(100) NOT NULL
    );

CREATE TABLE IF NOT EXISTS "Rooms" (
                                       "Id" SERIAL PRIMARY KEY,
                                       "Name" VARCHAR(100) NOT NULL,
    "HouseId" INT NOT NULL,
    FOREIGN KEY ("HouseId") REFERENCES "Houses"("Id") ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS "Objects" (
                                         "Id" SERIAL PRIMARY KEY,
                                         "RoomId" INT NOT NULL,
                                         "Name" VARCHAR(100) NOT NULL,
    "IsHiding" BOOLEAN NOT NULL,
    FOREIGN KEY ("RoomId") REFERENCES "Rooms"("Id") ON DELETE CASCADE
    );

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "Houses") THEN
      INSERT INTO "Houses" ("Name") VALUES ('Haunted Mansion');
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "Rooms") THEN
      INSERT INTO "Rooms" ("Name", "HouseId") VALUES ('Kitchen', 1);
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM "Objects") THEN
      INSERT INTO "Objects" ("RoomId", "Name", "IsHiding") VALUES
                                                 (1, 'Old Chest', false),
                                                 (1, 'Magic Mirror', true),
                                                 (1, 'Candle', false);
END IF;
END $$;
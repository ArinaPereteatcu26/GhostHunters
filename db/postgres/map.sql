-- CREATE DATABASE map_db;
-- \c map_db;

CREATE TABLE IF NOT EXISTS maps (
                                      id SERIAL PRIMARY KEY,
                                      name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS rooms (
                                       id SERIAL PRIMARY KEY,
                                       name VARCHAR(100) NOT NULL,
    map_id INT NOT NULL,
    is_hiding_spot BOOLEAN NOT NULL DEFAULT FALSE,
    temperature DOUBLE PRECISION,
    coordinates_json TEXT,
    FOREIGN KEY (map_id) REFERENCES maps(id) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS objects (
                                         id SERIAL PRIMARY KEY,
                                         name VARCHAR(100) NOT NULL,
    room_id INT NOT NULL,
    is_interactable BOOLEAN NOT NULL DEFAULT FALSE,
    effect TEXT,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS connections (
                                             id SERIAL PRIMARY KEY,
                                             room_from_id INT NOT NULL,
                                             room_to_id INT NOT NULL,
                                             direction VARCHAR(50) NOT NULL,
    FOREIGN KEY (room_from_id) REFERENCES rooms(id) ON DELETE RESTRICT,
    FOREIGN KEY (room_to_id) REFERENCES rooms(id) ON DELETE RESTRICT
    );

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM maps) THEN
      INSERT INTO maps (name, created_at)
      VALUES ('Haunted Mansion', CURRENT_TIMESTAMP);
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM rooms) THEN
      INSERT INTO rooms (name, map_id, is_hiding_spot, temperature, coordinates_json)
      VALUES
          ('Entrance Hall', 1, FALSE, 18.0, '{"x": 0, "y": 0}'),
          ('Dark Library', 1, TRUE, 15.5, '{"x": 10, "y": 0}'),
          ('Secret Basement', 1, TRUE, 12.0, '{"x": 0, "y": -10}');
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM objects) THEN
      INSERT INTO objects (name, room_id, is_interactable, effect)
      VALUES
          ('Ancient Door', 1, TRUE, 'Opens passage to the library'),
          ('Dusty Bookshelf', 2, TRUE, 'Reveals hidden switch'),
          ('Mysterious Artifact', 2, TRUE, 'Glows in the dark, increases courage'),
          ('Rusty Trap Door', 1, TRUE, 'Leads to the basement');
END IF;
END $$;

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM connections) THEN
      INSERT INTO connections (room_from_id, room_to_id, direction)
      VALUES
          (1, 2, 'East'),
          (2, 1, 'West'),
          (1, 3, 'Down'),
          (3, 1, 'Up');
END IF;
END $$;
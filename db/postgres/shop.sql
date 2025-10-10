CREATE DATABASE shop_db;
\c shop_db;

DROP TABLE IF EXISTS purchases CASCADE;
DROP TABLE IF EXISTS items CASCADE;

CREATE TABLE items (
                       id SERIAL PRIMARY KEY,
                       title TEXT NOT NULL,
                       description TEXT,
                       durability INT NOT NULL,
                       price NUMERIC NOT NULL
);

CREATE TABLE purchases (
                           id SERIAL PRIMARY KEY,
                           user_id INT NOT NULL,
                           item_id INT NOT NULL REFERENCES items(id),
                           price_paid NUMERIC NOT NULL,
                           timestamp TIMESTAMP DEFAULT NOW()
);

-- Seed items (Phasmophobia shop)
INSERT INTO items (title, description, durability, price)
VALUES
    ('Flashlight', 'Standard flashlight to illuminate dark areas.', 100, 25),
    ('Strong Flashlight', 'Brighter and longer beam than a regular flashlight.', 120, 75),
    ('Candle', 'Useful for sanity preservation; burns out over time.', 30, 15),
    ('Crucifix', 'Stops a ghost from hunting when placed nearby.', 50, 100),
    ('EMF Reader', 'Detects electromagnetic field fluctuations from ghost activity.', 80, 150),
    ('Spirit Box', 'Allows direct communication with certain ghosts.', 50, 200),
    ('Thermometer', 'Detects temperature drops to find freezing rooms.', 100, 100),
    ('Video Camera', 'Used for spotting ghost orbs and recording evidence.', 120, 250),
    ('Tripod', 'Sturdy tripod for mounting video cameras.', 200, 60),
    ('Motion Sensor', 'Detects movement; helpful for tracking ghost activity.', 150, 120),
    ('Sound Sensor', 'Detects sound in large areas; shows ghost movement indirectly.', 150, 130),
    ('UV Light', 'Reveals ghost fingerprints and footprints.', 100, 60),
    ('Photo Camera', 'Capture ghost evidence for money rewards.', 100, 200),
    ('Smudge Sticks', 'Temporarily repels ghosts when burned.', 40, 30),
    ('Lighter', 'Used to ignite smudge sticks or candles.', 100, 10),
    ('Salt', 'Helps track ghost footsteps; can provoke certain ghosts.', 50, 25),
    ('Sanity Pills', 'Restores part of your sanity after drops.', 1, 45),
    ('Motion Detector', 'Triggers when a ghost passes by.', 120, 110),
    ('Head-Mounted Camera', 'Allows remote viewing of team member’s POV.', 90, 150),
    ('Parabolic Microphone', 'Picks up distant paranormal sounds.', 100, 180),
    ('Ghost Writing Book', 'Used by ghosts to leave written evidence.', 70, 40),
    ('D.O.T.S Projector', 'Projects green dots that reveal ghost movement.', 80, 130),
    ('Protective Amulet', 'Reduces ghost interference; boosts player protection.', 200, 50),
    ('Ouija Board', 'Ask ghosts questions—at your own risk.', 60, 90),
    ('Voodoo Doll', 'Interact with it to provoke ghost activity.', 40, 70);

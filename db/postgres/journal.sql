CREATE DATABASE journal_db;
\c journal_db;

DROP TABLE IF EXISTS guesses;
DROP TABLE IF EXISTS entries;

CREATE TABLE entries (
                         id SERIAL PRIMARY KEY,
                         lobby_id INTEGER NOT NULL,
                         user_id INTEGER NOT NULL,
                         symptoms_text TEXT NOT NULL,
                         timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE guesses (
                         id SERIAL PRIMARY KEY,
                         lobby_id INTEGER NOT NULL,
                         user_id INTEGER NOT NULL,
                         guess_ghost_type VARCHAR(255) NOT NULL,
                         is_correct BOOLEAN DEFAULT FALSE,
                         reward_currency INTEGER DEFAULT 0,
                         timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_entries_lobby_id ON entries (lobby_id);
CREATE INDEX idx_guesses_lobby_id ON guesses (lobby_id);

-- Example journal entries (symptoms observed by players)
INSERT INTO entries (lobby_id, user_id, symptoms_text) VALUES
                                                           (1, 101, 'Temperature dropped below 0°C in the hallway.'),
                                                           (1, 102, 'Detected EMF Level 5 near the bathroom.'),
                                                           (1, 103, 'Ghost writing appeared in the book on the table.'),
                                                           (1, 101, 'Saw fingerprints on the door handle.'),
                                                           (2, 104, 'Ghost responded to spirit box in the attic.'),
                                                           (2, 105, 'No freezing temperatures detected in the basement.'),
                                                           (2, 106, 'Ghost orb visible on night vision camera.');

-- Example ghost guesses (like Phasmophobia ghost types)
INSERT INTO guesses (lobby_id, user_id, guess_ghost_type, is_correct, reward_currency) VALUES
                                                                                           (1, 101, 'Revenant', FALSE, 10),
                                                                                           (1, 102, 'Shade', TRUE, 50),
                                                                                           (1, 103, 'Banshee', FALSE, 5),
                                                                                           (2, 104, 'Phantom', TRUE, 60),
                                                                                           (2, 105, 'Mare', FALSE, 0),
                                                                                           (2, 106, 'Yokai', FALSE, 15);

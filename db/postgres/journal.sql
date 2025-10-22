-- CREATE DATABASE journal_db;
-- \c journal_db;

DROP TABLE IF EXISTS guesses;
DROP TABLE IF EXISTS entries;

CREATE TABLE entries (
                         id SERIAL PRIMARY KEY,
                         lobby_id INTEGER NOT NULL,
                         user_id INTEGER NOT NULL,
                         evidence TEXT NOT NULL,
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

INSERT INTO entries (lobby_id, user_id, evidence) VALUES
-- Lobby 1: Ghost = Revenant → (Freezing, Orbs, Ghost Writing)
(1, 101, 'Freezing'),
(1, 101, 'Orbs'),
(1, 101, 'Ghost Writing'),

-- Lobby 2: Ghost = Banshee → (Orbs, D.O.T.S, Fingerprints)
(2, 102, 'Orbs'),
(2, 102, 'D.O.T.S'),
(2, 102, 'Fingerprints');

-- Example ghost guesses
INSERT INTO guesses (lobby_id, user_id, guess_ghost_type, is_correct, reward_currency)
VALUES
-- Lobby 1: Player guessed correctly → Revenant
(1, 101, 'Revenant', TRUE, 80),

-- Lobby 2: Player guessed wrong → they had Banshee but guessed Phantom
(2, 102, 'Phantom', FALSE, 10);

-- CREATE DATABASE lobby_db;
-- \c lobby_db;

-- 1. Tables (EF Core will also handle schema, but IF NOT EXISTS adds safety)
CREATE TABLE IF NOT EXISTS difficulties (
                                              id SERIAL PRIMARY KEY,
                                              name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS statuses (
                                          id SERIAL PRIMARY KEY,
                                          name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS lobbies (
                                         id SERIAL PRIMARY KEY,
                                         difficulty_id INT NOT NULL,
                                         ghost_type_id INT NOT NULL,
                                         map_id INT NOT NULL,
                                         status_id INT NOT NULL,
                                         created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                         ended_at TIMESTAMP,
                                         FOREIGN KEY (difficulty_id) REFERENCES difficulties(id) ON DELETE RESTRICT,
                                         FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS players (
                                         id SERIAL PRIMARY KEY,
                                         user_id INT NOT NULL,
                                         sanity INT NOT NULL DEFAULT 100,
                                         is_alive BOOLEAN NOT NULL DEFAULT TRUE,
                                         lobby_id INT NOT NULL,
                                         joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                         FOREIGN KEY (lobby_id) REFERENCES lobbies(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS items (
                                       id SERIAL PRIMARY KEY,
                                       name VARCHAR(100) NOT NULL,
                                       inventory_id INT NOT NULL,
                                       current_holder INT,
                                       lobby_id INT NOT NULL,
                                       FOREIGN KEY (lobby_id) REFERENCES lobbies(id) ON DELETE CASCADE
);

-- 2. Seed lookup tables
DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM difficulties) THEN
            INSERT INTO difficulties (name) VALUES
                                                    ('Amateur'),
                                                    ('Intermediate'),
                                                    ('Professional'),
                                                    ('Nightmare');
        END IF;
    END $$;

DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM statuses) THEN
            INSERT INTO statuses (name) VALUES
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
        IF NOT EXISTS (SELECT 1 FROM lobbies) THEN
            INSERT INTO lobbies (difficulty_id, ghost_type_id, map_id, status_id, created_at)
            SELECT d.id, 101, 1, s.id, CURRENT_TIMESTAMP - INTERVAL '2 hours'
            FROM difficulties d, statuses s
            WHERE d.name = 'Amateur' AND s.name = 'In Progress';

            INSERT INTO lobbies (difficulty_id, ghost_type_id, map_id, status_id, created_at)
            SELECT d.id, 102, 2, s.id, CURRENT_TIMESTAMP - INTERVAL '30 minutes'
            FROM difficulties d, statuses s
            WHERE d.name = 'Intermediate' AND s.name = 'Waiting';

            INSERT INTO lobbies (difficulty_id, ghost_type_id, map_id, status_id, created_at)
            SELECT d.id, 103, 1, s.id, CURRENT_TIMESTAMP - INTERVAL '5 hours'
            FROM difficulties d, statuses s
            WHERE d.name = 'Professional' AND s.name = 'Completed';
        END IF;
    END $$;

-- 4. Seed Players
DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM players) THEN
            INSERT INTO players (user_id, sanity, is_alive, lobby_id, joined_at)
            SELECT 1001, 75, TRUE, l.id, l.created_at
            FROM lobbies l
            WHERE l.ghost_type_id = 101;

            INSERT INTO players (user_id, sanity, is_alive, lobby_id, joined_at)
            SELECT 1002, 60, TRUE, l.id, l.created_at
            FROM lobbies l
            WHERE l.ghost_type_id = 101;
        END IF;
    END $$;

-- 5. Seed Items
DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM items) THEN
            INSERT INTO items (name, inventory_id, current_holder, lobby_id)
            SELECT 'Flashlight', 1, 1001, l.id
            FROM lobbies l
            WHERE l.ghost_type_id = 101;

            INSERT INTO items (name, inventory_id, current_holder, lobby_id)
            SELECT 'EMF Reader', 2, 1002, l.id
            FROM lobbies l
            WHERE l.ghost_type_id = 101;
        END IF;
    END $$;

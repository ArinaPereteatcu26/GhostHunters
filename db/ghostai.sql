
-- ========================================
-- Ghost AI Service PostgreSQL Seeding Script
-- ========================================

-- ------------------
-- Ghost Types
-- ------------------
CREATE TABLE IF NOT EXISTS ghost_types (
                                           id SERIAL PRIMARY KEY,
                                           name VARCHAR(50) NOT NULL,
    base_aggression INT DEFAULT 1,
    special_abilities TEXT,
    weaknesses TEXT
    );

-- ------------------
-- Ghosts
-- ------------------
CREATE TABLE IF NOT EXISTS ghosts (
                                      id SERIAL PRIMARY KEY,
                                      lobby_id INT NOT NULL,
                                      name VARCHAR(100) NOT NULL,
    ghost_type_id INT REFERENCES ghost_types(id),
    current_state VARCHAR(50) DEFAULT 'IDLE',
    current_room VARCHAR(100),
    aggression_level INT DEFAULT 1,
    target_player_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    last_action_at TIMESTAMP DEFAULT NOW()
    );

-- ------------------
-- Ghost Behaviors
-- ------------------
CREATE TABLE IF NOT EXISTS ghost_behaviors (
                                               id SERIAL PRIMARY KEY,
                                               ghost_id INT NOT NULL REFERENCES ghosts(id) ON DELETE CASCADE,
    behavior_type VARCHAR(50) NOT NULL,
    target_room VARCHAR(100),
    target_object VARCHAR(100),
    target_player_id INT,
    priority INT DEFAULT 1,
    trigger_condition VARCHAR(100),
    executed BOOLEAN DEFAULT FALSE,
    executed_at TIMESTAMP
    );

-- ------------------
-- Ghost Actions
-- ------------------
CREATE TABLE IF NOT EXISTS ghost_actions (
                                             id SERIAL PRIMARY KEY,
                                             ghost_id INT NOT NULL REFERENCES ghosts(id) ON DELETE CASCADE,
    action_type VARCHAR(50),
    target_room VARCHAR(100),
    target_object VARCHAR(100),
    target_player_id INT,
    timestamp TIMESTAMP DEFAULT NOW(),
    success BOOLEAN DEFAULT TRUE
    );

-- ------------------
-- Insert Seed Data
-- ------------------
INSERT INTO ghost_types (id, name, base_aggression, special_abilities, weaknesses)
VALUES
    (1, 'Poltergeist', 3, 'ObjectThrow,ElectronicsManipulation', 'Salt,Iron'),
    (2, 'Phantom', 2, 'Invisibility,ColdSpots', 'Light,Prayer');

INSERT INTO ghosts (id, lobby_id, name, ghost_type_id, current_state, current_room, aggression_level)
VALUES
    (1, 1, 'The Mansion Keeper', 1, 'HIDING', 'Living Room', 3),
    (2, 2, 'Dr. Shadows', 2, 'STALKING', 'Emergency Room', 2);

INSERT INTO ghost_behaviors (id, ghost_id, behavior_type, target_room, priority, trigger_condition)
VALUES
    (1, 1, 'MoveToRoom', 'Kitchen', 1, 'Noise'),
    (2, 1, 'InteractObject', 'Basement', 2, 'LowSanity'),
    (3, 2, 'EmitSound', 'Emergency Room', 2, 'LowSanity'),
    (4, 2, 'ChasePlayer', 'Operating Theater', 1, 'PlayerDetected');

INSERT INTO ghost_actions (id, ghost_id, action_type, target_room, target_object, target_player_id, success)
VALUES
    (1, 1, 'Knock', 'Living Room', 'Door', 1, TRUE),
    (2, 1, 'Throw', 'Kitchen', 'Plate', NULL, TRUE),
    (3, 2, 'Scream', 'Emergency Room', NULL, 3, TRUE);

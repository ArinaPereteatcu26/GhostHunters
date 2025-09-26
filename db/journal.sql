<<<<<<< HEAD
-- --- Investigations ---
INSERT INTO investigations (user_id, location_name, difficulty, status, created_at, updated_at)
VALUES
(1, 'Old Mansion', 'amateur', 'active', NOW(), NOW()),
(2, 'Abandoned Hospital', 'intermediate', 'completed', NOW(), NOW()),
(1, 'Forest Cabin', 'professional', 'active', NOW(), NOW());

-- --- Evidence ---
INSERT INTO evidence (investigation_id, evidence_type, status, timestamp, notes, confidence)
VALUES
(1, 'emf', 'confirmed', NOW(), 'Strong EMF readings in main hall', 85),
(1, 'orbs', 'unknown', NOW(), 'Sporadic orbs detected', 50),
(2, 'fingerprints', 'ruled_out', NOW(), 'No fingerprints found', 0);

-- --- Symptoms ---
INSERT INTO symptoms (investigation_id, type, description, timestamp, severity)
VALUES
(1, 'door_slam', 'Doors slam without wind', NOW(), 'high'),
(2, 'light_flicker', 'Lights flicker intermittently', NOW(), 'medium');

-- --- Ghost Analysis ---
INSERT INTO ghost_analysis (investigation_id, possible_ghosts, eliminated_ghosts, confidence)
VALUES
(1, '[{"ghostType":"Poltergeist","probability":0.8,"matchingEvidence":["emf","door_slam"],"contradictingEvidence":[]}]'::jsonb, '[]'::jsonb, 0.8);

-- --- Final Guess ---
INSERT INTO final_guess (investigation_id, ghost_type, confidence, reasoning, submitted_at)
VALUES
(1, 'Poltergeist', 80, 'High EMF readings and violent activity', NOW()),
(2, 'Banshee', 60, 'Screaming sounds and cold spots', NOW());

-- --- Scoring ---
INSERT INTO scoring (investigation_id, base_score, evidence_bonus, time_bonus, difficulty_multiplier, final_score)
VALUES
(1, 100, 20, 10, 1.2, 156),
(2, 80, 10, 5, 1.1, 104);
=======
-- Drop old tables (respecting dependencies)
DROP TABLE IF EXISTS scoring CASCADE;
DROP TABLE IF EXISTS final_guess CASCADE;
DROP TABLE IF EXISTS ghost_analysis CASCADE;
DROP TABLE IF EXISTS symptoms CASCADE;
DROP TABLE IF EXISTS evidence CASCADE;
DROP TABLE IF EXISTS investigations CASCADE;

-- Drop old enums
DROP TYPE IF EXISTS difficulty_enum CASCADE;
DROP TYPE IF EXISTS status_enum CASCADE;
DROP TYPE IF EXISTS evidence_type_enum CASCADE;
DROP TYPE IF EXISTS evidence_status_enum CASCADE;
DROP TYPE IF EXISTS symptom_type_enum CASCADE;
DROP TYPE IF EXISTS severity_enum CASCADE;

-- Enums
CREATE TYPE difficulty_enum AS ENUM ('amateur', 'intermediate', 'professional', 'nightmare');
CREATE TYPE status_enum AS ENUM ('active', 'completed', 'abandoned');
CREATE TYPE evidence_type_enum AS ENUM ('emf', 'fingerprints', 'freezing', 'orbs', 'writing', 'dots', 'spiritbox');
CREATE TYPE evidence_status_enum AS ENUM ('confirmed', 'ruled_out', 'unknown');
CREATE TYPE symptom_type_enum AS ENUM ('door_slam', 'light_flicker', 'temperature_drop', 'object_throw', 'hunt_mode', 'ghost_event', 'interaction');
CREATE TYPE severity_enum AS ENUM ('low', 'medium', 'high');

-- Investigations table
CREATE TABLE investigations (
    investigation_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    location_name TEXT NOT NULL,
    difficulty difficulty_enum NOT NULL,
    status status_enum DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

-- Evidence table
CREATE TABLE evidence (
    evidence_id SERIAL PRIMARY KEY,
    investigation_id INT NOT NULL REFERENCES investigations(investigation_id) ON DELETE CASCADE,
    evidence_type evidence_type_enum NOT NULL,
    status evidence_status_enum DEFAULT 'unknown',
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    confidence INT
);

-- Symptoms table
CREATE TABLE symptoms (
    symptom_id SERIAL PRIMARY KEY,
    investigation_id INT NOT NULL REFERENCES investigations(investigation_id) ON DELETE CASCADE,
    type symptom_type_enum NOT NULL,
    description TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    location TEXT,
    severity severity_enum,
    witnessed_by JSON DEFAULT '[]'
);

-- Ghost analysis table
CREATE TABLE ghost_analysis (
    analysis_id SERIAL PRIMARY KEY,
    investigation_id INT NOT NULL REFERENCES investigations(investigation_id) ON DELETE CASCADE,
    possible_ghosts JSON DEFAULT '[]',
    eliminated_ghosts JSON DEFAULT '[]',
    confidence FLOAT
);

-- Final guess table
CREATE TABLE final_guess (
    final_guess_id SERIAL PRIMARY KEY,
    investigation_id INT NOT NULL REFERENCES investigations(investigation_id) ON DELETE CASCADE,
    ghost_type TEXT,
    confidence INT,
    reasoning TEXT,
    submitted_at TIMESTAMP
);

-- Scoring table
CREATE TABLE scoring (
    scoring_id SERIAL PRIMARY KEY,
    investigation_id INT NOT NULL REFERENCES investigations(investigation_id) ON DELETE CASCADE,
    base_score INT NOT NULL DEFAULT 0,
    evidence_bonus INT NOT NULL DEFAULT 0,
    time_bonus INT NOT NULL DEFAULT 0,
    difficulty_multiplier FLOAT NOT NULL DEFAULT 1.0,
    final_score INT
);

-- Insert demo investigation
INSERT INTO investigations (user_id, location_name, difficulty, status)
VALUES
(1, 'Abandoned Asylum', 'professional', 'active'),
(2, 'Haunted Mansion', 'intermediate', 'completed');

-- Insert demo evidence
INSERT INTO evidence (investigation_id, evidence_type, status, notes, confidence)
VALUES
(1, 'emf', 'confirmed', 'High EMF near hallway', 90),
(1, 'orbs', 'unknown', 'Possible orb in video', 50),
(2, 'writing', 'confirmed', 'Ghost writing found on book', 100);

-- Insert demo symptoms
INSERT INTO symptoms (investigation_id, type, description, severity, witnessed_by)
VALUES
(1, 'door_slam', 'Door slammed shut in basement', 'high', '["Alice"]'),
(2, 'light_flicker', 'Lights flickered repeatedly', 'medium', '["Bob", "Charlie"]');

-- Insert demo ghost analysis
INSERT INTO ghost_analysis (investigation_id, possible_ghosts, eliminated_ghosts, confidence)
VALUES
(1, '[{"ghostType": "Poltergeist", "probability": 0.7}]', '["Banshee"]', 0.75),
(2, '[{"ghostType": "Demon", "probability": 0.9}]', '[]', 0.9);

-- Insert demo final guess
INSERT INTO final_guess (investigation_id, ghost_type, confidence, reasoning, submitted_at)
VALUES
(1, 'Poltergeist', 80, 'Strong EMF + orbs', CURRENT_TIMESTAMP),
(2, 'Demon', 95, 'Aggressive behavior + ghost writing', CURRENT_TIMESTAMP);

-- Insert demo scoring
INSERT INTO scoring (investigation_id, base_score, evidence_bonus, time_bonus, difficulty_multiplier, final_score)
VALUES
(1, 100, 50, 20, 1.5, 255),
(2, 80, 40, 30, 1.2, 180);
>>>>>>> fe597b1 (feat:update common docker-compose, create dbms script with example)

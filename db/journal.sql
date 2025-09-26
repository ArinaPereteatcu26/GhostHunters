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
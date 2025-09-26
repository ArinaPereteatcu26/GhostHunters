CREATE TABLE IF NOT EXISTS ghosts (
                                      id SERIAL PRIMARY KEY,
                                      name TEXT NOT NULL,
                                      type_a_symptoms TEXT[],
                                      type_b_symptoms TEXT[]
);

DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM ghosts) THEN
      INSERT INTO ghosts (name, type_a_symptoms, type_b_symptoms)
      VALUES
         ('Poltergeist', ARRAY['moving objects', 'loud noises'], ARRAY['cold spots']),
         ('Banshee', ARRAY['screaming'], ARRAY['shadows']),
         ('Wraith', ARRAY['apparitions'], ARRAY['draining energy']);
END IF;
END $$;

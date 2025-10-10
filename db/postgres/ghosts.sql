CREATE DATABASE ghosts_db;
\c ghosts_db;

CREATE TABLE IF NOT EXISTS ghost_types (
                                           id SERIAL PRIMARY KEY,
                                           name VARCHAR(100) NOT NULL,
                                           description TEXT,
                                           aggressiveness INT CHECK (aggressiveness BETWEEN 1 AND 10),
                                           trigger_condition TEXT,
                                           min_sanity_threshold INT CHECK (min_sanity_threshold BETWEEN 0 AND 100)
);

CREATE TABLE IF NOT EXISTS type_a_symptoms (
                                               id SERIAL PRIMARY KEY,
                                               ghost_type_id INT NOT NULL REFERENCES ghost_types(id) ON DELETE CASCADE,
                                               description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS type_b_symptoms (
                                               id SERIAL PRIMARY KEY,
                                               ghost_type_id INT NOT NULL REFERENCES ghost_types(id) ON DELETE CASCADE,
                                               description TEXT NOT NULL
);

DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM ghost_types) THEN
            INSERT INTO ghost_types (name, description, aggressiveness, trigger_condition, min_sanity_threshold)
            VALUES
                ('Spirit', 'A balanced ghost with average activity and hunting frequency.', 5, 'Triggered randomly at low sanity.', 40),
                ('Wraith', 'Can fly through walls and is rarely seen touching the ground.', 8, 'Triggered when players are alone.', 50),
                ('Phantom', 'Manifestation that appears near cameras and drains sanity fast.', 7, 'Triggered by player attention.', 45),
                ('Poltergeist', 'Throws multiple objects at once, thrives in cluttered areas.', 7, 'Triggered by loud noise.', 55),
                ('Banshee', 'Focuses on one player until they are eliminated.', 8, 'Triggered by proximity to target.', 60),
                ('Jinn', 'Fast when chasing but weak when the power is off.', 6, 'Triggered by distant presence.', 50),
                ('Mare', 'Prefers darkness, more active with lights off.', 6, 'Triggered in unlit rooms.', 40),
                ('Revenant', 'Very slow when not hunting but terrifyingly fast during a hunt.', 10, 'Triggered after seeing a target.', 70),
                ('Shade', 'Shy ghost; less active around multiple players.', 3, 'Triggered when alone with a player.', 35),
                ('Demon', 'Hunts frequently and aggressively regardless of sanity.', 9, 'Triggered often even at high sanity.', 75),
                ('Yurei', 'Drains sanity rapidly and closes doors around itself.', 8, 'Triggered by player movement.', 55),
                ('Oni', 'Highly active when players are nearby; throws objects often.', 7, 'Triggered by group presence.', 60),
                ('Yokai', 'Becomes aggressive when players talk near it.', 6, 'Triggered by voice or noise.', 50),
                ('Hantu', 'Moves faster in cold areas; slower in warmth.', 5, 'Triggered by freezing temperature.', 45),
                ('Goryo', 'Appears only on cameras when no one is in the room.', 6, 'Triggered by being unobserved.', 50),
                ('Myling', 'Quiet ghost that produces more sound on equipment.', 5, 'Triggered by proximity.', 45),
                ('Onryo', 'Vengeful spirit that attacks after being provoked by flame or cross interference.', 8, 'Triggered by extinguishing fire sources.', 55),
                ('The Twins', 'Acts in two places at once; each twin can trigger activity.', 8, 'Triggered by simultaneous events.', 50),
                ('Raiju', 'Draws energy from electronics; moves faster near active devices.', 9, 'Triggered by powered electronics.', 60),
                ('Mimic', 'Copies traits and evidence from other ghosts.', 7, 'Triggered by mimicking recent activity.', 50);
        END IF;

        -- ✅ Type A: Evidences / sensory cues
        INSERT INTO type_a_symptoms (ghost_type_id, description)
        SELECT gt.id, a.description
        FROM ghost_types gt
                 JOIN (
            VALUES
                ('Spirit','EMF Level 5'), ('Spirit','Ghost Writing'), ('Spirit','Spirit Box Response'), ('Spirit','Cold Spots'),
                ('Wraith','No Footsteps'), ('Wraith','Flight Through Walls'), ('Wraith','UV Footprint Absence'), ('Wraith','High EMF Surge'),
                ('Phantom','Disappears When Photographed'), ('Phantom','Apparition Shadow'), ('Phantom','Extended Flicker Time'), ('Phantom','Heavy Air Pressure'),
                ('Poltergeist','Object Movement'), ('Poltergeist','Multiple Objects Thrown'), ('Poltergeist','Random Temperature Spikes'), ('Poltergeist','Sudden Sound Bursts'),
                ('Banshee','Screeching Sound'), ('Banshee','EMF Level 4-5 Spikes'), ('Banshee','Appears Near Target'), ('Banshee','Directional Screams'),
                ('Jinn','Power Surge Near Breaker'), ('Jinn','Temperature Fluctuation'), ('Jinn','Fast EMF Response'), ('Jinn','Humming Sound'),
                ('Mare','Prefers Darkness'), ('Mare','Turns Lights Off'), ('Mare','Causes Nightmares'), ('Mare','Dark Aura Visible'),
                ('Revenant','Slow When Idle'), ('Revenant','Fast When Chasing'), ('Revenant','Distinct Breathing'), ('Revenant','Heavy Footsteps'),
                ('Shade','Minimal Activity in Groups'), ('Shade','Silent Presence'), ('Shade','Low EMF Reading'), ('Shade','Appears Rarely'),
                ('Demon','Early Hunts'), ('Demon','Frequent Roars'), ('Demon','Strong EMF 5'), ('Demon','Aggressive Manifestations'),
                ('Yurei','Rapid Sanity Drain'), ('Yurei','Door Slamming'), ('Yurei','Faint Moaning'), ('Yurei','Cold Air Burst'),
                ('Oni','Throws Objects Forcefully'), ('Oni','Visible Apparition'), ('Oni','Active Around Groups'), ('Oni','Footsteps Heard Far Away'),
                ('Yokai','Interferes with Electronics'), ('Yokai','Loud Radio Distortion'), ('Yokai','Triggered by Talking'), ('Yokai','Distorted Voices'),
                ('Hantu','Visible Cold Mist'), ('Hantu','Moves Faster in Cold'), ('Hantu','Leaves Frost Trail'), ('Hantu','Ice Breath Detected'),
                ('Goryo','Visible on Camera Only'), ('Goryo','Infrared Distortion'), ('Goryo','Refuses to Appear to Players'), ('Goryo','Distinct Growl'),
                ('Myling','Whispering Childlike Voice'), ('Myling','Footsteps Audible on Parabolic'), ('Myling','EMF Flicker at Close Range'), ('Myling','Weeping Sounds'),
                ('Onryo','Triggered by Fire Extinction'), ('Onryo','Strong EMF Bursts'), ('Onryo','Distorted Screams'), ('Onryo','Candle Flicker Interaction'),
                ('The Twins','Two EMF Sources'), ('The Twins','Desynchronized Noises'), ('The Twins','Cold Spots in Two Areas'), ('The Twins','Simultaneous Door Touches'),
                ('Raiju','Electronics Malfunction'), ('Raiju','Lightning-Like Energy Field'), ('Raiju','Fast Movement During Storm'), ('Raiju','Fluctuating EMF Zones'),
                ('Mimic','Copies Voices'), ('Mimic','Adapts EMF Pattern'), ('Mimic','Mirrors Ghost Evidence'), ('Mimic','Unpredictable Behavior')
        ) AS a(ghost_name, description) ON gt.name = a.ghost_name;

        -- ✅ Type B: Behavioral patterns
        INSERT INTO type_b_symptoms (ghost_type_id, description)
        SELECT gt.id, b.description
        FROM ghost_types gt
                 JOIN (
            VALUES
                ('Spirit','Hunts predictably every few minutes'), ('Spirit','Responds to smudge sticks'), ('Spirit','Avoids crucifix zones'),
                ('Wraith','Never steps in salt'), ('Wraith','Appears behind players unexpectedly'), ('Wraith','Hovers silently'),
                ('Phantom','Causes camera interference'), ('Phantom','Leaves area instantly after photo'), ('Phantom','Can follow players unseen'),
                ('Poltergeist','Throws nearby objects during hunts'), ('Poltergeist','More active with many items around'), ('Poltergeist','Causes temperature spikes'),
                ('Banshee','Focuses exclusively on one player'), ('Banshee','Shrieks loudly before hunt'), ('Banshee','Avoids non-targets'),
                ('Jinn','Faster when lights are on'), ('Jinn','Weaker when breaker is off'), ('Jinn','Hums near electrical panels'),
                ('Mare','Prefers pitch-black environments'), ('Mare','More active after lights are off'), ('Mare','Can cut power remotely'),
                ('Revenant','Accelerates rapidly during hunts'), ('Revenant','Slows drastically when not chasing'), ('Revenant','Maintains line of sight aggressively'),
                ('Shade','Avoids initiating hunts near players'), ('Shade','Almost silent during manifestation'), ('Shade','Hides evidence longer'),
                ('Demon','Attacks even above 70% sanity'), ('Demon','Less affected by smudge sticks'), ('Demon','Double hunt frequency'),
                ('Yurei','Closes multiple doors simultaneously'), ('Yurei','Causes sudden cold drafts'), ('Yurei','Drains sanity with presence'),
                ('Oni','Appears in physical form often'), ('Oni','Throws heavy items'), ('Oni','Interacts more when players speak loudly'),
                ('Yokai','Hunts players who talk nearby'), ('Yokai','Causes voice channel distortion'), ('Yokai','Prefers social noise areas'),
                ('Hantu','Slows down in warm rooms'), ('Hantu','Moves faster in frozen areas'), ('Hantu','Leaves condensation trails'),
                ('Goryo','Visible only on camera when alone'), ('Goryo','Appears consistently at same spot'), ('Goryo','Refuses to interact when watched'),
                ('Myling','Approaches quietly during hunt'), ('Myling','Strong parabolic microphone readings'), ('Myling','Muffled footsteps'),
                ('Onryo','Triggered by extinguished candles'), ('Onryo','Aggressive when angered'), ('Onryo','Causes nearby flames to flicker'),
                ('The Twins','Simultaneous noises in two areas'), ('The Twins','Separate hunt timings'), ('The Twins','Double EMF patterns'),
                ('Raiju','Speeds up near active electronics'), ('Raiju','Causes lights to flicker violently'), ('Raiju','Easily detectable by EMF surge'),
                ('Mimic','Changes behavior to resemble others'), ('Mimic','Cycles evidence periodically'), ('Mimic','Creates fake audio clues')
        ) AS b(ghost_name, description) ON gt.name = b.ghost_name;

    END $$;

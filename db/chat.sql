-- Users
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  has_radio BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Rooms
CREATE TABLE IF NOT EXISTS rooms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Memberships (many-to-many: users <-> rooms)
CREATE TABLE IF NOT EXISTS room_members (
  room_id INT NOT NULL,
  user_id INT NOT NULL,
  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (room_id, user_id),
  CONSTRAINT fk_room_members_room FOREIGN KEY (room_id)
    REFERENCES rooms(id) ON DELETE CASCADE,
  CONSTRAINT fk_room_members_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Messages
CREATE TABLE IF NOT EXISTS messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  recipient_id INT NULL,
  room_id INT NULL,
  content TEXT NOT NULL,
  timestamp DATETIME NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_messages_sender FOREIGN KEY (sender_id)
    REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_messages_recipient FOREIGN KEY (recipient_id)
    REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_messages_room FOREIGN KEY (room_id)
    REFERENCES rooms(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Users
INSERT INTO users (name, has_radio)
VALUES
    ('Alice', TRUE),
    ('Bob', FALSE),
    ('Charlie', TRUE),
    ('Diana', FALSE);

-- Insert Rooms
INSERT INTO rooms (name)
VALUES
    ('General'),
    ('GhostHunters'),
    ('RadioOnly');

-- Insert Room Memberships
INSERT INTO room_members (room_id, user_id)
VALUES
    (1, 1), -- Alice in General
    (1, 2), -- Bob in General
    (2, 3), -- Charlie in GhostHunters
    (2, 4), -- Diana in GhostHunters
    (3, 1), -- Alice in RadioOnly
    (3, 3); -- Charlie in RadioOnly

-- Insert Messages
INSERT INTO messages (sender_id, recipient_id, room_id, content, timestamp)
VALUES
    (1, NULL, 1, 'Hello everyone, welcome to General!', NOW()),
    (2, NULL, 1, 'Hi Alice, glad to be here!', NOW()),
    (3, NULL, 2, 'Any ghost sightings today?', NOW()),
    (4, NULL, 2, 'Not yet, but I have my tools ready!', NOW()),
    (1, 3, NULL, 'Hey Charlie, want to test the radio?', NOW()),
    (3, 1, 3, 'Sure, I hear you loud and clear on RadioOnly.', NOW());

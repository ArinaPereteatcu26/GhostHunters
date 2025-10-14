-- Use the database created by Docker environment variable
USE ghosthunters_chat;

-- Messages-only schema for the new model
CREATE TABLE IF NOT EXISTS messages (
                                        id INT AUTO_INCREMENT PRIMARY KEY,
                                        lobby_id INT NULL,
                                        sender_user_id INT NOT NULL,
                                        room_id INT NULL,
                                        content TEXT NOT NULL,
                                        timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                        is_radio BOOLEAN NOT NULL DEFAULT FALSE,
                                        is_blocked BOOLEAN NOT NULL DEFAULT FALSE,
                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Helpful indexes
CREATE INDEX ix_messages_lobby_ts ON messages (lobby_id, timestamp);
CREATE INDEX ix_messages_room_ts ON messages (room_id, timestamp);
CREATE INDEX ix_messages_sender_ts ON messages (sender_user_id, timestamp);

-- Sample seed data
INSERT INTO messages (lobby_id, sender_user_id, room_id, content, timestamp, is_radio, is_blocked)
VALUES
    (1, 1, NULL, 'Hello lobby 1! Welcome everyone.', NOW(), FALSE, FALSE),
    (1, 2, NULL, 'Hey! Glad to be here in lobby 1.', NOW(), FALSE, FALSE),
    (NULL, 3, 2, 'Any updates from room 2?', NOW(), FALSE, FALSE),
    (NULL, 4, 2, 'Not yet—listening in.', NOW(), FALSE, FALSE),
    (NULL, 1, 3, 'Testing a radio-style broadcast in room 3.', NOW(), TRUE, FALSE),
    (1, 3, NULL, 'Broadcast to lobby 1 via radio.', NOW(), TRUE, FALSE),
    (NULL, 2, 2, 'This one is blocked by moderation.', NOW(), FALSE, TRUE);
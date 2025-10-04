-- 001_schema.sql  (MySQL 8)
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS objects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  max_durability INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS ownerships (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  object_id INT NOT NULL,
  purchased_at DATETIME NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  durability_remaining INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ownerships_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_ownerships_object
    FOREIGN KEY (object_id) REFERENCES objects(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Users
INSERT INTO users (name)
VALUES
    ('Alice'),
    ('Bob'),
    ('Charlie');

-- Insert Objects
INSERT INTO objects (name, description, max_durability)
VALUES
    ('Flashlight', 'Helps explore dark areas', 100),
    ('EMF Reader', 'Detects ghost electromagnetic activity', 80),
    ('Camera', 'Captures ghost evidence', 120),
    ('Radio', 'Communicate with other players', 150);

-- Insert Ownerships (users buy objects)
INSERT INTO ownerships (user_id, object_id, purchased_at, price, durability_remaining)
VALUES
    (1, 1, NOW(), 49.99, 95),   -- Alice bought a flashlight
    (1, 2, NOW(), 99.99, 80),   -- Alice bought an EMF Reader
    (2, 3, NOW(), 199.99, 115), -- Bob bought a Camera
    (3, 4, NOW(), 79.99, 150),  -- Charlie bought a Radio
    (3, 1, NOW(), 45.00, 90);   -- Charlie also bought a flashlight

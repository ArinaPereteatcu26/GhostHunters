CREATE TABLE IF NOT EXISTS messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sender VARCHAR(100) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- optional seed data
INSERT INTO messages (sender, content) VALUES
  ('system', 'Welcome to GhostHunters Chat!'),
  ('admin', 'Remember to log your findings in the Journal service.');

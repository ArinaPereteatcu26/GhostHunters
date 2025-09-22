CREATE TABLE IF NOT EXISTS objects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- optional seed data
INSERT INTO objects (name, quantity) VALUES
  ('Torch', 10),
  ('Salt', 25),
  ('EMF Reader', 5);

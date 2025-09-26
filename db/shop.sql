-- Drop old tables
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS items CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Create tables
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT
);

CREATE TABLE items (
    item_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    price NUMERIC NOT NULL,
    category TEXT,
    description TEXT,
    available BOOLEAN DEFAULT TRUE
);

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    item_id INT NOT NULL,
    status TEXT NOT NULL,
    reason TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- Insert data
INSERT INTO users (username, email)
VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');

INSERT INTO items (name, price, category, description, available)
VALUES
('Flashlight', 25, 'Equipment', 'Bright LED flashlight', TRUE),
('EMF Reader', 150, 'Equipment', 'Measures EMF levels', TRUE),
('Spirit Box', 200, 'Equipment', 'Device for spirit communication', TRUE),
('Protective Amulet', 50, 'Accessory', 'Reduces ghost interference', TRUE);

INSERT INTO transactions (user_id, item_id, status, reason)
VALUES
(1, 1, 'success', NULL),
(2, 2, 'failed', 'Item not available'),
(1, 3, 'success', NULL);

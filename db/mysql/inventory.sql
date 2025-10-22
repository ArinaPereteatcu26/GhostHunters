-- Use the database created by Docker
USE ghosthunters;

-- Single-table schema used by your FastAPI service
CREATE TABLE IF NOT EXISTS inventory (
                                         id INT AUTO_INCREMENT PRIMARY KEY,
                                         user_id INT NOT NULL,
                                         item_id INT NOT NULL,
                                         purchased_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                         title VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    durability_remaining INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_inventory_user_id (user_id),
    INDEX idx_inventory_item_id (item_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO inventory (user_id, item_id, purchased_at, title, description, durability_remaining) VALUES
                                                                                                     (1, 101, NOW(), 'Flashlight',   'Starter flashlight', 100),
                                                                                                     (1, 102, NOW(), 'EMF',   'Basic EMF detection tool', 85),
                                                                                                     (2, 201, NOW(), 'Photo Camera', 'Camera for capturing ghost evidence', 90);
CREATE DATABASE IF NOT EXISTS gunaso_db;
USE gunaso_db;

-- 1. Roles Table
CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Seed Roles
INSERT INTO roles (role_name) VALUES 
('CITIZEN'),
('WADA_ADAKSHYA'),
('NAGAR_PRAMUKH'),
('PRIME_MINISTER'),
('SUPER_ADMIN');

-- 2. Departments Table
CREATE TABLE IF NOT EXISTS departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE
);

-- Seed Departments
INSERT INTO departments (dept_name) VALUES 
('Health'),
('Education'),
('Infrastructure'),
('Electricity'),
('Water Supply'),
('General Administration'),
('Agriculture'),
('Environment');

-- 3. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    role_id INT NOT NULL,
    dept_id INT, -- NULL for citizens and prime minister
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id),
    FOREIGN KEY (dept_id) REFERENCES departments(id)
);

-- 4. Gunaso (Complaints) Table
CREATE TABLE IF NOT EXISTS gunaso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    user_id INT NOT NULL,
    dept_id INT NOT NULL,
    status ENUM('Pending', 'In Review', 'Solved', 'Rejected') DEFAULT 'Pending',
    attachment VARCHAR(255), -- Store file path
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (dept_id) REFERENCES departments(id) ON DELETE CASCADE
);

-- 5. Replies Table
CREATE TABLE IF NOT EXISTS replies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    gunaso_id INT NOT NULL,
    user_id INT NOT NULL, -- The authority who replied
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (gunaso_id) REFERENCES gunaso(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 6. Sarkar Updates Table (Feed)
CREATE TABLE IF NOT EXISTS sarkar_updates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- Authority user who posted
    content TEXT NOT NULL,
    photo_url VARCHAR(255),
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 7. Update Likes Table
CREATE TABLE IF NOT EXISTS update_likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    update_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (update_id) REFERENCES sarkar_updates(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_like (update_id, user_id)
);

-- 8. Update Comments Table
CREATE TABLE IF NOT EXISTS update_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    update_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (update_id) REFERENCES sarkar_updates(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
//done by DWEEP
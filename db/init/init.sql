-- Switch to the reelsync database
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'reelsync') THEN
        PERFORM dblink_exec('dbname=postgres', 'CREATE DATABASE reelsync');
    END IF;
END $$;

-- Connect to the reelsync database
\connect reelsync;

-- Drop tables if they already exist for development purposes
DROP TABLE IF EXISTS comments, videos, video_parts, missing_video_parts, tags, video_tags, genres, video_genres, users, categories;

-- Drop types if they already exist
DROP TYPE IF EXISTS status_enum, device_enum;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,  -- Store hashed passwords for production
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create videos table
CREATE TABLE IF NOT EXISTS videos (
    video_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    url VARCHAR(255) NOT NULL,
    category_id INT REFERENCES categories(category_id) ON DELETE SET NULL,
    user_id INT REFERENCES users(user_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create status table
CREATE TABLE IF NOT EXISTS status (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create device table
CREATE TABLE IF NOT EXISTS device (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    mount_path VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create video_parts table
CREATE TABLE IF NOT EXISTS video_parts (
    id SERIAL PRIMARY KEY,
    video_id INTEGER REFERENCES videos(video_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    filename VARCHAR(255) NOT NULL,
    dimensions VARCHAR(50),
    sequence INTEGER,
    home VARCHAR(255),
    current VARCHAR(255),
    status_id INTEGER REFERENCES status(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    viewed BOOLEAN DEFAULT FALSE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    device_id INTEGER REFERENCES device(id),
    remarks TEXT,
    file_size INTEGER,
    duration INTEGER,
    format VARCHAR(50),
    creator VARCHAR(255),
    license VARCHAR(255),
    language VARCHAR(50),
    subtitles VARCHAR(255),
    thumbnail_url VARCHAR(255),
    views_count INTEGER DEFAULT 0,
    release_date DATE,
    part_number INTEGER,
    UNIQUE (video_id, part_number)
);

-- Create missing_video_parts table
CREATE TABLE IF NOT EXISTS missing_video_parts (
    id SERIAL PRIMARY KEY,
    video_id INTEGER REFERENCES videos(video_id) ON DELETE CASCADE,
    part_number INTEGER NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (video_id, part_number)
);

-- Create tags table
CREATE TABLE IF NOT EXISTS tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create video_tags table
CREATE TABLE IF NOT EXISTS video_tags (
    video_id INTEGER REFERENCES videos(video_id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (video_id, tag_id)
);

-- Create comments table
CREATE TABLE IF NOT EXISTS comments (
    comment_id SERIAL PRIMARY KEY,
    video_id INT REFERENCES videos(video_id) ON DELETE CASCADE,
    user_id INT REFERENCES users(user_id) ON DELETE SET NULL,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create genres table
CREATE TABLE IF NOT EXISTS genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create video_genres table
CREATE TABLE IF NOT EXISTS video_genres (
    video_id INTEGER REFERENCES videos(video_id) ON DELETE CASCADE,
    genre_id INTEGER REFERENCES genres(id) ON DELETE CASCADE,
    PRIMARY KEY (video_id, genre_id)
);

-- Adding indexes for frequently queried fields
CREATE INDEX idx_videos_title ON videos(title);
CREATE INDEX idx_video_parts_filename ON video_parts(filename);
CREATE INDEX idx_video_parts_status ON video_parts(status_id);
CREATE INDEX idx_tags_name ON tags(name);
CREATE INDEX idx_genres_name ON genres(name);

-- Adding triggers to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_videos_updated_at BEFORE UPDATE ON videos FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_video_parts_updated_at BEFORE UPDATE ON video_parts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tags_updated_at BEFORE UPDATE ON tags FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON comments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_genres_updated_at BEFORE UPDATE ON genres FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert some initial data into the categories table
DO $$
BEGIN
    INSERT INTO categories (name, description) VALUES
        ('Documentary', 'Documentary films that tell real-life stories.'),
        ('Action', 'Action-packed videos full of thrill and excitement.'),
        ('Comedy', 'Humorous videos designed to make you laugh.'),
        ('Drama', 'Dramatic films that focus on realistic storytelling.')
    ON CONFLICT (name) DO NOTHING;  -- Prevent error if already exists
END $$;

-- Insert some initial data into the users table
DO $$
BEGIN
    INSERT INTO users (username, password, email) VALUES
        ('admin', 'password123', 'admin@example.com'),
        ('user1', 'password123', 'user1@example.com')
    ON CONFLICT (username) DO NOTHING;  -- Prevent error if already exists
END $$;

-- Insert initial videos data
DO $$
BEGIN
    INSERT INTO videos (title, description, url, category_id, user_id) VALUES
        ('Nature Documentary', 'A beautiful glimpse into nature.', 'http://example.com/nature.mp4', 1, 1),
        ('Epic Action Movie', 'An action-packed adventure.', 'http://example.com/action.mp4', 2, 1),
        ('Stand-Up Comedy Show', 'A night filled with laughter.', 'http://example.com/comedy.mp4', 3, 2)
    ON CONFLICT (title) DO NOTHING;  -- Prevent error if already exists
END $$;

-- Insert some initial comments
DO $$
BEGIN
    INSERT INTO comments (video_id, user_id, comment_text) VALUES
        (1, 2, 'What a beautiful documentary!'),
        (2, 1, 'I loved the action scenes!')
    ON CONFLICT DO NOTHING;  -- Prevent error if already exists
END $$;

-- Insert initial data into the status table
DO $$
BEGIN
    INSERT INTO status (name) VALUES
        ('Available'),
        ('Checked Out'),
        ('Reserved'),
        ('Lost')
    ON CONFLICT (name) DO NOTHING;  -- Prevent error if already exists
END $$;

-- Insert initial data into the device table
DO $$
BEGIN
    INSERT INTO device (name, mount_path) VALUES
        ('PC', '/mnt/pc'),
        ('Laptop', '/mnt/laptop'),
        ('Mobile', '/mnt/mobile'),
        ('Tablet', '/mnt/tablet'),
        ('Other', '/mnt/other')
    ON CONFLICT (name) DO NOTHING;  -- Prevent error if already exists
END $$;
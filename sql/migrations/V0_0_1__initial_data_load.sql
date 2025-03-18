-- V0.0.1__initial_data_insertion.sql
-- Purpose: Populate ReelSync Database with Initial Realistic Test Data
-- Date: 2025-03-13

-- Categories
INSERT INTO category (name, description, uuid, created_at, updated_at)
VALUES ('Action', 'Action-packed movies', uuid_generate_v4(), NOW(), NOW()),
       ('Comedy', 'Humorous and entertaining movies', uuid_generate_v4(), NOW(), NOW()),
       ('Drama', 'Serious and narrative-driven movies', uuid_generate_v4(), NOW(), NOW()),
       ('Documentary', 'Informative and factual movies', uuid_generate_v4(), NOW(), NOW()),
       ('Science Fiction', 'Futuristic and speculative movies', uuid_generate_v4(), NOW(), NOW()),
       ('Horror', 'Scary and thrilling movies', uuid_generate_v4(), NOW(), NOW()),
       ('Thriller', 'Suspenseful and exciting movies', uuid_generate_v4(), NOW(), NOW()),
       ('Romance', 'Love and relationship movies', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Studios
INSERT INTO studio (name, description, uuid, created_at, updated_at)
VALUES ('Universal Pictures', 'Major American film studio', uuid_generate_v4(), NOW(), NOW()),
       ('Warner Bros.', 'American entertainment company', uuid_generate_v4(), NOW(), NOW()),
       ('Netflix Originals', 'Original content produced by Netflix', uuid_generate_v4(), NOW(), NOW()),
       ('Disney Studios', 'American diversified multinational entertainment', uuid_generate_v4(), NOW(), NOW()),
       ('HBO', 'American premium television network', uuid_generate_v4(), NOW(), NOW()),
       ('Paramount Pictures', 'American film studio', uuid_generate_v4(), NOW(), NOW()),
       ('Sony Pictures', 'American entertainment company', uuid_generate_v4(), NOW(), NOW()),
       ('BBC', 'British Broadcasting Corporation', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Storage Device Types
INSERT INTO storage_device_type (type, description, uuid, created_at, updated_at)
VALUES ('HDD', 'Hard Disk Drive', uuid_generate_v4(), NOW(), NOW()),
       ('SSD', 'Solid State Drive', uuid_generate_v4(), NOW(), NOW()),
       ('NVMe', 'Non-Volatile Memory Express', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (type) DO NOTHING;

-- Storage Devices
INSERT INTO storage_device (name, type_id, capacity, used_space, description, base_path, uuid, created_at, updated_at)
VALUES ('Storage Device 1', (SELECT id FROM storage_device_type WHERE type = 'HDD'), 1000000000000, 500000000000,
        'Primary HDD', '/mnt/storage1', uuid_generate_v4(), NOW(), NOW()),
       ('Storage Device 2', (SELECT id FROM storage_device_type WHERE type = 'SSD'), 500000000000, 200000000000,
        'Primary SSD', '/mnt/storage2', uuid_generate_v4(), NOW(), NOW()),
       ('Storage Device 3', (SELECT id FROM storage_device_type WHERE type = 'NVMe'), 2000000000000, 1000000000000,
        'Primary NVMe', '/mnt/storage3', uuid_generate_v4(), NOW(), NOW()),
       ('Storage Device 4', (SELECT id FROM storage_device_type WHERE type = 'HDD'), 1500000000000, 750000000000,
        'Secondary HDD', '/mnt/storage4', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Videos with realistic names
INSERT INTO video (title, description, duration_seconds, rating, is_favorite, is_viewed, is_compilation, category_id,
                   studio_id, production_date, uuid, created_at, updated_at)
VALUES ('Inception', 'A thief who steals corporate secrets through dream-sharing technology.', 8880, 4.8, TRUE, TRUE,
        FALSE, (SELECT id FROM category WHERE name = 'Science Fiction'),
        (SELECT id FROM studio WHERE name = 'Warner Bros.'), '2010-07-16', uuid_generate_v4(), NOW(), NOW()),
       ('The Shawshank Redemption', 'Two imprisoned men bond over a number of years.', 8520, 4.9, TRUE, TRUE, FALSE,
        (SELECT id FROM category WHERE name = 'Drama'), (SELECT id FROM studio WHERE name = 'Universal Pictures'),
        '1994-09-23', uuid_generate_v4(), NOW(), NOW()),
       ('Planet Earth', 'A documentary series showcasing our natural wonders.', 32400, 4.8, FALSE, TRUE, TRUE,
        (SELECT id FROM category WHERE name = 'Documentary'), (SELECT id FROM studio WHERE name = 'BBC'), '2006-03-05',
        uuid_generate_v4(), NOW(), NOW()),
       ('The Dark Knight', 'Batman faces the Joker in Gotham City.', 9120, 4.7, TRUE, TRUE, FALSE,
        (SELECT id FROM category WHERE name = 'Action'), (SELECT id FROM studio WHERE name = 'Warner Bros.'),
        '2008-07-18', uuid_generate_v4(), NOW(), NOW()),
       ('Forrest Gump', 'The story of a man with a low IQ who achieves great things.', 8520, 4.8, TRUE, TRUE, FALSE,
        (SELECT id FROM category WHERE name = 'Drama'), (SELECT id FROM studio WHERE name = 'Paramount Pictures'),
        '1994-07-06', uuid_generate_v4(), NOW(), NOW()),
       ('The Matrix', 'A computer hacker learns about the true nature of reality.', 8160, 4.7, TRUE, TRUE, FALSE,
        (SELECT id from category WHERE name = 'Science Fiction'), (SELECT id FROM studio WHERE name = 'Warner Bros.'),
        '1999-03-31', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (title) DO NOTHING;

-- Files associated with the videos
INSERT INTO file (video_id, storage_device_id, file_name, file_path, sequence_number, file_size, format,
                  duration_seconds, resolution, codec, bitrate, description, uuid, created_at, updated_at)
VALUES ((SELECT id FROM video WHERE title = 'The Shawshank Redemption'),
        (SELECT id FROM storage_device WHERE name = 'Storage Device 1'), 'shawshank_redemption_hd.mp4',
        '/mnt/storage1/shawshank_redemption_hd.mp4', 1, 3200000000, 'mp4', 8520, '1920x1080', 'H.264', 8000,
        'Main video file', uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'The Shawshank Redemption'),
        (SELECT id FROM storage_device WHERE name = 'Storage Device 1'), 'shawshank_bonus_features.mp4',
        '/mnt/storage1/shawshank_bonus.mp4', 2, 1500000000, 'mp4', 1800, '1280x720', 'H.264', 5000, 'Bonus features',
        uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'Inception'),
        (SELECT id FROM storage_device WHERE name = 'Storage Device 2'), 'inception_1080p.mp4',
        '/mnt/storage2/inception_1080p.mp4', 1, 2500000000, 'mp4', 8880, '1920x1080', 'H.264', 10000, 'Main video file',
        uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'The Shawshank Redemption'),
        (SELECT id FROM storage_device WHERE name = 'Storage Device 1'), 'shawshank_directors_commentary.mp4',
        '/mnt/storage1/shawshank_commentary.mp4', 3, 800000000, 'mp4', 8520, '1920x1080', 'H.264', 5000, 'Director''s commentary',
        uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'Planet Earth'),
        (SELECT id FROM storage_device WHERE name = 'Storage Device 2'), 'planet_earth_episode_1.mp4',
        '/mnt/storage2/planet_earth_ep1.mp4', 1, 2200000000, 'mp4', 3600, '3840x2160', 'HEVC', 12000, 'Episode 1',
        uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'The Dark Knight'),
        (SELECT id FROM storage_device WHERE name = 'Storage Device 3'), 'dark_knight_1080p.mp4',
        '/mnt/storage3/dark_knight_1080p.mp4', 1, 3000000000, 'mp4', 9120, '1920x1080', 'H.264', 9000, 'Main video file',
        uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'Forrest Gump'),
        (SELECT id FROM storage_device WHERE name = 'Storage Device 4'), 'forrest_gump_hd.mp4',
        '/mnt/storage4/forrest_gump_hd.mp4', 1, 2800000000, 'mp4', 8520, '1920x1080', 'H.264', 8500, 'Main video file',
        uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'The Matrix'),
        (SELECT id FROM storage_device WHERE name = 'Storage Device 2'), 'matrix_1080p.mp4', '/mnt/storage2/matrix_1080p.mp4',
        1, 2600000000, 'mp4', 8160, '1920x1080', 'H.264', 9500, 'Main video file', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (file_path, file_name) DO NOTHING;

-- Tags
INSERT INTO tag (name, description, uuid, created_at, updated_at)
VALUES ('Inspirational', 'Inspiring content', uuid_generate_v4(), NOW(), NOW()),
       ('Nature', 'Nature-related content', uuid_generate_v4(), NOW(), NOW()),
       ('Crime', 'Crime-related content', uuid_generate_v4(), NOW(), NOW()),
       ('Adventure', 'Adventure-related content', uuid_generate_v4(), NOW(), NOW()),
       ('Thriller', 'Thrilling content', uuid_generate_v4(), NOW(), NOW()),
       ('Romantic', 'Romantic content', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Video Tags
INSERT INTO video_tag (video_id, tag_id, uuid, created_at, updated_at)
SELECT (SELECT id FROM video WHERE title = 'The Shawshank Redemption'),
       (SELECT id FROM tag WHERE name = 'Inspirational'), uuid_generate_v4(), NOW(), NOW()
ON CONFLICT (video_id, tag_id) DO NOTHING;

-- File Tags
INSERT INTO file_tag (file_id, tag_id, uuid, created_at, updated_at)
SELECT (SELECT id FROM file WHERE file_name = 'shawshank_bonus_features.mp4'),
       (SELECT id FROM tag WHERE name = 'Adventure'), uuid_generate_v4(), NOW(), NOW()
ON CONFLICT (file_id, tag_id) DO NOTHING;

-- Persons
INSERT INTO person (name, description, uuid, created_at, updated_at)
VALUES ('Leonardo DiCaprio', 'American actor and film producer', uuid_generate_v4(), NOW(), NOW()),
       ('Morgan Freeman', 'American actor, director, and narrator', uuid_generate_v4(), NOW(), NOW()),
       ('David Attenborough', 'English broadcaster and natural historian', uuid_generate_v4(), NOW(), NOW()),
       ('Christian Bale', 'English actor', uuid_generate_v4(), NOW(), NOW()),
       ('Tom Hanks', 'American actor and filmmaker', uuid_generate_v4(), NOW(), NOW()),
       ('Keanu Reeves', 'Canadian actor', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Roles
INSERT INTO role (name, description, uuid, created_at, updated_at)
VALUES ('Actor', 'Performs in movies', uuid_generate_v4(), NOW(), NOW()),
       ('Director', 'Directs movies', uuid_generate_v4(), NOW(), NOW()),
       ('Narrator', 'Narrates documentaries', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Video Roles
INSERT INTO video_role (video_id, person_id, role_id, uuid, created_at, updated_at)
VALUES ((SELECT id FROM video WHERE title = 'Inception'),
        (SELECT id FROM person WHERE name = 'Leonardo DiCaprio'),
        (SELECT id FROM role WHERE name = 'Actor'), uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'The Shawshank Redemption'),
        (SELECT id FROM person WHERE name = 'Morgan Freeman'),
        (SELECT id FROM role WHERE name = 'Actor'), uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'Planet Earth'),
        (SELECT id FROM person WHERE name = 'David Attenborough'),
        (SELECT id FROM role WHERE name = 'Narrator'), uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'The Dark Knight'),
        (SELECT id FROM person WHERE name = 'Christian Bale'),
        (SELECT id FROM role WHERE name = 'Actor'), uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'Forrest Gump'),
        (SELECT id FROM person WHERE name = 'Tom Hanks'),
        (SELECT id FROM role WHERE name = 'Actor'), uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'The Matrix'),
        (SELECT id FROM person WHERE name = 'Keanu Reeves'),
        (SELECT id FROM role WHERE name = 'Actor'), uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (video_id, person_id, role_id) DO NOTHING;

-- Log Levels
INSERT INTO log_level (name, description, uuid, created_at, updated_at)
VALUES ('INFO', 'Informational messages', uuid_generate_v4(), NOW(), NOW()),
       ('WARNING', 'Warning messages', uuid_generate_v4(), NOW(), NOW()),
       ('ERROR', 'Error messages', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Logs
INSERT INTO log (log_level_id, message, uuid, created_at, updated_at)
VALUES ((SELECT id FROM log_level WHERE name = 'INFO'), 'System initialized successfully.', uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM log_level WHERE name = 'WARNING'), 'Disk space running low on Storage Device 1.', uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM log_level WHERE name = 'ERROR'), 'Failed to upload video file.', uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM log_level WHERE name = 'INFO'), 'New video added to the database.', uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM log_level WHERE name = 'WARNING'), 'High CPU usage detected.', uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM log_level WHERE name = 'ERROR'), 'Database connection lost.', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (message) DO NOTHING;

-- Metadata Sources
INSERT INTO metadata_source (name, description, uuid, created_at, updated_at)
VALUES ('IMDb', 'Internet Movie Database', uuid_generate_v4(), NOW(), NOW()),
       ('Rotten Tomatoes', 'Movie review aggregator', uuid_generate_v4(), NOW(), NOW()),
       ('Metacritic', 'Review aggregator for movies', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Metadata Types
INSERT INTO metadata_type (name, description, uuid, created_at, updated_at)
VALUES ('Director', 'Director of the movie', uuid_generate_v4(), NOW(), NOW()),
       ('Awards', 'Awards won by the person', uuid_generate_v4(), NOW(), NOW()),
       ('Notable Works', 'Notable works of the person', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Metadata
INSERT INTO metadata (entity_id, metadata_type_id, key, value, uuid, created_at, updated_at)
VALUES ((SELECT id FROM video WHERE title = 'Inception'),
        (SELECT id FROM metadata_type WHERE name = 'Director'), 'Director', 'Christopher Nolan', uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'The Matrix'),
        (SELECT id FROM metadata_type WHERE name = 'Director'), 'Director', 'Lana Wachowski, Lilly Wachowski', uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM video WHERE title = 'The Dark Knight'),
        (SELECT id FROM metadata_type WHERE name = 'Director'), 'Director', 'Christopher Nolan', uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM person WHERE name = 'Leonardo DiCaprio'),
        (SELECT id FROM metadata_type WHERE name = 'Awards'), 'Awards', 'Academy Award for Best Actor', uuid_generate_v4(), NOW(), NOW()),
       ((SELECT id FROM person WHERE name = 'Morgan Freeman'),
        (SELECT id FROM metadata_type WHERE name = 'Notable Works'), 'Notable Works', 'Shawshank Redemption, Seven', uuid_generate_v4(), NOW(), NOW())
ON CONFLICT (entity_id, key, metadata_type_id) DO NOTHING;
/**************************************************
 * ReelSync Database Schema
 * 
 * This file defines the database schema for ReelSync, 
 * a video metadata management system. It includes tables, 
 * constraints, indexes, views, and triggers.
 * 
 * - Tables: Define core entities.
 * - Constraints: Enforce data integrity.
 * - Indexes: Optimize query performance.
 * - Views: Provide simplified access to data.
 * - Triggers: Automate system behaviors.
 * 
 * Generated on: 2025-03-15
 **************************************************/

-- Flyway Baseline Version
-- Version: 0.0.0
-- Description: Initial setup

CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tables: Defines core entities for ReelSync.
CREATE TABLE category(
    id serial PRIMARY KEY,
    name text NOT NULL,
    description text,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    CONSTRAINT chk_category_name_length CHECK (char_length(name) > 0),
    CONSTRAINT unique_category_name UNIQUE (name)
);

CREATE TABLE studio(
    id serial PRIMARY KEY,
    name text NOT NULL,
    description text,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    CONSTRAINT chk_studio_name_length CHECK (char_length(name) > 0),
    CONSTRAINT unique_studio_name UNIQUE (name)
);

CREATE TABLE storage_device_type(
    id serial PRIMARY KEY,
    type TEXT NOT NULL,
    description text,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    CONSTRAINT chk_storage_device_type_length CHECK (char_length(type) > 0),
    CONSTRAINT unique_storage_device_type UNIQUE (type)
);

CREATE TABLE storage_device(
    id serial PRIMARY KEY,
    name text NOT NULL,
    type_id integer NOT NULL,
    capacity bigint NOT NULL,
    used_space bigint NOT NULL,
    description text,
    base_path text NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    CONSTRAINT chk_storage_device_name_length CHECK (char_length(name) > 0),
    CONSTRAINT chk_storage_device_capacity CHECK (capacity > 0),
    CONSTRAINT chk_storage_device_used_space CHECK (used_space >= 0),
    CONSTRAINT chk_storage_device_base_path_length CHECK (char_length(base_path) > 0),
    CONSTRAINT fk_storage_device_type_id FOREIGN KEY (type_id) REFERENCES storage_device_type(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_storage_device_name UNIQUE (name)
);

CREATE TABLE video(
    id serial PRIMARY KEY,
    title text NOT NULL,
    description text,
    duration_seconds integer,
    rating numeric(3, 2),
    is_favorite boolean,
    is_viewed boolean,
    is_compilation boolean,
    category_id integer NOT NULL,
    studio_id integer NOT NULL,
    production_date date,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    search_vector tsvector,
    CONSTRAINT chk_video_title_length CHECK (char_length(title) > 0),
    CONSTRAINT chk_video_duration_seconds CHECK (duration_seconds >= 0),
    CONSTRAINT chk_video_rating CHECK (rating >= 0 AND rating <= 10),
    CONSTRAINT fk_video_category_id FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_video_studio_id FOREIGN KEY (studio_id) REFERENCES studio(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT unique_video_title UNIQUE (title)
);

CREATE TABLE file(
    id serial PRIMARY KEY,
    video_id integer NOT NULL,
    storage_device_id integer NOT NULL,
    file_name text NOT NULL,
    file_path text NOT NULL,
    sequence_number integer,
    file_size bigint,
    format text,
    duration_seconds integer,
    resolution text,
    codec text,
    bitrate integer,
    description text,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    search_vector tsvector,
    CONSTRAINT chk_file_name_length CHECK (char_length(file_name) > 0),
    CONSTRAINT chk_file_sequence_number CHECK (sequence_number >= 0),
    CONSTRAINT chk_file_size CHECK (file_size >= 0),
    CONSTRAINT chk_file_duration_seconds CHECK (duration_seconds >= 0),
    CONSTRAINT chk_file_bitrate CHECK (bitrate >= 0),
    CONSTRAINT fk_file_video_id FOREIGN KEY (video_id) REFERENCES video(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_file_storage_device_id FOREIGN KEY (storage_device_id) REFERENCES storage_device(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_file_path_name UNIQUE (file_path, file_name)
);

CREATE TABLE tag(
    id serial PRIMARY KEY,
    name text NOT NULL,
    description text,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    search_vector tsvector,
    CONSTRAINT chk_tag_name_length CHECK (char_length(name) > 0),
    CONSTRAINT unique_tag_name UNIQUE (name)
);

CREATE TABLE video_tag(
    id serial PRIMARY KEY,
    video_id integer NOT NULL,
    tag_id integer NOT NULL,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    CONSTRAINT fk_video_tag_video_id FOREIGN KEY (video_id) REFERENCES video(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_video_tag_tag_id FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_video_tag UNIQUE (video_id, tag_id)
);

CREATE TABLE file_tag(
    id serial PRIMARY KEY,
    file_id integer NOT NULL,
    tag_id integer NOT NULL,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    CONSTRAINT fk_file_tag_file_id FOREIGN KEY (file_id) REFERENCES file(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_file_tag_tag_id FOREIGN KEY (tag_id) REFERENCES tag(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_file_tag UNIQUE (file_id, tag_id)
);

CREATE TABLE person(
    id serial PRIMARY KEY,
    name text NOT NULL,
    description text,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    CONSTRAINT chk_person_name_length CHECK (char_length(name) > 0),
    CONSTRAINT unique_person_name UNIQUE (name)
);

CREATE TABLE role (
    id serial PRIMARY KEY,
    name text NOT NULL,
    description text,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    CONSTRAINT chk_role_name_length CHECK (char_length(name) > 0),
    CONSTRAINT unique_role_name UNIQUE (name)
);

CREATE TABLE video_role(
    id serial PRIMARY KEY,
    video_id integer NOT NULL,
    person_id integer NOT NULL,
    role_id integer NOT NULL,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    CONSTRAINT fk_video_role_video_id FOREIGN KEY (video_id) REFERENCES video(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_video_role_person_id FOREIGN KEY (person_id) REFERENCES person(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_video_role_role_id FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_video_role UNIQUE (video_id, person_id, role_id)
);

CREATE TABLE log_level(
    id serial PRIMARY KEY,
    name text NOT NULL,
    description text,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    CONSTRAINT chk_log_level_name_length CHECK (char_length(name) > 0),
    CONSTRAINT unique_log_level_name UNIQUE (name)
);

CREATE TABLE log (
    id serial PRIMARY KEY,
    log_level_id integer NOT NULL,
    message text NOT NULL,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    search_vector tsvector,
    CONSTRAINT fk_log_log_level_id FOREIGN KEY (log_level_id) REFERENCES log_level(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT unique_log_message UNIQUE (message)
);

CREATE TABLE metadata_type(
    id serial PRIMARY KEY,
    name text NOT NULL,
    description text,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    CONSTRAINT chk_metadata_type_name_length CHECK (char_length(name) > 0),
    CONSTRAINT unique_metadata_type_name UNIQUE (name)
);

CREATE TABLE metadata_source(
    id serial PRIMARY KEY,
    name text NOT NULL,
    description text,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    CONSTRAINT chk_metadata_source_name_length CHECK (char_length(name) > 0),
    CONSTRAINT unique_metadata_source_name UNIQUE (name)
);

CREATE TABLE metadata(
    id serial PRIMARY KEY,
    entity_id integer NOT NULL,
    metadata_type_id integer NOT NULL,
    key TEXT NOT NULL CHECK (char_length(key) > 0),
    value text NOT NULL,
    created_at timestamp DEFAULT NOW() NOT NULL,
    updated_at timestamp DEFAULT NOW() NOT NULL,
    uuid uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    CONSTRAINT fk_metadata_metadata_type_id FOREIGN KEY (metadata_type_id) REFERENCES metadata_type(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_metadata UNIQUE (entity_id, key, metadata_type_id)
);

-- Indexes: Optimized for faster queries.
CREATE INDEX IF NOT EXISTS idx_files_video_id ON file(video_id);
CREATE INDEX IF NOT EXISTS idx_files_file_name ON file(file_name);
CREATE INDEX IF NOT EXISTS idx_videos_category_id ON video(category_id);
CREATE INDEX IF NOT EXISTS idx_videos_studio_id ON video(studio_id);
CREATE INDEX IF NOT EXISTS idx_tags_name ON tag(name);
CREATE INDEX IF NOT EXISTS idx_logs_created_at ON log(created_at);
CREATE INDEX IF NOT EXISTS idx_videos_search_vector_gin ON video USING GIN(search_vector);
CREATE INDEX IF NOT EXISTS idx_files_search_vector_gin ON file USING GIN(search_vector);
CREATE INDEX IF NOT EXISTS idx_tags_search_vector_gin ON tag USING GIN(search_vector);
CREATE INDEX IF NOT EXISTS idx_logs_search_vector_gin ON log USING GIN(search_vector);
CREATE INDEX IF NOT EXISTS idx_storage_device_type_id ON storage_device(type_id);
CREATE INDEX IF NOT EXISTS idx_video_category_id ON video(category_id);
CREATE INDEX IF NOT EXISTS idx_video_studio_id ON video(studio_id);
CREATE INDEX IF NOT EXISTS idx_file_video_id ON file(video_id);
CREATE INDEX IF NOT EXISTS idx_file_storage_device_id ON file(storage_device_id);
CREATE INDEX IF NOT EXISTS idx_video_tag_video_id ON video_tag(video_id);
CREATE INDEX IF NOT EXISTS idx_video_tag_tag_id ON video_tag(tag_id);
CREATE INDEX IF NOT EXISTS idx_file_tag_file_id ON file_tag(file_id);
CREATE INDEX IF NOT EXISTS idx_file_tag_tag_id ON file_tag(tag_id);
CREATE INDEX IF NOT EXISTS idx_video_role_video_id ON video_role(video_id);
CREATE INDEX IF NOT EXISTS idx_video_role_person_id ON video_role(person_id);
CREATE INDEX IF NOT EXISTS idx_video_role_role_id ON video_role(role_id);
CREATE INDEX IF NOT EXISTS idx_log_log_level_id ON log(log_level_id);
CREATE INDEX IF NOT EXISTS idx_metadata_metadata_type_id ON metadata(metadata_type_id);

-- Triggers: Automates system behaviors.
CREATE FUNCTION trigger_set_timestamp()
    RETURNS TRIGGER
    AS $$
BEGIN
    IF NEW.* IS DISTINCT FROM OLD.* THEN
        NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION to_snake_case(text)
    RETURNS text
    AS $$
BEGIN
    RETURN lower(regexp_replace(regexp_replace(regexp_replace($1, '[^a-zA-Z0-9\s]', '', 'g'),
                '([a-z\d])([A-Z])|([A-Z]+)([A-Z][a-z])', '\1\3_\2\4', 'g'),
            '\s+', '_', 'g')
);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_file_path()
    RETURNS TRIGGER
    AS $$
DECLARE
    storage_base_path text;
    video_title text;
BEGIN
    SELECT base_path INTO storage_base_path
    FROM storage_device
    WHERE id = NEW.storage_device_id;
    
    SELECT title INTO video_title
    FROM video
    WHERE id = NEW.video_id;
    
    NEW.file_path := storage_base_path || '/' || to_snake_case(video_title) || '/' || NEW.file_name;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trg_videos_updated_at
    BEFORE UPDATE ON video
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_files_updated_at
    BEFORE UPDATE ON file
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_categories_updated_at
    BEFORE UPDATE ON category
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_tags_updated_at
    BEFORE UPDATE ON tag
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_metadata_sources_updated_at
    BEFORE UPDATE ON metadata_source
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_studios_updated_at
    BEFORE UPDATE ON studio
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_storage_device_types_updated_at
    BEFORE UPDATE ON storage_device_type
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_storage_devices_updated_at
    BEFORE UPDATE ON storage_device
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_video_tags_updated_at
    BEFORE UPDATE ON video_tag
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_file_tags_updated_at
    BEFORE UPDATE ON file_tag
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_people_updated_at
    BEFORE UPDATE ON person
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_roles_updated_at
    BEFORE UPDATE ON role
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_video_roles_updated_at
    BEFORE UPDATE ON video_role
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_log_levels_updated_at
    BEFORE UPDATE ON log_level
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_logs_updated_at
    BEFORE UPDATE ON log
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_metadata_types_updated_at
    BEFORE UPDATE ON metadata_type
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_metadata_updated_at
    BEFORE UPDATE ON metadata
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER trg_set_file_path
    BEFORE INSERT OR UPDATE ON file
    FOR EACH ROW
    EXECUTE FUNCTION set_file_path();

CREATE MATERIALIZED VIEW view_video_file_counts AS
SELECT
    video_id,
    COUNT(*) AS file_count
FROM
    file
GROUP BY
    video_id;

-- First, ensure you have the necessary extensions installed and enabled in your database:
-- This requires installing the PostGIS and pgvector packages on your EC2 instance
-- and then enabling them within your specific database using these commands:
-- CREATE EXTENSION postgis;
-- CREATE EXTENSION vector;
DROP TABLE IF EXISTS users CASCADE;
-- Create the users table
CREATE TABLE users (
    -- Basic User Information
    id SERIAL PRIMARY KEY, -- Auto-incrementing primary key
    email VARCHAR(255) UNIQUE, -- Add UNIQUE constraint for emails
    full_name VARCHAR(255),
    date_of_birth DATE, -- Storing as TEXT to match Mongoose, consider DATE or TIMESTAMP if format is consistent
    gender VARCHAR(50),
    user_id VARCHAR(255) UNIQUE, -- Add UNIQUE constraint for user_id
    bio TEXT, -- Use TEXT for potentially longer strings
    profile_image TEXT, -- URL or key to the image

    -- Other Images (Stored as JSONB array)
    other_images JSONB DEFAULT '[]'::JSONB, -- Array of { location: string, key: string } objects

    -- Location Information (Requires PostGIS)
    -- GEOMETRY(Point, 4326) stores the latitude and longitude
    location_point GEOMETRY(Point, 4326), -- SRID 4326 for WGS 84
    location_pincode INTEGER,
    location_city VARCHAR(255),
    location_state VARCHAR(255),
    location_address TEXT,
    account_status VARCHAR(50) DEFAULT 'ACTIVE',
    -- Interests (Stored as PostgreSQL array)
    interests TEXT[] DEFAULT '{}', -- Array of strings

    -- Looking For
    looking_for VARCHAR(255),

    -- Account Status (Consider using an ENUM type for stricter values)
   
    -- Embedding Vectors (Requires pgvector)
    -- You need to specify the dimension of your vectors (e.g., 1536 for OpenAI embeddings)
    profile_embedding VECTOR(1024), -- Replace 1536 with your actual vector dimension
    wanted_embedding VECTOR(1024), -- Replace 1536 with your actual vector dimension

    -- Timestamps (Common practice in SQL databases)
   
);

-- Add indexes based on your Mongoose schema definitions

-- Geospatial index on location_point (Requires PostGIS)
CREATE INDEX users_location_point_gist ON users USING GIST (location_point);

-- Standard B-tree index on full_name
CREATE INDEX users_full_name_idx ON users (full_name);

-- Compound index for common filters: gender, looking_for, and interests
-- Indexing array columns directly might have limitations depending on query patterns.
-- Consider using a GIN index on the interests column if you frequently query for specific interests within the array.
CREATE INDEX users_gender_looking_for_interests_idx ON users (gender, looking_for, interests);

-- Separate index on date_of_birth
CREATE INDEX users_date_of_birth_idx ON users (date_of_birth);


-- Partial index for active users only
-- Note: The partial index condition is based on SQL syntax, not MongoDB syntax
CREATE INDEX users_active_filter_idx ON users (gender, looking_for, interests, date_of_birth)
WHERE account_status = 'ACTIVE';


-- Indexes for pgvector columns (Requires pgvector)
-- Choose the appropriate index type (IVFFlat or HNSW) based on your needs (indexing speed vs. query performance/recall)
-- Replace 1536 with your actual vector dimension and adjust parameters (lists, m, ef_construction) as needed.
-- Use the correct operator class (vector_cosine_ops, vector_l2_ops, vector_inner_product_ops)
-- based on your embedding model's similarity metric.

-- Example IVFFlat index:
-- CREATE INDEX users_profile_embedding_ivf ON users USING ivfflat (profile_embedding vector_cosine_ops) WITH (lists = 100);
-- CREATE INDEX users_wanted_embedding_ivf ON users USING ivfflat (wanted_embedding vector_cosine_ops) WITH (lists = 100);

-- Example HNSW index (often preferred for search performance):
CREATE INDEX users_profile_embedding_hnsw ON users USING hnsw (profile_embedding vector_cosine_ops) WITH (m = 16, ef_construction = 64);
CREATE INDEX users_wanted_embedding_hnsw ON users USING hnsw (wanted_embedding vector_cosine_ops) WITH (m = 16, ef_construction = 64);


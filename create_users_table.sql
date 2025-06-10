-- First, ensure required extensions are enabled
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS vector;

-- Create the users table with camelCase column names
CREATE TABLE users (
    "userId" UUID PRIMARY KEY,                      -- Primary key
    email VARCHAR(255),                    -- Unique email
    "fullName" VARCHAR(255),
    "dateOfBirth" DATE,
    gender VARCHAR(50),
    bio TEXT,
    "profileImage" TEXT,

    "otherImages" JSONB DEFAULT '[]'::JSONB,        -- Array of images

    "locationPoint" GEOMETRY(Point, 4326),          -- PostGIS point
    "locationPincode" INTEGER,
    "locationCity" VARCHAR(255),
    "locationState" VARCHAR(255),
    "locationAddress" TEXT,
    "profileCompliments" TEXT[];
    "accountStatus" VARCHAR(50) DEFAULT 'ACTIVE',

    interests TEXT[] DEFAULT '{}',                -- Array of strings

    "lookingFor" VARCHAR(255),

    "profileEmbedding" VECTOR(1024),
    "wantedEmbedding" VECTOR(1024)
);

-- Geospatial index on locationPoint
CREATE INDEX users_locationPoint_gist ON users USING GIST (locationPoint);

-- B-tree index on fullName
CREATE INDEX users_fullName_idx ON users (fullName);

-- GIN index on interests for array membership queries
CREATE INDEX users_interests_gin ON users USING GIN (interests);

-- Compound B-tree index on gender, lookingFor, and dateOfBirth
CREATE INDEX users_gender_lookingFor_dob_idx
  ON users (gender, lookingFor, dateOfBirth);

-- Partial index for active users
CREATE INDEX users_active_filter_idx
  ON users (gender, lookingFor, dateOfBirth)
  WHERE accountStatus = 'ACTIVE';

-- HNSW vector indexes (pgvector)
CREATE INDEX users_profileEmbedding_hnsw
  ON users USING hnsw (profileEmbedding vector_cosine_ops)
  WITH (m = 16, ef_construction = 64);

CREATE INDEX users_wantedEmbedding_hnsw
  ON users USING hnsw (wantedEmbedding vector_cosine_ops)
  WITH (m = 16, ef_construction = 64);
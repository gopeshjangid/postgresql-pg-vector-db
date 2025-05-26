-- Drop the existing activities table if it exists to allow recreation
DROP TABLE IF EXISTS activities CASCADE;

-- Create the activities table
CREATE TABLE activities (
    id SERIAL PRIMARY KEY, -- Maps to MongoDB's _id, auto-incrementing integer
    connection_id UUID,     -- Assuming connectionId is a UUID string. Use VARCHAR(255) if not strictly UUID.
    type VARCHAR(255),      -- Stores the activity type (e.g., 'ACTIVITY')
    image_url JSONB DEFAULT '[]'::jsonb, -- Stores an array of image URLs/objects. JSONB is flexible.
    mood VARCHAR(255),      -- Stores the mood (e.g., 'HAPPY')
    author_id VARCHAR(255),  
    caption VARCHAR(225) , 
    author_full_name VARCHAR(225),
    author_profile_image VARCHAR(225),  -- Assuming author is a UUID string (likely referencing a user ID). Use VARCHAR(255) if not strictly UUID.
    reactions JSONB DEFAULT '[]'::jsonb, -- Stores an array of reaction objects/data. JSONB is flexible.
    stickers JSONB DEFAULT '[]'::jsonb, -- Stores an array of sticker objects/data. JSONB is flexible.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Stores creation timestamp
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP -- REMOVED TRAILING COMMA HERE
);

-- Optional: Add indexes for frequently queried columns to improve performance
-- For example, if you often query by connection_id, author_id, or type:
CREATE INDEX idx_activities_connection_id ON activities (connection_id);
CREATE INDEX idx_activities_author_id ON activities (author_id);
CREATE INDEX idx_activities_type ON activities (type);
CREATE INDEX idx_activities_created_at ON activities (created_at DESC); -- For chronological queries

-- Note: The '__v' field from MongoDB is a version key specific to Mongoose/MongoDB
-- and is generally not replicated in a relational database schema.
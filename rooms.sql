DROP TABLE IF EXISTS rooms CASCADE;

-- Create the rooms table
CREATE TABLE rooms (
    id SERIAL PRIMARY KEY, -- Maps to MongoDB's _id, auto-incrementing integer
    user_id UUID NOT NULL, -- The ID of the first user in the room
    connection_user_id UUID NOT NULL, -- The ID of the second user in the room

    -- connection_id is a UUID in MongoDB. Note that your 'connections' table's PRIMARY KEY 'id' is SERIAL.
    -- If this 'connection_id' is intended to be a foreign key to the 'connections' table,
    -- the 'connections' table would need a UUID column for this purpose, or 'connections.id'
    -- would need to be a UUID itself. For now, it's a UUID column without a direct FK to 'connections.id'.
    connection_id UUID NOT NULL,

    last_message TEXT, -- Stores the last message in the chat room (nullable)
    last_sender_id UUID, -- The ID of the user who sent the last message (nullable)
    last_message_type VARCHAR(255), -- Type of the last message (e.g., 'TEXT', 'IMAGE') (nullable)
    status VARCHAR(255) NOT NULL, -- Status of the room (e.g., 'active', 'archived')
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Stores creation timestamp
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,  -- Stores last update timestamp

    -- Add FOREIGN KEY constraints to link user_id, connection_user_id, and last_sender_id to users.user_id
    -- ON DELETE CASCADE: If a user is deleted, associated room records will also be deleted.
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
   
    -- Add a unique constraint to ensure only one room exists between any two users, regardless of order
    CONSTRAINT unique_room_pair UNIQUE (LEAST(user_id, connection_user_id), GREATEST(user_id, connection_user_id))
);

-- Optional: Add indexes for frequently queried columns to improve performance
CREATE INDEX idx_rooms_user_id ON rooms (user_id);
CREATE INDEX idx_rooms_connection_user_id ON rooms (connection_user_id);
CREATE INDEX idx_rooms_connection_id ON rooms (connection_id); -- Index for the UUID connection_id
CREATE INDEX idx_rooms_status ON rooms (status);
CREATE INDEX idx_rooms_created_at ON rooms (created_at DESC); -- For chronological queries
CREATE INDEX idx_rooms_last_sender_id ON rooms (last_sender_id);

-- Note: The '__v' field from MongoDB is a version key specific to Mongoose/MongoDB
-- and is generally not replicated in a relational database schema.

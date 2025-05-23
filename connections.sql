
DROP TABLE IF EXISTS connections CASCADE;
CREATE TABLE connections (
    id SERIAL PRIMARY KEY, -- Maps to MongoDB's _id, auto-incrementing integer
    user_id UUID NOT NULL, -- The ID of the first user in the connection
    connection_user_id UUID NOT NULL, -- The ID of the second user in the connection
    blocked_users JSONB DEFAULT '[]'::jsonb, -- Stores an array of blocked user IDs within this connection (if applicable)
    status VARCHAR(255) NOT NULL, -- Status of the connection (e.g., 'ACTIVE', 'PENDING', 'BLOCKED')
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Stores creation timestamp
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,  -- Stores last update timestamp

    -- Add FOREIGN KEY constraints to link user_id and connection_user_id to users.user_id
    -- ON DELETE CASCADE: If a user referenced by either user_id or connection_user_id is deleted,
    -- the corresponding connection record will also be deleted. This ensures data integrity.
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    
);

-- Optional: Add indexes for frequently queried columns to improve performance
CREATE INDEX idx_connections_user_id ON connections (user_id);
CREATE INDEX idx_connections_connection_user_id ON connections (connection_user_id);
CREATE INDEX idx_connections_status ON connections (status);
CREATE INDEX idx_connections_created_at ON connections (created_at DESC); -- For chronological queries

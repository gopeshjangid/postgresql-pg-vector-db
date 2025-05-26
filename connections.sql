DROP TABLE IF EXISTS connections CASCADE;
CREATE TABLE connections (
    id SERIAL PRIMARY KEY, -- Maps to MongoDB's _id, auto-incrementing integer
    user_id VARCHAR(225), -- The ID of the first user in the connection
    connection_user_id VARCHAR(225), -- The ID of the second user in the connection
    blocked_users JSONB DEFAULT '[]'::jsonb,
    connection_id VARCHAR(225), -- Stores an array of blocked user IDs within this connection (if applicable)
    status VARCHAR(255), -- Status of the connection (e.g., 'ACTIVE', 'PENDING', 'BLOCKED')
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Stores creation timestamp
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP -- Correct: No trailing comma
    profile_image VARCHAR(225),
    full_name VARCHAR(225) -- Profile image URL of the user in the connection (nullable)
);

-- Optional: Add indexes for frequently queried columns to improve performance
CREATE INDEX idx_connections_user_id ON connections (user_id);
CREATE INDEX idx_connections_connection_user_id ON connections (connection_user_id);
CREATE INDEX idx_connections_status ON connections (status);
CREATE INDEX idx_connections_created_at ON connections (created_at DESC); -- For chronological queries
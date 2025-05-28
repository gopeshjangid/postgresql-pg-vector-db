
CREATE TABLE connections (
    connection_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    connection_user_id UUID NOT NULL,
    blocked_users JSONB DEFAULT '[]'::jsonb,
    status VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    profile_image VARCHAR(255),
    full_name VARCHAR(255)
);

-- Indexes for performance optimization
CREATE INDEX idx_connections_user_id ON connections (user_id);
CREATE INDEX idx_connections_connection_user_id ON connections (connection_user_id);
CREATE INDEX idx_connections_status ON connections (status);
CREATE INDEX idx_connections_created_at ON connections (created_at DESC);
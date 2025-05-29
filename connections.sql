-- Create the connections table with camelCase column names
CREATE TABLE connections (
    "connectionId" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" UUID NOT NULL,
    "connectionUserId" UUID NOT NULL,
    "blockedUsers" JSONB DEFAULT '[]'::jsonb,
    status VARCHAR(255),
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    "profileImage" VARCHAR(255),
    "fullName" VARCHAR(255)
);

-- Indexes for performance optimization
CREATE INDEX idx_connections_userId ON connections (userId);
CREATE INDEX idx_connections_connectionUserId ON connections (connectionUserId);
CREATE INDEX idx_connections_status ON connections (status);
CREATE INDEX idx_connections_createdAt ON connections (createdAt DESC);
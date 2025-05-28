-- Create the activities table with camelCase column names
CREATE TABLE activities (
    activityId UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    connectionUserId UUID,                -- Reference to the related connection
    type VARCHAR(255),                    -- Activity type (e.g., 'ACTIVITY')
    imageUrl JSONB DEFAULT '[]'::JSONB,   -- Array of image URLs/objects
    mood VARCHAR(255),                    -- Mood (e.g., 'HAPPY')
    authorId UUID,                        -- ID of the authoring user
    caption VARCHAR(225),
    authorFullName VARCHAR(225),
    authorProfileImage VARCHAR(225),
    reactions JSONB DEFAULT '[]'::JSONB,  -- Array of reaction objects
    stickers JSONB DEFAULT '[]'::JSONB,   -- Array of sticker objects
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_activities_connectionUserId ON activities (connectionUserId);
CREATE INDEX idx_activities_authorId ON activities (authorId);
CREATE INDEX idx_activities_activityId ON activities (activityId);
CREATE INDEX idx_activities_type ON activities (type);
CREATE INDEX idx_activities_createdAt ON activities (createdAt DESC);
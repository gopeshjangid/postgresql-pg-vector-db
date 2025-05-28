-- Create the rooms table with camelCase column names
DROP TABLE IF EXISTS rooms CASCADE;
CREATE TABLE rooms (
    chatId UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    userId UUID,                      -- The ID of the first user in the room
    connectionUserId UUID,            -- The ID of the second user in the room
    connectionId UUID UNIQUE,         -- Maps to your connections table’s UUID (or needs matching FK)
    lastMessageTimestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    userFullName VARCHAR(225),        -- Full name of the user in the room
    userProfileImage VARCHAR(225),    -- Profile image URL of the user in the room
    lastMessageUnreadCount INTEGER DEFAULT 0,
    lastMessage TEXT,
    lastSenderId VARCHAR(225),
    lastMessageType VARCHAR(255),
    status VARCHAR(255) NOT NULL,
    createdAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    -- , CONSTRAINT uniqueRoomPair UNIQUE (LEAST(userId, connectionUserId), GREATEST(userId, connectionUserId))
);

-- Indexes for performance
CREATE INDEX idx_rooms_userId ON rooms (userId);
CREATE INDEX idx_rooms_chatId ON rooms (chatId);
CREATE INDEX idx_rooms_connectionUserId ON rooms (connectionUserId);
CREATE INDEX idx_rooms_status ON rooms (status);
CREATE INDEX idx_rooms_createdAt ON rooms (createdAt DESC);
CREATE INDEX idx_rooms_lastSenderId ON rooms (lastSenderId);
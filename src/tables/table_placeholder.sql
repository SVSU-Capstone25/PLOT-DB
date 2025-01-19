-- ? File is merely a boilerplate and can be removed once we get more files in this directory.
-- Create Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    UserName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- ? File is merely a boilerplate and can be removed once we get more files in this directory.
-- Create Function to Get User Name by UserID
CREATE FUNCTION GetUserName(@UserID INT)
RETURNS NVARCHAR(50)
AS
BEGIN
    RETURN (SELECT UserName FROM Users WHERE UserID = @UserID);
END;
GO

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

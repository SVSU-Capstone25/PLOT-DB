-- ? File is merely a boilerplate and can be removed once we get more files in this directory.
-- Stored Procedure to Update User Status
CREATE PROCEDURE UpdateUserStatus
    @UserID INT,
    @NewEmail NVARCHAR(255)
AS
BEGIN
    UPDATE Users
    SET Email = @NewEmail
    WHERE UserID = @UserID;

    PRINT 'User email updated successfully.';
END;
GO

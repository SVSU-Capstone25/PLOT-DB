-- ? File is merely a boilerplate and can be removed once we get more files in this directory.
-- Trigger to Log Order Insertions
CREATE TRIGGER LogOrderInsert
ON Orders
AFTER INSERT
AS
BEGIN
    INSERT INTO OrderLogs (OrderID, UserID, LogDate)
    SELECT 
        i.OrderID, 
        i.UserID, 
        GETDATE()
    FROM inserted i;

    PRINT 'Order log created successfully.';
END;
GO

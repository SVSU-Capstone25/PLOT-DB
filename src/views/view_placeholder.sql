-- ? File is merely a boilerplate and can be removed once we get more files in this directory.
-- Create View to Show Users and Their Orders
CREATE VIEW UserOrdersView AS
SELECT 
    u.UserID,
    u.UserName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Users u
LEFT JOIN Orders o ON u.UserID = o.UserID;
GO

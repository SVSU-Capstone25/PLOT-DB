/*
Filename: userFunctions.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions pertaining to user-related information and role assignments.

Written by: Krzysztof Hejno
*/

-- Function: Get User Role by UserTUID
CREATE FUNCTION [dbo].[GetUserRole](@UserTUID INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    RETURN (SELECT r.NAME
            FROM roles r
            INNER JOIN users u ON r.TUID = u.ROLE_TUID
            WHERE u.TUID = @UserTUID);
END;
GO

-- Function: Get Users with Access to a Specific Store
CREATE FUNCTION [dbo].[GetUsersByStore](@StoreTUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT u.TUID, u.FIRST_NAME, u.LAST_NAME, u.EMAIL
    FROM users u
    INNER JOIN access a ON u.TUID = a.USER_TUID
    WHERE a.STORE_TUID = @StoreTUID
);
GO
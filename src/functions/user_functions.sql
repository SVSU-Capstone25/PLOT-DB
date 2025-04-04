/*
Filename: userFunctions.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions pertaining to user-related information and role assignments.

Written by: Krzysztof Hejno

Update by: Andrew Miller (4/2/2025)
Update Purpose: Had to change other function files to pluralize stores
and take care of supercategories and subcategories.

Abbreviations in some functions were counterintuitive.
Changed to just using table names across function files,
except floorset-fixtures as ff (floorset-fixtures not
in this particular file)
*/

-- Function: Get User Role by UserTUID
-- Checks out - Maybe make this take from top
-- It's not like the user can have multiple roles
CREATE FUNCTION [dbo].[GetUserRole](@UserTUID INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    RETURN (SELECT roles.NAME
            FROM roles
            INNER JOIN users ON roles.TUID = users.ROLE_TUID
            WHERE users.TUID = @UserTUID);
END;
GO

-- Function: Get Users with Access to a Specific Store
-- Checks out
-- Note: Stored procedures mean Inactive users have
-- store access deleted
CREATE FUNCTION [dbo].[GetUsersByStore](@StoreTUID INT)
RETURNS TABLE
AS
RETURN (
    SELECT users.TUID, users.FIRST_NAME, users.LAST_NAME, users.EMAIL
    FROM users
    INNER JOIN access ON users.TUID = access.USER_TUID
    WHERE access.STORE_TUID = @StoreTUID
);
GO
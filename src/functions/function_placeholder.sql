/*
Filename: getUserInfo.sql
Part of Project: PLOT/PLOT-DB/src/functions

File Purpose:
This file contains functions pertaining to getting user information

Written by: Krzysztof Hejno
*/

-- TO-DO: This is just a placeholder, may end up putting multiple functions per file, separate files for each broader functionality --

-- Create Function to Get User Role by UserTUID
CREATE FUNCTION GetUserRole(@UserTUID INT)
RETURNS NVARCHAR(50)
AS
BEGIN
    --placeholder for a function to get roles 
    RETURN (SELECT Name FROM Role WHERE TUID = @UserTUID);
END;
GO


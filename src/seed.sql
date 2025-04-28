/* Update: 4/2/2025
   Purpose: Adjusting the seed to include Supercategories table,
   replacing Category in Sales_allocation and floorsets_fixtures
   with Supercategory_tuid and Subcategory.

   Changed references to "HEIGHT" in Stores and Fixtures to
   "LENGTH"
*/

INSERT INTO Supercategories
([NAME],[COLOR])
VALUES
('None', '#FFFFFF'),
('Mens', '#AAD9FF'),
('Womens', '#FFAAD6'),
('Accessories', '#5FBD6A');

INSERT INTO Roles 
([NAME])
VALUES
('Owner'),
('Manager'),
('Employee');

-- All passwords are "password"
INSERT INTO Users ([FIRST_NAME], [LAST_NAME], [EMAIL], [PASSWORD], [ROLE_TUID], [ACTIVE]) 
VALUES 
('Nick', 'Leja', 'NickLeja@email.com', 'AQAAAAIAAYagAAAAELGtllXbuMtA/l7pTwLJYwQ58frQrX/grjhu0Ce4LyH9AdAzMbKBgxyaMiM4VMvLHA==', 1, 1);

-- ***************************************************************************************
-- Inserting Root User on restart of adding tables.
SET IDENTITY_INSERT dbo.Users ON;

INSERT INTO dbo.Users (TUID, FIRST_NAME, LAST_NAME, EMAIL, PASSWORD, ROLE_TUID, ACTIVE)
VALUES (0, 'Root', 'User', 'root@system.local', 'AQAAAAIAAYagAAAAEAnI2pNtIGxWz/JXfbD+1mOvv1RPH4cHuGmlk+oNvvm1KOiCgIc3xhmQCt7VngPMog==', 1, 1);

SET IDENTITY_INSERT dbo.Users OFF;

-- Grant root user access to all existing stores
INSERT INTO Access (USER_TUID, STORE_TUID)
SELECT 0, TUID
FROM Stores
WHERE NOT EXISTS (
    SELECT 1 FROM Access WHERE USER_TUID = 0 AND STORE_TUID = Stores.TUID
);
-- ***************************************************************************************
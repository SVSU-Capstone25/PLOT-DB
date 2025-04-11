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

INSERT INTO Stores 
([NAME], [ADDRESS], [CITY], [STATE], [ZIP], [WIDTH], [LENGTH], [BLUEPRINT_IMAGE])
VALUES
('Plato''s Closet Saginaw', '5206 Bay Rd', 'Saginaw','MI', '48604', 85, 70, 0x01020304),
('Plato''s Closet Flint', '3192 S Linden Rd', 'Flint', 'MI', '48507-3004', 75, 75, 0x01020304),
('Plato''s Closet Dallas', '8430 Abrams Rd', 'Dallas', 'TX', '75243', 70, 95, 0x01020304);

INSERT INTO Fixtures 
([NAME], [WIDTH], [LENGTH], [ICON], [STORE_TUID])
VALUES
('Long Table', 2, 5, 0x01020304, 1),
('Double Rail Rack', 5, 5, 0x01020304, 1),
('Rounder Rack', 4, 6, 0x01020304, 2),
('Wall Mount', 2, 8, 0x01020304, 2),
('Gondola', 6, 4, 0x01020304, 3),
('Single Rail Rack', 4, 5, 0x01020304, 3),
('Z-Rack', 5, 5, 0x01020304, 3);

INSERT INTO Floorsets ([NAME], [STORE_TUID], [DATE_CREATED], [CREATED_BY], [DATE_MODIFIED], [MODIFIED_BY], [FLOORSET_IMAGE])
VALUES
('Oct24 Floorset', 1, '10/7/2024', 1, '10/7/2024 10:15:30', 2, 0x01020304),
('Dec24 Floorset', 1, '11/29/2024', 2, '11/30/2024', 2, 0x01020304),
('Jan25 Floorset', 2, '1/3/2025', 3, '1/5/2025', 3, 0x01020304),
('Feb25 Floorset', 2, '1/26/2025', 3, '1/28/2025', 1, 0x01020304),
('March25 Floorset', 3, '1/26/2025', 4, '1/30/2025', 4, 0x01020304);

INSERT INTO Floorsets_Fixtures ([FLOORSET_TUID], [FIXTURE_TUID], [X_POS], [Y_POS], [HANGER_STACK], [ALLOCATED_LF], [SUBCATEGORY], [NOTE], [SUPERCATEGORY_TUID], [EDITOR_ID])
VALUES
(1,1,0,0,3,70,'Athleticwear Jackets', 'Testing Notes Column', 1, 1),
(2,2,20,20,2,30,'Bottoms Denim', 'Testing Notes Column', 1, 1),
(3,3,30,15,1,17,'Athleticwear Pants', 'Testing Notes Column', 1, 1),
(4,4,60,30,3,28,'Suits','Testing Notes Column', 1, 1),
(5,5,30,60,4,87,'Hats','Testing Notes Column', 1, 1),
(5,6,60,30,3,45,'Bottoms Khaki','Testing Notes Column', 1, 2),
(5,7,18,23,1,4,'Belts', 'Testing Notes Column', 3, 3);

-- All passwords are "password"
INSERT INTO Users ([FIRST_NAME], [LAST_NAME], [EMAIL], [PASSWORD], [ROLE_TUID], [ACTIVE]) 
VALUES 
('Nick', 'Leja', 'NickLeja@email.com', 'AQAAAAIAAYagAAAAELGtllXbuMtA/l7pTwLJYwQ58frQrX/grjhu0Ce4LyH9AdAzMbKBgxyaMiM4VMvLHA==', 1, 1), 
('Benson', 'Dunwoody', 'BensonDunwoody@email.com', 'AQAAAAIAAYagAAAAELGtllXbuMtA/l7pTwLJYwQ58frQrX/grjhu0Ce4LyH9AdAzMbKBgxyaMiM4VMvLHA==', 2, 1), 
('Jimmy', 'Pesto', 'JimmyPesto@email.com', 'AQAAAAIAAYagAAAAELGtllXbuMtA/l7pTwLJYwQ58frQrX/grjhu0Ce4LyH9AdAzMbKBgxyaMiM4VMvLHA==', 2, 1), 
('Clara', 'Schmidt', 'ClaraSchmidt@email.com', 'AQAAAAIAAYagAAAAELGtllXbuMtA/l7pTwLJYwQ58frQrX/grjhu0Ce4LyH9AdAzMbKBgxyaMiM4VMvLHA==', 2, 1), 
('Coraline', 'Jones', 'CoralineJones@email.com', 'AQAAAAIAAYagAAAAELGtllXbuMtA/l7pTwLJYwQ58frQrX/grjhu0Ce4LyH9AdAzMbKBgxyaMiM4VMvLHA==', 3, 1), 
('Eugene', 'Fitzherbert', 'EugeneFitzherbert@email.com', 'AQAAAAIAAYagAAAAELGtllXbuMtA/l7pTwLJYwQ58frQrX/grjhu0Ce4LyH9AdAzMbKBgxyaMiM4VMvLHA==', 3, 1), 
('Mike', 'Wazowski', 'MikeWazowski@email.com', 'AQAAAAIAAYagAAAAELGtllXbuMtA/l7pTwLJYwQ58frQrX/grjhu0Ce4LyH9AdAzMbKBgxyaMiM4VMvLHA==', 3, 1), 
('Edward', 'Elric', 'EdwardElric@email.com', 'AQAAAAIAAYagAAAAELGtllXbuMtA/l7pTwLJYwQ58frQrX/grjhu0Ce4LyH9AdAzMbKBgxyaMiM4VMvLHA==', 3, 1), 
('Courtney', 'LaPlante', 'CourtneyLaPlante@email.com', 'AQAAAAIAAYagAAAAELGtllXbuMtA/l7pTwLJYwQ58frQrX/grjhu0Ce4LyH9AdAzMbKBgxyaMiM4VMvLHA==', 3, 1),
('Jordan', 'Houlihan', 'jordan_houlihan@yahoo.com', 'AQAAAAIAAYagAAAAELGtllXbuMtA/l7pTwLJYwQ58frQrX/grjhu0Ce4LyH9AdAzMbKBgxyaMiM4VMvLHA==', 3, 1);

INSERT INTO Access ([USER_TUID], [STORE_TUID])
VALUES
(1,1),
(1,2),
(1,3),
(2,1),
(5,1),
(3,2),
(6,2),
(7,2),
(4,3),
(8,3),
(9,3);

INSERT INTO Sales ([FILENAME], [FILEDATA], [CAPTURE_DATE], [DATE_UPLOADED], [FLOORSET_TUID])
VALUES
('SalesOct23.xlsx', CONVERT(VARBINARY(MAX), '\Excel\SalesData\DummyFile.txt'), '10/1/2023', '10/7/2024', 1),
('SalesDec23.xlsx', CONVERT(VARBINARY(MAX), '\Excel\SalesData\DummyFile.txt'), '11/29/2023', '11/30/2024', 2),
('SalesJan24.xlsx', CONVERT(VARBINARY(MAX), '\Excel\SalesData\DummyFile.txt'), '1/1/2024', '1/5/2025', 3),
('SalesFeb24.xlxs', CONVERT(VARBINARY(MAX), '\Excel\SalesData\DummyFile.txt'), '2/1/2024', '1/26/2025', 4),
('SalesMar24.xlsx', CONVERT(VARBINARY(MAX), '\Excel\SalesData\DummyFile.txt'), '3/1/2024', '1/26/2025', 5);

INSERT INTO Sales_Allocation ([SUBCATEGORY], [SUPERCATEGORY_TUID], [TOTAL_SALES], [SALES_TUID])
VALUES
('Belts', 3, 155, 3),
('Hats', 3, 207, 3),
('Athleticwear Jackets', 1, 370, 3),
('Athleticwear Pants', 1, 819, 3),
('Bottoms Denim', 2, 3030, 3),
('Bottoms Khaki', 2, 515, 3);
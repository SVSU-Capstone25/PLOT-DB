/****** Object:  StoredProcedure [dbo].[Select_Stores_Fixtures]    Script Date: 4/4/2025 5:27:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 4/1/2025
-- Description: 
-- This select grabs all the fixture models for a store.
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[Select_Stores_Fixtures]
(
	@STORE_TUID INT = NULL
)
AS
BEGIN
	IF @STORE_TUID IS NOT NULL
	BEGIN
		SELECT *
		FROM Fixtures
		WHERE STORE_TUID = @STORE_TUID
	END
	ELSE
	BEGIN
		SELECT 'Error 500' AS Response
	END
END
GO

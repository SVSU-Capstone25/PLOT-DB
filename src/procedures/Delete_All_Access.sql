SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Zach Ventimiglia      
-- Create Date: 2/13/2025
-- Description: 
-- This procedure deletes all of the users stores access'
-- =============================================
CREATE PROCEDURE [dbo].[Delete_All_Access]
(
	@USER_TUID INT = NULL
)
AS 
BEGIN
	BEGIN TRY
		-- Delete store from access table for that user
		DELETE FROM Access
		WHERE USER_TUID = @USER_TUID
			
		SELECT 200 As Response;
	END TRY
	BEGIN CATCH
		-- Handle errors
		SELECT ERROR_MESSAGE() As Response;
	END CATCH
END
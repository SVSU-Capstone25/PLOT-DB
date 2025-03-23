/*
Filename: floorsets.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create Floorsets table for the database.

Written by: Andrew Fulton
*/

--Create Floorsets Table
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Floorsets](
	[TUID] [int] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](100) NOT NULL,
	[STORE_TUID] [int] NOT NULL,
	[DATE_CREATED] [datetime] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[DATE_MODIFIED] [datetime] NOT NULL,
	[MODIFIED_BY] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TUID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Floorsets]  WITH CHECK ADD FOREIGN KEY([STORE_TUID])
REFERENCES [dbo].[Store] ([TUID])
GO
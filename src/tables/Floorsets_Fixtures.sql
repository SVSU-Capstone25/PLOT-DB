/*
Filenname: floorsets_fixtures.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Floorsets Fixtures
table for the database.

Association table for the floorsets and fixture tables.
Provides position of a given fixture on a given floorset.

Written by: Andrew Miller
*/

-- Create floorsets_fixtures table
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Floorsets_Fixtures](
	[TUID] [int] IDENTITY(1,1) NOT NULL,
	[FLOORSET_TUID] [int] NOT NULL,
	[FIXTURE_TUID] [int] NOT NULL,
	[X_POS] [decimal](9, 6) NOT NULL,
	[Y_POS] [decimal](9, 6) NOT NULL,
	[HANGER_STACK] [int] NOT NULL,
	[TOT_LF] [decimal](10, 2) NOT NULL,
	[ALLOCATED_LF] [decimal](10, 2) NULL,
	[CATEGORY] [varchar](100) NULL,
	[NOTE] [varchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TUID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Floorsets_Fixtures] ADD  DEFAULT ('') FOR [NOTE]
GO

ALTER TABLE [dbo].[Floorsets_Fixtures]  WITH CHECK ADD FOREIGN KEY([FIXTURE_TUID])
REFERENCES [dbo].[Fixtures] ([TUID])
GO

ALTER TABLE [dbo].[Floorsets_Fixtures]  WITH CHECK ADD FOREIGN KEY([FLOORSET_TUID])
REFERENCES [dbo].[Floorsets] ([TUID])
GO
/*
Filename: Store.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Store table for the database.

Written by: Zach Ventimiglia
*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Store](
	[TUID] [int] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](100) NOT NULL,
	[ADDRESS] [varchar](100) NOT NULL,
	[CITY] [varchar](100) NOT NULL,
	[STATE] [varchar](25) NOT NULL,
	[ZIP] [varchar](10) NOT NULL,
	[WIDTH] [int] NULL,
	[HEIGHT] [int] NULL,
	[BLUEPRINT_IMAGE] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TUID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[TUID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
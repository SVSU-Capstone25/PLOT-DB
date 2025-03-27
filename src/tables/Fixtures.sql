/*
Filename: Fixtures.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Fixtures table for the database.

Written by: Zach Ventimiglia
*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Fixtures](
	[TUID] [int] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](100) NOT NULL,
	[WIDTH] [int] NOT NULL,
	[HEIGHT] [int] NOT NULL,
	[LF_CAP] [decimal](10, 2) NOT NULL,
	[ICON] [varbinary](max) NOT NULL,
	[STORE_TUID] [int] NOT NULL,
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

ALTER TABLE [dbo].[Fixtures]  WITH CHECK ADD  CONSTRAINT [FK_STORE_TUIDX] FOREIGN KEY([STORE_TUID])
REFERENCES [dbo].[Stores] ([TUID])
GO

ALTER TABLE [dbo].[Fixtures] CHECK CONSTRAINT [FK_STORE_TUIDX]
GO
/*
Filename: Sales.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Sales table for the database.

Written by: Krzysztof Hejno
*/

/****** Object:  Table [dbo].[Sales]    Script Date: 3/16/2025 5:22:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sales](
	[TUID] [int] IDENTITY(1,1) NOT NULL,
	[FILENAME] [varchar](100) NOT NULL,
	[FILEDATA] [varbinary](max) NOT NULL,
	[CAPTURE_DATE] [datetime] NOT NULL,
	[DATE_UPLOADED] [datetime] NOT NULL,
	[FLOORSET_TUID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TUID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[FILENAME] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Sales]  WITH CHECK ADD FOREIGN KEY([FLOORSET_TUID])
REFERENCES [dbo].[Floorsets] ([TUID])
GO
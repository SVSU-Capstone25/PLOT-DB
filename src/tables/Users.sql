/*
Filename: users.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Users table for the database.

Written by: Andrew Fulton

Edit:
Added the Active column to indicate if the user has an active account.
Edited by: Andrew Miller

*/

-- Create Users Table
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Users](
	[TUID] [int] IDENTITY(1,1) NOT NULL,
	[FIRST_NAME] [varchar](747) NOT NULL,
	[LAST_NAME] [varchar](747) NOT NULL,
	[EMAIL] [varchar](320) NOT NULL,
	[PASSWORD] [varchar](100) NOT NULL,
	[ROLE_TUID] [int] NULL,
	[ACTIVE] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TUID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[EMAIL] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [ACTIVE]
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD FOREIGN KEY([ROLE_TUID])
REFERENCES [dbo].[Roles] ([TUID])
GO
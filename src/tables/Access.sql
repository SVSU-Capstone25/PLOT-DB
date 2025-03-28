/*
Filename: access.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
Association table showing which stores may
be accessed by which users.
*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Access](
	[USER_TUID] [int] NOT NULL,
	[STORE_TUID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[USER_TUID] ASC,
	[STORE_TUID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Access]  WITH CHECK ADD  CONSTRAINT [FK_Access_Store] FOREIGN KEY([STORE_TUID])
REFERENCES [dbo].[Stores] ([TUID])
GO

ALTER TABLE [dbo].[Access] CHECK CONSTRAINT [FK_Access_Store]
GO

ALTER TABLE [dbo].[Access]  WITH CHECK ADD  CONSTRAINT [FK_Access_User] FOREIGN KEY([USER_TUID])
REFERENCES [dbo].[Users] ([TUID])
GO

ALTER TABLE [dbo].[Access] CHECK CONSTRAINT [FK_Access_User]
GO
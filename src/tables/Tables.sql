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

/*
Filenname: roles.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
This file contains the commands to create the Roles table for the database.

Written by: Andrew Miller
*/

--Create Roles Table--

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Roles](
	[TUID] [int] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TUID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

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
REFERENCES [dbo].[Store] ([TUID])
GO

ALTER TABLE [dbo].[Access] CHECK CONSTRAINT [FK_Access_Store]
GO

ALTER TABLE [dbo].[Access]  WITH CHECK ADD  CONSTRAINT [FK_Access_User] FOREIGN KEY([USER_TUID])
REFERENCES [dbo].[Users] ([TUID])
GO

ALTER TABLE [dbo].[Access] CHECK CONSTRAINT [FK_Access_User]
GO


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
REFERENCES [dbo].[Store] ([TUID])
GO

ALTER TABLE [dbo].[Fixtures] CHECK CONSTRAINT [FK_STORE_TUIDX]
GO

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


/*
 Filename: Sales.sql
 Part of Project: PLOT/PLOT-DB/src/tables
 
 File Purpose:
 This file contains the commands to create the Sales table for the database.
 
 Written by: Krzysztof Hejno
 */
 
 -- Create Sales Table
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




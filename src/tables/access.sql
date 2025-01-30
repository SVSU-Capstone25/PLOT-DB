/*
Filename: access.sql
Part of Project: PLOT/PLOT-DB/src/tables

File Purpose:
Association table showing which stores may
be accessed by which users.
*/

CREATE TABLE Access(
	USER_TUID INT NOT NULL,
	STORE_TUID INT NOT NULL,
	PRIMARY KEY(USER_TUID,STORE_TUID),
	FOREIGN KEY(USER_TUID) REFERENCES USERS(TUID),
	FOREIGN KEY(STORE_TUID) REFERENCES STORE(TUID)
);
GO
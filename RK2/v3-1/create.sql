DROP TABLE IF EXISTS SecVis;
DROP TABLE IF EXISTS Visitors;
DROP TABLE IF EXISTS Section;
DROP TABLE IF EXISTS Director;

CREATE TABLE Director 
(
	DirectorID INT NOT NULL PRIMARY KEY,
	FIO VARCHAR(30) NOT NULL,
	YearBirth INT,
	Experience INT,
	PhoneNumber VARCHAR(30)
);

INSERT INTO Director(DirectorID, FIO, YearBirth, Experience, PhoneNumber) VALUES
	(1, 'Platonova', 2000, 10, '89813858720'),
	(2, 'Khetagurov', 1999, 9, '89813858721'),
	(3, 'Sklifasovskiy', 1998, 8, '89813858722'),
	(4, 'Suslikov', 2001, 7, '89813858723'),
	(5, 'Rusinova', 1999, 16, '89813858724'),
	(6, 'Frolenkova', 2000, 51, '89813858725'),
	(7, 'Parinova', 1997, 4, '89813858726'),
	(8, 'Kasper', 2002, 46, '89813858727'),
	(9, 'Babenyshev', 1999, 1, '89813858728'),
	(10, 'Polyakova', 2000, 54, '89813858729');

SELECT * FROM Director;

---------------------------------------------------------------------------

CREATE TABLE Section 
(
	SectionID INT NOT NULL PRIMARY KEY,
	IDDir INT REFERENCES Director(DirectorID) NOT NULL,
	NameSec VARCHAR(30) NOT NULL,
	YearBirth INT,
	DescSec VARCHAR(30)
);

INSERT INTO Section(SectionID, IDDir, NameSec, YearBirth, DescSec) VALUES
	(1, 1, 'N1', 2000, 'DescSec1'),
	(2, 1, 'N2', 1999, 'DescSec2'),
	(3, 8, 'N3', 1998, 'DescSec3'),
	(4, 3, 'N4', 2001, 'DescSec4'),
	(5, 6, 'N5', 1999, 'DescSec5'),
	(6, 5, 'N6', 2000, 'DescSec6'),
	(7, 3, 'N7', 1997, 'DescSec7'),
	(8, 3, 'N8', 2002, 'DescSec8'),
	(9, 2, 'N9', 1999, 'DescSec9'),
	(10, 6, 'N10', 2000, 'DescSec10');

SELECT * FROM Section;

---------------------------------------------------------------------------
CREATE TABLE Visitors 
(
	VisiterID INT NOT NULL PRIMARY KEY,
	FIO VARCHAR(30) NOT NULL,
	YearBirth INT,
	Address VARCHAR(30),
	Mail VARCHAR(30)
);

INSERT INTO Visitors(VisiterID, FIO, YearBirth, Address, Mail) VALUES
	(1, 'FIO1', 2000, 'Address1', 'Mail1'),
	(2, 'FIO2', 1999, 'Address2', 'Mail2'),
	(3, 'FIO3', 1998, 'Address3', 'Mail3'),
	(4, 'FIO4', 2001, 'Address4', 'Mail4'),
	(5, 'FIO5', 1999, 'Address5', 'Mail5'),
	(6, 'FIO6', 2000, 'Address6', 'Mail6'),
	(7, 'FIO7', 1997, 'Address7', 'Mail7'),
	(8, 'FIO8', 2002, 'Address8', 'Mail8'),
	(9, 'FIO9', 1999, 'Address9', 'Mail9'),
	(10, 'FIO10', 2000, 'Address10', 'Mail10');

SELECT * FROM Visitors;

---------------------------------------------------------------------------
CREATE TABLE SecVis 
(
	IDC INT REFERENCES Section(SectionID) NOT NULL,
	IDV INT REFERENCES Visitors(VisiterID) NOT NULL,
	TimesPerWeek INT
);

INSERT INTO SecVis(IDC, IDV, TimesPerWeek) VALUES
	(1, 1, 3),
	(1, 2, 3),
	(1, 3, 2),
	(2, 2, 6),
	(3, 3, 1),
	(3, 4, 2),
	(6, 7, 2),
	(7, 3, 3),
	(8, 9, 3),
	(8, 10, 5);

SELECT * FROM SecVis;
DROP TABLE IF EXISTS Fines;
CREATE TABLE IF NOT EXISTS Fines
(
	FineID INT NOT NULL PRIMARY KEY,
	DriverID INT NOT NULL,
	FineType VARCHAR(40) NOT NULL,
	Amount INT NOT NULL,
	FineDate INT
);

DROP TABLE IF EXISTS Drivers;
CREATE TABLE IF NOT EXISTS Drivers
(
	DriverID INT NOT NULL PRIMARY KEY,
	DriverLicens INT NOT NULL,
	FIO VARCHAR(40) NOT NULL,
	Phone INT NOT NULL
);

DROP TABLE IF EXISTS Cars;
CREATE TABLE IF NOT EXISTS Cars
(
	CarID INT NOT NULL PRIMARY KEY,
	Model VARCHAR(40) NOT NULL,
	Color VARCHAR(40) NOT NULL,
	Year INT,
	RegDate INT
);

DROP TABLE IF EXISTS DC;
CREATE TABLE IF NOT EXISTS DC
(
	DriverID INT NOT NULL,
	CarID INT NOT NULL
);

INSERT INTO Cars VALUES 
	(1, 'Volvo', 'Red', 2010, 2009),
	(2, 'BMW', 'Black', 2011, 2008),
	(3, 'Suzuki', 'Blue', 2012, 2006),
	(4, 'Lada', 'Black', 2013, 2009),
	(5, 'Opel', 'Red', 2014, 2012),
	(6, 'Subaru', 'Pink', 2015, 2010),
	(7, 'Porche', 'White', 2014, 2019),
	(8, 'Ferrari', 'Green', 2013, 2009);

	
INSERT INTO Drivers VALUES 
	(1, 014, 'Ivanov', 123),
	(2, 346, 'Petrov', 4365),
	(3, 456, 'Sidorov', 2345),
	(4, 123, 'Parinov', 265),
	(5, 760, 'Smirnov', 754),
	(6, 347, 'Polyakov', 122353),
	(7, 014, 'Kasper', 578),
	(8, 345, 'Rusinov', 124563);

INSERT INTO Fines VALUES 
	(1, 3, 'Shtraf', 109242, 2019),
	(2, 2, 'Shtraf', 345, 2018),
	(3, 3, 'Shtraf', 2345, 2017),
	(4, 3, 'Shtraf', 5689, 2016),
	(5, 6, 'Shtraf', 1000, 2015),
	(6, 8, 'Shtraf', 500, 2014),
	(7, 3, 'Shtraf', 2346, 2016),
	(8, 1, 'Shtraf', 29670, 2020),
	(9, 5, 'Shtraf', 4568, 2019),
	(10, 1, 'Shtraf', 3467, 2018);

INSERT INTO DC VALUES
	(1, 1),
	(1, 2),
	(2, 3),
	(5, 4),
	(3, 2),
	(4, 6),
	(6, 5),
	(8, 7);

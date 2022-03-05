DROP TABLE IF EXISTS Sights;
CREATE TABLE IF NOT EXISTS Sights
(
	ID INT NOT NULL PRIMARY KEY,
	Name VARCHAR(40) NOT NULL,
	CityID INT NOT NULL,
	Description VARCHAR(40)
);

DROP TABLE IF EXISTS Tourists;
CREATE TABLE IF NOT EXISTS Tourists
(
	ID INT NOT NULL PRIMARY KEY,
	FirstName VARCHAR(40) NOT NULL,
	LastName VARCHAR(40) NOT NULL,
	Age INT NOT NULL,
	CityID INT NOT NULL
);

DROP TABLE IF EXISTS Cities;
CREATE TABLE IF NOT EXISTS Cities
(
	CityID INT NOT NULL PRIMARY KEY,
	Name VARCHAR(40) NOT NULL,
	Country VARCHAR(40) NOT NULL
);

DROP TABLE IF EXISTS ST;
CREATE TABLE IF NOT EXISTS ST
(
	SightID INT NOT NULL,
	TouristID INT NOT NULL,
	DATE DATE
);

INSERT INTO Cities VALUES 
	(1, 'Москва', 'Россия'),
	(2, 'Париж', 'Франция'),
	(3, 'Питер', 'Россия'),
	(4, 'Берлин', 'Германия'),
	(5, 'Будапешт', 'Венгрия'),
	(6, 'Прага', 'Чехия'),
	(7, 'Таллин', 'Эстония'),
	(8, 'Бавария', 'Германия');

	
INSERT INTO Tourists VALUES 
	(1, 'Иван', 'Платонов', 27, 3),
	(2, 'Ирина', 'Иванова', 31, 2),
	(3, 'Даня', 'Данилов', 28, 4),
	(4, 'Денис', 'Денисов', 36, 6),
	(5, 'Паша', 'Павлов', 39, 5),
	(6, 'Даша', 'Дашова', 60, 8);

INSERT INTO Sights VALUES 
	(1, 'Площадь', 1, 'Красная'),
	(2, 'Башня', 2, 'Эйфилева'),
	(3, 'Стена', 4, 'Берлинская'),
	(4, 'Мост', 6, 'Карлов'),
	(5, 'Ратуша', 7, 'Таллинская'),
	(6, 'Эрмитаж', 3, 'Музей');

INSERT INTO ST VALUES
	(1, 1, '2020-10-17'),
	(2, 1, '2019-09-16'),
	(6, 2, '2021-06-28'),
	(5, 2, '2020-12-07'),
	(1, 2, '2019-03-13'),
	(3, 3, '2018-09-11'),
	(4, 3, '2020-07-19'),
	(5, 3, '2019-01-18'),
	(6, 4, '2020-10-01'),
	(2, 5, '2021-06-29'),
	(2, 6, '2020-04-15'),
	(6, 6, '2020-04-23');
	
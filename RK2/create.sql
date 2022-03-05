--4 вариант
--РК2 Платонова ИУ7-55Б
--текстом

DROP TABLE IF EXISTS DW;
DROP TABLE IF EXISTS Guard;
DROP TABLE IF EXISTS Worker;
CREATE TABLE Worker
(
	WorkerID INT NOT NULL PRIMARY KEY,
	FIO VARCHAR(30),
	BirthYear INT,
	Exper INT,
	Phone VARCHAR(30)
);

INSERT INTO Worker(WorkerID, FIO, BirthYear, Exper, Phone) VALUES
	(1, 'FIO1', 2000, 2, 'Phone1'),
	(2, 'FIO2', 1999, 4, 'Phone2'),
	(3, 'FIO3', 1998, 7, 'Phone3'),
	(4, 'FIO4', 2001, 12, 'Phone4'),
	(5, 'FIO5', 1995, 5, 'Phone5'),
	(6, 'FIO6', 1996, 6, 'Phone6'),
	(7, 'FIO7', 1997, 6, 'Phone7'),
	(8, 'FIO8', 1994, 15, 'Phone8'),
	(9, 'FIO9', 1965, 23, 'Phone9'),
	(10, 'FIO10', 1989, 4, 'Phone10');

SELECT * FROM Worker;


DROP TABLE IF EXISTS Guard;
CREATE TABLE Guard
(
	GuardID INT PRIMARY KEY NOT NULL,
	WorkerID INT REFERENCES Worker(WorkerID) NOT NULL,
	GuardName VARCHAR(30) NOT NULL,
	Address VARCHAR(30)
);

INSERT INTO Guard(GuardID, WorkerID, GuardName, Address) VALUES
	(1, 2, 'Name1', 'Addr1'),
	(2, 4, 'Name2', 'Addr2'),
	(3, 8, 'Name3', 'Addr3'),
	(4, 2, 'Name4', 'Addr4'),
	(5, 9, 'Name5', 'Addr5'),
	(6, 10, 'Name6', 'Addr6'),
	(7, 3, 'Name7', 'Addr7'),
	(8, 7, 'Name8', 'Addr8'),
	(9, 5, 'Name9', 'Addr9'),
	(10, 6, 'Name10', 'Addr10');

SELECT * FROM Guard;


DROP TABLE IF EXISTS Duty;
CREATE TABLE Duty
(
	DutyID INT PRIMARY KEY NOT NULL,
	DutyDate DATE,
	DutyHours INT
);

INSERT INTO Duty(DutyID, DutyDate, DutyHours) VALUES
	(1, '2020-01-15', 6),
	(2, '2020-02-15', 4),
	(3, '2020-03-15', 5),
	(4, '2020-04-15', 8),
	(5, '2020-05-15', 16),
	(6, '2020-06-15', 5),
	(7, '2020-07-15', 2),
	(8, '2020-08-15', 10),
	(9, '2020-09-15', 9),
	(10, '2020-10-15', 8);

SELECT * FROM Duty;

DROP TABLE IF EXISTS DW;
CREATE TABLE DW
(
	DutyID INT REFERENCES Duty(DutyID) NOT NULL,
	WorkerID INT REFERENCES Worker(WorkerID) NOT NULL
);

INSERT INTO DW(DutyID, WorkerID) VALUES
	(1, 1), (1, 2),
	(2, 1),
	(3, 1), (3, 5), (3, 7),
	(4, 6), (4, 9),
	(5, 10),
	(6, 8), (6, 9),
	(7, 2),
	(8, 1), (8, 3),
	(9, 10),
	(10, 4);

SELECT * FROM DW;



--------------------------------------------
--1)Инструкция SELECT, использующая поисковое выражение CASE
--Вывод сотрудников и описание их опыта работы

SELECT WorkerID, FIO, 
	CASE
		WHEN Exper <= 2 THEN 'Young'
		WHEN Exper > 2 AND Exper < 7 THEN 'Miidle'
		WHEN Exper >= 7 THEN 'Old'
	END AS ExperStatus
FROM Worker;


--2) Инструкция UPDATE со скалярным подзапросом в предложении SET
--Увеличение рабочих часов на минимальное значение на 1м дежурстве

SELECT * FROM Duty;

UPDATE Duty
SET DutyHours = DutyHours + (
	SELECT MIN(DutyHours)
	FROM Duty
)
WHERE DutyID = 1;
	
SELECT * FROM Duty;


--3)Инструкцию SELECT, консолидирующую данные с помощью предложения GROUP BY и предложения HAVING
--Вывод суммарного стажа у молодых сотрудников для каждого года
SELECT BirthYear, SUM(Exper)
FROM Worker
GROUP BY BirthYear
HAVING BirthYear > 1998;

--------------------------------------------
--Создать хранимую процедуру с выходным параметром, которая уничтожает
--все SQL DDL триггеры (триггеры типа 'TR') в текущей базе данных.
--Выходной параметр возвращает количество уничтоженных триггеров.
--Созданную хранимую процедуру протестировать.

--Создание тригера
DROP TRIGGER IF EXISTS testT ON Worker;

DROP FUNCTION IF EXISTS noticeInsert;
CREATE FUNCTION noticeInsert() 
RETURNS TRIGGER
AS $$
BEGIN
	RAISE NOTICE 'Insert done';
	RETURN NEW;
END;
$$ LANGUAGE PLpgSQL;

CREATE TRIGGER insertT AFTER INSERT ON Worker
FOR EACH ROW EXECUTE PROCEDURE noticeInsert();
----------------------------------------------

--ПРОЦЕДУРА
DROP PROCEDURE IF EXISTS delTriggers;
CREATE FUNCTION delTriggers()
RETURNS INT
AS $$
DECLARE 
	n INT;
	curRow RECORD;
	tblCurs CURSOR FOR
		SELECT trigger_name, event_object_table
		FROM information_schema.triggers;
		
BEGIN
	n := 0;
	OPEN tblCurs;
	LOOP
		FETCH tblCurs INTO curRow;
		EXIT WHEN NOT FOUND;

		EXECUTE 'DROP TRIGGER ' || curRow.trigger_name || ' ON ' || curRow.event_object_table;
		n := n + 1;
		
	END LOOP;
	CLOSE tblCurs;
	RAISE NOTICE 'numOfDelete = %', n;
	RETURN N;
END;
$$ LANGUAGE PLpgSQL;

SELECT * FROM delTriggers();
DROP TABLE IF EXISTS IOWorkers;
CREATE TABLE IOWorkers
(
	WorkerID INT,
	DateIO DATE,
	DayWeek VARCHAR(30),
	TimeIO TIME,
	TypeIO INT
);

INSERT INTO IOWorkers(WorkerID,	DateIO, DayWeek, TimeIO, TypeIO) VALUES
	(1, '10-12-2018', 'Monday', '9:30', 1),
	(2, '10-12-2018', 'Monday', '8:30', 1),
	(3, '10-12-2018', 'Monday', '10:30', 1),
	(3, '10-12-2018', 'Monday', '11:30', 2),
	(3, '10-12-2018', 'Monday', '11:45', 1),
	(1, '10-12-2018', 'Monday', '20:30', 2),
	(2, '10-12-2018', 'Monday', '17:30', 2),
	(3, '10-12-2018', 'Monday', '19:30', 2),
	(3, '14-12-2018', 'Suturday', '8:50', 1),
	(1, '14-12-2018', 'Suturday', '9:00', 1),
	(1, '14-12-2018', 'Suturday', '9:20', 2),
	(1, '14-12-2018', 'Suturday', '9:25', 1),
	(2, '14-12-2018', 'Suturday', '9:05', 1);


DROP TABLE IF EXISTS Workers;
CREATE TABLE Workers
(
	WorkerID INT,
	FIO VARCHAR(30),
	Birthday DATE,
	Dept VARCHAR(30)
);

INSERT INTO Workers(WorkerID, FIO, Birthday, Dept) VALUES
	(1, 'Ivanov II', '25-09-1990', 'IT'),
	(2, 'Petrov PP', '12-11-1987', 'Counter'),
	(3, 'Sidorov SS', '10-01-1999', 'Counter');
	

SELECT * FROM Workers;


--Функция1
DROP FUNCTION IF EXISTS numLaters;
CREATE FUNCTION numLaters(dayIO DATE)
RETURNS bigINT
AS $$
	SELECT COUNT(*)
	FROM (
		SELECT WorkerID, MIN(TimeIO) AS TI
		FROM IOWorkers
		WHERE TypeIO = 1 AND DateIO = dayIO
		GROUP BY WorkerID
		HAVING MIN(TimeIO) >= '9:00'
	) AS late;
	
$$ LANGUAGE SQL;

SELECT * FROM numLaters('14-12-2018');
SELECT * FROM numLaters('10-12-2018');




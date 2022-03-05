--Функция3
SELECT Dept, COUNT(WorkerID)
FROM (
	SELECT Workers.WorkerID, Dept, DateIO, MIN(TimeIO) AS TI
	FROM IOWorkers JOIN Workers ON IOWorkers.WorkerID = Workers.WorkerID
	WHERE TypeIO = 1
	GROUP BY Workers.WorkerID, Dept, DateIO
	HAVING MIN(TimeIO) >= '9:00'
) AS tmp
GROUP BY Dept;


--функция1
SELECT DISTINCT Dept
FROM Workers
WHERE WorkerID IN (
	SELECT WorkerID
	FROM (
		SELECT WorkerID, EXTRACT (Week FROM DateIO), EXTRACT (Year FROM DateIO)
		FROM (
			SELECT WorkerID, DateIO, MIN(TimeIO) AS mtime
			FROM IOWorkers
			WHERE TypeIO = 1
			GROUP BY WorkerID, DateIO
		) AS tmp1
		WHERE mtime > '8:00'
	) AS tmp2
	GROUP BY WorkerID
	HAVING COUNT(WorkerID) > 1
);


--функция2
DROP TABLE IF EXISTS WI;
CREATE TEMP TABLE WI
(
	WorkerID INT,
	DateI DATE,
	TimeI TIME
);

INSERT INTO WI
SELECT WorkerID, DateIO, MIN(TimeIO)
FROM IOWorkers
WHERE TypeIO = 1
GROUP BY WorkerID, DateIO;

SELECT * FROM WI;

DROP TABLE IF EXISTS WO;
CREATE TEMP TABLE WO
(
	WorkerID INT,
	DateO DATE,
	TimeO TIME
);

INSERT INTO WO
SELECT WorkerID, DateIO, MIN(TimeIO)
FROM IOWorkers
WHERE TypeIO = 2
GROUP BY WorkerID, DateIO;

SELECT * FROM WO;

SELECT AVG(ageW)
FROM (
	SELECT EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM Birthday) AS ageW
	FROM Workers
	WHERE WorkerID IN (
		SELECT ID
		FROM (
			SELECT WI.WorkerID AS ID, DateI, TimeO - TimeI AS wt
			FROM WI JOIN WO ON WI.WorkerID = WO.WorkerID AND WI.DateI = WO.DateO
		) AS tmp1
		WHERE wt < '8:00'
	)
) AS tmp2;














--Ф1
SELECT *
FROM Workers
WHERE CURRENT_DATE - Birthday = (
	SELECT MAX(ageW)
	FROM (
		SELECT WorkerID, CURRENT_DATE - Birthday AS ageW
		FROM Workers
		WHERE Dept = 'Counter'
	) AS res
) AND Dept = 'Counter';


--Ф2
SELECT *
FROM Workers
WHERE WorkerID IN (
	SELECT WorkerID
	FROM (
		SELECT WorkerID, DateIO, COUNT(DateIO)
		FROM IOWorkers
		WHERE TypeIO = 2
		GROUP BY WorkerID, DateIO
		HAVING COUNT(DateIO) > 1
	) AS tmp1
);


--Ф3
SELECT *
FROM Workers
WHERE WorkerID = (
	SELECT WorkerID
	FROM IOWorkers
	WHERE TimeIO = (
		SELECT MAX(ti)
		FROM (
			SELECT WorkerID, MIN(TimeIO) AS ti
			FROM IOWorkers
			WHERE DateIO = CURRENT_DATE AND TypeIO = 1
			GROUP BY WorkerID
		) AS tmp
	) AND TypeIO = 1 AND DateIO = CURRENT_DATE
);

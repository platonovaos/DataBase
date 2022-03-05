--функция 1
SELECT Dept
FROM Workers
GROUP BY Dept
HAVING COUNT(WorkerID) > 10;


--Вар 2
--task 1
/*DROP FUNCTION IF EXISTS statWorkers;

CREATE FUNCTION statWorkers(dateW DATE)
RETURNS TABLE(minLate TIME, numLate INT)
AS $$
BEGIN
	RETURN QUERY (
		SELECT tl, COUNT(WorkerID)
		FROM (
			SELECT WorkerID, EXTRACT (MINUTE FROM (MIN(TimeIO) - '8:00')) AS tl
			FROM IOWorkers
			WHERE TypeIO = 1 AND DateIO = dateW
			GROUP BY WorkerID
			HAVING MIN(TimeIO) > '8:00'
		) AS tmp
		GROUP BY tl, WorkerID
	);
END;
$$ LANGUAGE PLpgSQL;

SELECT * FROM statWorkers('14-12-2018');
*/



--Вар 3
--TASK1
SELECT MIN(AGE)
FROM (
	SELECT EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM Birthday) AS age
	FROM Workers
	WHERE WorkerID IN (
		SELECT WorkerID
		FROM IOWorkers
		WHERE TypeIO = 1
		GROUP BY WorkerID
		HAVING MIN(TimeIO) > '08:10'
	)
) AS tmp;




--ВАР 4
--TASK 1
SELECT * 
FROM Workers
WHERE WorkerID NOT IN (
	SELECT DISTINCT WorkerID
	FROM IOWorkers
	WHERE DateIO = '10-12-2018' AND TypeIO = 1
);


DROP FUNCTION IF EXISTS workT;
CREATE FUNCTION workT(dateT DATE)
RETURNS SETOF Workers
AS $$
BEGIN
	RETURN QUERY (
		SELECT * 
		FROM Workers
		WHERE WorkerID NOT IN (
			SELECT DISTINCT WorkerID
			FROM IOWorkers
			WHERE DateIO = '10-12-2018' AND TypeIO = 1
		)
	);
END;
$$ LANGUAGE PLpgSQL;

SELECT * FROM workT('10-12-2018');








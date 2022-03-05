--Статус кружка по возрасту
SELECT SectionID, NameSec, DescSec,
	CASE YearBirth
		WHEN 1998 THEN 'Old'
		WHEN 1999 THEN 'Middle'
		WHEN 2000 THEN 'Young'
		ELSE 'Ver'
	END AS AgeSec
FROM Section;


--Оконная функция
SELECT SectionID, nameSec, IDDir, YearBirth, 
	MIN(YearBirth) OVER (PARTITION BY IDDir)
FROM Section
ORDER BY SectionID;


--GROUP BY/HAVING
SELECT DirectorID, COUNT(*) 
FROM Director JOIN Section ON Section.IDDir = Director.DirectorID
GROUP BY DirectorID
HAVING COUNT(*) > 1
ORDER BY DirectorID;





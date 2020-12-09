--Из таблиц базы данных, созданной в первой лабораторной работе, 
--извлечь данные в JSON
SELECT to_jsonb(Tour) FROM Tour;
SELECT to_jsonb(Food) FROM Food;
SELECT to_jsonb(Hotel) FROM Hotel;
SELECT to_jsonb(City) FROM City;


--Выполнить загрузку и сохранение JSON файла в таблицу.
--Создание
COPY (SELECT to_jsonb(Tour) FROM Tour) 
TO '/home/main/Desktop/BMSTU/5sem/DataBase/lab5/tour.json';

--Загрузка
CREATE TEMP TABLE IF NOT EXISTS tourJSONB(Tour jsonb);
COPY tourJSONB 
FROM '/home/main/Desktop/BMSTU/5sem/DataBase/lab5/tour.json';

CREATE TEMP TABLE IF NOT EXISTS tourTEMP
(
	TourID INT,
	Food INT,
	Hotel INT,
	Cost INT,
	DateBegin DATE,
	DateEnd DATE
);

INSERT INTO tourTEMP (TourID, Food, Hotel, Cost, DateBegin, DateEnd)
SELECT T.* 
FROM tourJSONB CROSS JOIN jsonb_populate_record(null::tour, tour) AS T;

SELECT * FROM tourTEMP;

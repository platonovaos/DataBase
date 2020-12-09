--Из таблиц базы данных, созданной в первой лабораторной работе, 
--извлечь данные в JSON
SELECT to_jsonb(Tour) FROM Tour;
SELECT to_jsonb(Food) FROM Food;
SELECT to_jsonb(Hotel) FROM Hotel;
SELECT to_jsonb(City) FROM City;


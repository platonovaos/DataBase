/*
CREATE TEMP TABLE IF NOT EXISTS hotelJSONB(Hotel jsonb);
COPY hotelJSONB 
FROM '/home/main/Desktop/BMSTU/5sem/DataBase/lab5/hotel.json';
*/

--Извлечь XML/JSON фрагмент из XML/JSON документа
SELECT *
FROM hotelJSONB
WHERE Hotel @> '{"hotelid": 1}';

SELECT *
FROM hotelJSONB
WHERE hotel->>'hotelid' = '1';


--Извлечь значения конкретных узлов или атрибутов XML/JSON
--документа
SELECT hotel->>'name' as name
FROM hotelJSONB
WHERE hotel @> '{"class": 5, "type": "Spa"}';

/*SELECT *
FROM hotelJSONB
WHERE hotel @> '{"class": 5}';
*/
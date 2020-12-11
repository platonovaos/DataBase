CREATE TEMP TABLE IF NOT EXISTS hotelJSONB(Hotel jsonb);
COPY hotelJSONB 
FROM '/home/main/Desktop/BMSTU/5sem/DataBase/lab5/hotel.json';

--Извлечь XML/JSON фрагмент из XML/JSON документа
SELECT *
FROM hotelJSONB
WHERE (hotel->>'hotelid')::int < 10;

SELECT *
FROM hotelJSONB
WHERE (hotel->>'class')::int >= 4;


--Извлечь значения конкретных узлов или атрибутов XML/JSON
--документа
SELECT hotel->>'hotelid' as id, hotel->>'name' as name
FROM hotelJSONB
WHERE hotel @> '{"class": 5, "type": "Spa"}';

SELECT hotel->>'name' as name, hotel->>'class' as class, hotel->>'cost' as cost
FROM hotelJSONB
WHERE (hotel->>'hotelid')::int = 1;


--Выполнить проверку существования узла или атрибута
SELECT (hotel->>'food') IS NOT NULL as Existence
FROM hotelJSONB;

SELECT hotel ? 'cost' as Existence
FROM hotelJSONB;

SELECT hotel ?& array['type', 'country', 'hotelid'] as Existence
FROM hotelJSONB
WHERE (hotel->>'hotelid')::int = 2;

SELECT hotel
FROM hotelJSONB
GROUP BY hotel
HAVING (
	CASE WHEN (hotel->>'hotelid')::int = 1
		THEN TRUE
		ELSE FALSE
	END
) = TRUE;


--Изменить XML/JSON документ
UPDATE hotelJSONB
SET hotel = replace(hotel::TEXT, ': "Mini"', ': "Apart"')::jsonb
WHERE (hotel->>'hotelid')::int = 1;

UPDATE hotelJSONB
SET hotel = jsonb_set(hotel, '{type}', '"Mini"')
WHERE (hotel->>'hotelid')::int = 1;

--добавление ключа
UPDATE hotelJSONB
SET hotel = jsonb_set(hotel, '{food}', '1')
WHERE (hotel->>'hotelid')::int = 1;

--удаление ключа
UPDATE hotelJSONB
SET hotel = hotel - 'food'
WHERE (hotel->>'hotelid')::int = 1;


--Разделить XML/JSON документ на несколько строк по узлам
DROP TABLE IF EXISTS hotelINC;
CREATE TEMP TABLE IF NOT EXISTS hotelINC(hotel jsonb);

INSERT INTO hotelINC(hotel)
SELECT jsonb_build_object('hotelid', hotel->'hotelid',
			'name', hotel->'name',
			'cost', hotel->'cost')
FROM hotelJSONB;


DROP TABLE IF EXISTS hotelCTCS;
CREATE TEMP TABLE IF NOT EXISTS hotelCTCS(hotel jsonb);

INSERT INTO hotelCTCS(hotel)
SELECT hotel - 'name' - 'cost'
FROM hotelJSONB;



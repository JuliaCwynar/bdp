--A
SELECT SUM(ST_LENGTH(geometry)) AS total_road_length
FROM roads;

--B
SELECT ST_AsText(geometry) AS geometry_wkt,
    ST_Area(geometry) AS area,
    ST_Perimeter(geometry) AS perimeter 
FROM buildings 
WHERE name = 'BuildingA';

--C
SELECT 	name,
		ST_AREA(geometry) AS area
FROM buildings
ORDER BY area DESC;

--D
SELECT 	name,
		ST_Perimeter(geometry) AS perimeter
FROM buildings
ORDER BY ST_Area(geometry) DESC
LIMIT 2;

--E
SELECT 
    ST_Distance(
        (SELECT geometry FROM buildings WHERE name = 'BuildingA'),
        (SELECT geometry FROM poi WHERE name = 'K')
    ) AS distance;

--F
SELECT ST_Area(
	ST_Difference(
		(SELECT geometry FROM buildings WHERE name = 'BuildingC'),
		ST_Buffer((SELECT geometry FROM buildings WHERE name = 'BuildingB'), 0.5)
		)
	) AS area
WHERE 
	ST_Distance(
        (SELECT geometry FROM buildings WHERE name = 'BuildingC'),
		(SELECT geometry FROM buildings WHERE name = 'BuildingB')
    ) < 0.5

--G
SELECT 
    *,
    ST_Centroid(geometry)
FROM buildings
WHERE ST_Y(ST_Centroid(geometry)) > 
    ST_Y(ST_Centroid((SELECT geometry FROM roads WHERE name = 'RoadX')));

--H
SELECT
	ST_Area(ST_Difference(
		(SELECT geometry FROM buildings WHERE name = 'BuildingC'),
		ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))', 4326)
	));

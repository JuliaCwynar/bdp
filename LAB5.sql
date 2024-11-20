-- EX 1

CREATE TABLE obiekty (
    id SERIAL PRIMARY KEY,
    nazwa TEXT NOT NULL,
    geometria GEOMETRY
);

INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt1',
    'COMPOUNDCURVE(
        (0 1, 1 1), 
        CIRCULARSTRING(1 1, 2 0, 3 1),
        CIRCULARSTRING(3 1, 4 2, 5 1),
        (5 1, 6 1)
    )'::GEOMETRY
);

INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt2',
    'GEOMETRYCOLLECTION(
        COMPOUNDCURVE(
            (10 6, 14 6), 
            CIRCULARSTRING(14 6, 16 4, 14 2),
            CIRCULARSTRING(14 2, 12 0, 10 2),
            (10 2, 10 6)
        ),
        CIRCULARSTRING(
            11 2, 12 3, 13 2, 12 1, 11 2
        )
    )'::GEOMETRY
);

INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt3',
    'POLYGON((10 17, 7 15, 12 13, 10 17))'::GEOMETRY
);

INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt4',
    'LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)'::GEOMETRY
);

INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt5',
    'LINESTRING Z(30 30 59, 38 32 234)'::GEOMETRY
);

INSERT INTO obiekty (nazwa, geometria) 
VALUES (
    'obiekt6',
    'GEOMETRYCOLLECTION(
        LINESTRING(1 1, 3 2),
        POINT(4 2)
    )'::GEOMETRY
);


SELECT * FROM obiekty;

-- EX 2

WITH shortest_line AS (
    SELECT ST_ShortestLine(ob1.geometria, ob2.geometria) AS line
    FROM obiekty ob1, obiekty ob2
    WHERE ob1.nazwa = 'obiekt3' AND ob2.nazwa = 'obiekt4'
)
SELECT ST_Area(ST_Buffer(line, 5)) AS area
FROM shortest_line;

-- EX 3
-- Warunki: obiekt musi być zamknięty
UPDATE obiekty
SET geometria = ST_MakePolygon(geometria)
WHERE nazwa = 'obiekt4' AND ST_GeometryType(geometria) = 'ST_LineString';


-- EX 4
INSERT INTO obiekty (nazwa, geometria)
SELECT 'obiekt7', ST_Union(ob1.geometria, ob2.geometria)
FROM obiekty ob1, obiekty ob2
WHERE ob1.nazwa = 'obiekt3' AND ob2.nazwa = 'obiekt4';

SELECT * FROM obiekty;


-- EX 5
WITH no_arcs AS (
    SELECT nazwa, geometria
    FROM obiekty
    WHERE ST_GeometryType(geometria) NOT IN ('ST_CircularString', 'ST_CompoundCurve')
)
SELECT SUM(ST_Area(ST_Buffer(geometria, 5))) AS total_area
FROM no_arcs;
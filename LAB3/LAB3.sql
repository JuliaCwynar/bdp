-- HAD TO RENAME ALL TABLES AND SOME PROPERTIES TO LOWERCASE THUS THEY WERE NOT DETECTED IN MY QUERIES

-- EX 1

CREATE TABLE new_or_renovated_buildings AS
SELECT t2019.polygon_id, t2019.geom
FROM buildings_2019 AS t2019
LEFT JOIN buildings_2018 AS t2018 ON t2019.polygon_id = t2018.polygon_id
WHERE ST_Equals(t2019.geom, t2018.geom) IS FALSE OR t2018.polygon_id IS NULL;

SELECT * FROM new_or_renovated_buildings

-- EX 2
SELECT t2019.type, COUNT(*) AS count_near_buildings
FROM poi_2019 AS t2019
JOIN new_or_renovated_buildings AS new_buildings 
    ON ST_DWithin(t2019.geom, new_buildings.geom, 500)
GROUP BY t2019.type;

-- EX 3
CREATE TABLE streets_reprojected AS
SELECT 
    link_id, 
    ST_Transform(geom, 31467) AS geom
FROM streets_2019;

SELECT * FROM streets_reprojected

-- EX 4
CREATE TABLE input_points (
    id SERIAL PRIMARY KEY,
    geom GEOMETRY(Point, 4326)
);

INSERT INTO input_points (geom)
VALUES 
    (ST_SetSRID(ST_MakePoint(8.36093, 49.03174), 4326)),
    (ST_SetSRID(ST_MakePoint(8.39876, 49.00644), 4326));

SELECT * FROM input_points

-- EX 5
ALTER TABLE input_points
    ALTER COLUMN geom TYPE GEOMETRY(Point, 31467)
    USING ST_Transform(geom, 31467);

SELECT * FROM input_points

-- EX 6
WITH line_from_points AS (
    SELECT ST_MakeLine(geom ORDER BY id) AS geom
    FROM input_points
),
reprojected_nodes AS (
    SELECT node_id, ST_Transform(geom, 31467) AS geom
    FROM street_node_2019
)
SELECT reprojected_nodes.node_id
FROM reprojected_nodes, line_from_points
WHERE ST_DWithin(reprojected_nodes.geom, line_from_points.geom, 200);

-- EX 7
SELECT COUNT(*) AS sporting_goods_near_parks
FROM poi_2019 AS poi
JOIN land_use_a_2019 AS parks ON ST_DWithin(poi.geom, parks.geom, 300)
WHERE poi.type = 'Sporting Goods Store';

-- EX 8 
CREATE TABLE T2019_KAR_BRIDGES AS
SELECT 
    ST_Intersection(rail.geom, water.geom) AS geom
FROM railways_2019 AS rail
JOIN water_lines_2019 AS water ON ST_Intersects(rail.geom, water.geom)
WHERE ST_Intersects(rail.geom, water.geom);

SELECT * FROM T2019_KAR_BRIDGES
CREATE TABLE
roads (point1 VARCHAR,
       point2 VARCHAR,
       cost INT);

INSERT INTO roads (point1, point2, cost)
VALUES ('a', 'b', 10), ('b', 'a', 10),
       ('b', 'c', 35), ('c', 'b', 35),
       ('a', 'c', 15), ('c', 'a', 15),
       ('a', 'd', 20), ('d', 'a', 20),
       ('b', 'd', 25), ('d', 'b', 25),
       ('c', 'd', 30), ('d', 'c', 30);

WITH RECURSIVE
paths AS (
    SELECT ARRAY[roads.point1, roads.point2] AS tour,
           roads.point1,
           roads.point2,
           roads.cost,
           roads.cost AS total_cost
    FROM roads
    WHERE roads.point1 = 'a'

    UNION ALL

    SELECT ARRAY_APPEND(paths.tour, roads.point2) AS tour,
           roads.point1,
           roads.point2,
           roads.cost,
           paths.total_cost + roads.cost AS total_cost
    FROM paths JOIN roads ON paths.point2 = roads.point1
    WHERE ARRAY_POSITION(paths.tour, roads.point2) IS NULL),

valid_tours AS (
    SELECT paths.total_cost + roads.cost AS total_cost,
           ARRAY_APPEND(paths.tour, 'a') AS tour
    FROM paths
    JOIN roads ON paths.point2 = roads.point1 AND roads.point2 = 'a'
    WHERE cardinality(paths.tour) = 4)

SELECT *
FROM valid_tours
WHERE total_cost = (SELECT MIN(total_cost) FROM valid_tours)
ORDER BY total_cost, tour;

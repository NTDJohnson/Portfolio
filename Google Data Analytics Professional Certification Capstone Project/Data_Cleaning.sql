--CREATE VARCHAR TABLE TO CLEAN AND CAST INTO RELEVANT DATA TYPES

CREATE TABLE tripdata (
	ride_id VARCHAR(50),
	rideable_type VARCHAR(50),
	started_at VARCHAR(50),
	ended_at VARCHAR(50),
	start_station_name VARCHAR(150),
	start_station_id VARCHAR(50),
	end_station_name VARCHAR(150),
	end_station_id VARCHAR(50),
	start_lat VARCHAR(50),
	start_lng VARCHAR(50),
	end_lat VARCHAR(50),
	end_lng VARCHAR(50),
	member_casual VARCHAR(50) ) ; 

INSERT INTO tripdata SELECT * FROM [dbo].[202204-tripdata] ;
INSERT INTO tripdata SELECT * FROM [dbo].[202205-tripdata] ;
INSERT INTO tripdata SELECT * FROM [dbo].[202206-tripdata] ;
INSERT INTO tripdata SELECT * FROM [dbo].[202207-tripdata] ;
INSERT INTO tripdata SELECT * FROM [dbo].[202208-tripdata] ;
INSERT INTO tripdata SELECT * FROM [dbo].[202209-publictripdata] ;
INSERT INTO tripdata SELECT * FROM [dbo].[202210-tripdata] ;
INSERT INTO tripdata SELECT * FROM [dbo].[202211-tripdata] ;
INSERT INTO tripdata SELECT * FROM [dbo].[202212-tripdata] ;
INSERT INTO tripdata SELECT * FROM [dbo].[202301-tripdata] ;
INSERT INTO tripdata SELECT * FROM [dbo].[202302-tripdata] ;
INSERT INTO tripdata SELECT * FROM [dbo].[202303-tripdata] ;


--REMOVING " FROM DATA AND VERIFYING FORMAT

SELECT COUNT(*) FROM tripdata WHERE ride_id NOT LIKE 
'[0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]'
AND ride_id NOT IN (
SELECT ride_id FROM tripdata WHERE ride_id LIKE 
'"[0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]"'
) -- 0 'not-like' ride_ids that are different from 'like' ride_ids

SELECT COUNT(*) FROM tripdata WHERE ride_id LIKE 
'"[0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]"'
AND ride_id NOT IN (
SELECT ride_id FROM tripdata WHERE ride_id NOT LIKE 
'[0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]'
) -- 0 'like' ride_ids that are different from 'not-like' ride_ids 
-- therefore 'like' ride_ids and 'not-like' ride_ids are the same - remove leading and trailing " from 'not-like' ride_ids to remove all " from ride_ids and make all ride_ids in 'like' format 

UPDATE tripdata SET ride_id=RIGHT(LEFT(ride_id, 17), 16) WHERE 
ride_id NOT LIKE '[0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z][0-9A-Z]'


SELECT rideable_type, COUNT(*) AS frequency FROM tripdata GROUP BY rideable_type
-- rideable_type is either traditional bike, docked bike, or electric bike or one of these types with leading and trailing " 
-- remove " where present

UPDATE tripdata SET rideable_type = REPLACE(rideable_type, '"', '') ; 

SELECT COUNT(*) FROM tripdata WHERE started_at NOT LIKE 
'[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'
AND started_at NOT IN (
SELECT started_at FROM tripdata WHERE started_at LIKE 
'"[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]"'
) -- 0 'not-like' started_at that are different from 'like' started_at


SELECT COUNT(*) FROM tripdata WHERE started_at LIKE 
'"[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]"' 
AND started_at NOT IN (
SELECT started_at FROM tripdata WHERE started_at NOT LIKE 
'[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'
) -- 0 'like' started_at that are different from 'not-like' started_at
-- therefore 'like' started_at and 'not-like' started_at are the same - remove leading and trailing " from 'not-like' started_at to remove all " and make all in 'like' format

UPDATE tripdata SET started_at=RIGHT(LEFT(started_at, 20), 19) WHERE 
started_at NOT LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'

SELECT COUNT(*) FROM tripdata WHERE ended_at NOT LIKE 
'[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'
AND ended_at NOT IN (
SELECT ended_at FROM tripdata WHERE ended_at LIKE 
'"[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]"'
) -- 0 'not-like' ended_at that are different from 'like' ended_at

SELECT COUNT(*) FROM tripdata WHERE ended_at LIKE 
'"[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]"'
AND ended_at NOT IN (
SELECT ended_at FROM tripdata WHERE ended_at NOT LIKE 
'[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'
) -- 0 'like' ended_at that are different from 'not-like' ended_at
-- therefore 'like' ended_at and 'not-like' ended_at are the same - remove leading and trailing " from 'not-like' ended_at to remove all " and make all in 'like' format

UPDATE tripdata SET ended_at=RIGHT(LEFT(ended_at, 20), 19) WHERE 
ended_at NOT LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'
	

SELECT start_station_name FROM tripdata WHERE start_station_name NOT LIKE '%[^a-zA-Z0-9&."()/*;\- ]%' ESCAPE '\'
AND start_station_name LIKE '%[a-zA-Z0-9&."()/*;\- ]%' ESCAPE '\' GROUP BY start_station_name
--all 2808 non-blank start_station_name accounted for by adding characters in turn. Therefore non-blank start_station_name contain only alphanumeric characters,spaces, &,.,",(,),/,*,;, and -

UPDATE tripdata SET start_station_name = REPLACE(start_station_name, '"', '') WHERE 
start_station_name LIKE '"%"'

SELECT start_station_name FROM tripdata WHERE start_station_name LIKE '%"%' 
OR start_station_name LIKE '"%' 
OR start_station_name LIKE '%"'
--0 rows returned. Therefore all start_station_name that had " began and ended with "

UPDATE tripdata SET start_station_name = REPLACE(start_station_name, '*', '') WHERE 
start_station_name LIKE '%*'

SELECT start_station_name FROM tripdata WHERE start_station_name LIKE '%*%' 
OR start_station_name LIKE '*%' 
OR start_station_name LIKE '%*'
--0 rows returned. Therefore all start_station_name that had * ended with * 

SELECT start_station_name FROM tripdata WHERE start_station_name LIKE '%;%' 
OR start_station_name LIKE ';%' 
OR start_station_name LIKE '%;'
-- 3 rows returned. ; is removable without affecting meaning - remove it 

UPDATE tripdata SET start_station_name = REPLACE(start_station_name, ';', '') 

SELECT start_station_id FROM tripdata WHERE start_station_id NOT LIKE '%[^a-zA-Z0-9".()\- ]%' ESCAPE '\' 
AND start_station_id LIKE '%[a-zA-Z0-9".()\- ]%' ESCAPE '\' GROUP BY start_station_id
--all 2487 non-blank start_station_id accounted for by adding characters in turn. Therefore non-blank start_station_id contain only alphanumeric characters, spaces, ., (,), and -

UPDATE tripdata SET start_station_id = REPLACE(start_station_id, '"', '') WHERE 
start_station_id LIKE '"%"'

SELECT start_station_id FROM tripdata WHERE start_station_id LIKE '%"%' 
OR start_station_id LIKE '"%' 
OR start_station_id LIKE '%"'
--0 rows returned. Therefore all start_station_id that had " began and ended with "

SELECT end_station_name FROM tripdata WHERE end_station_name NOT LIKE '%[^a-zA-Z0-9"&./()*\- ]%' ESCAPE '\'
AND end_station_name LIKE '%[a-zA-Z0-9"&./()*\- ]%' ESCAPE '\' GROUP BY end_station_name
--all 2832 non-blank end_station_name accounted for by adding characters in turn. Therefore end_station_name only contain alphanumeric characters, space, ", &,.,/,(,),*, and -

UPDATE tripdata SET end_station_name = REPLACE(end_station_name, '"', '') WHERE 
end_station_name LIKE '"%"'

SELECT end_station_name FROM tripdata WHERE end_station_name LIKE '%"%' 
OR end_station_name LIKE '"%' 
OR end_station_name LIKE '%"'
--0 rows returned. Therefore all end_station_name that had " began and ended with "

UPDATE tripdata SET end_station_name = REPLACE(end_station_name, '*', '') WHERE 
end_station_name LIKE '%*'

SELECT end_station_name FROM tripdata WHERE end_station_name LIKE '%*%' 
OR end_station_name LIKE '*%' 
OR end_station_name LIKE '%*'
--0 rows returned. Therefore all end_station_name that had * ended with * 

SELECT end_station_id FROM tripdata WHERE end_station_id NOT LIKE '%[^a-zA-Z0-9".()\- ]%' ESCAPE '\' 
AND end_station_id LIKE '%[a-zA-Z0-9".()\- ]%' ESCAPE '\' GROUP BY end_station_id
--all 2508 non-blank start_station_id accounted for by adding characters in turn. Therefore non-blank start_station_id contain only alphanumeric characters, spaces, ., (,), and -

UPDATE tripdata SET end_station_id = REPLACE(end_station_id, '"', '') WHERE 
end_station_id LIKE '"%"'

SELECT end_station_id FROM tripdata WHERE end_station_id LIKE '%"%' 
OR end_station_id LIKE '"%' 
OR end_station_id LIKE '%"'
--0 rows returned. Therefore all end_station_id that had " began and ended with "

SELECT COUNT(*) FROM tripdata WHERE start_lat LIKE '%"' OR start_lat LIKE '"%' OR start_lat LIKE '%"%'
--0 rows
SELECT COUNT(*) FROM tripdata WHERE start_lng LIKE '%"' OR start_lng LIKE '"%' OR start_lng LIKE '%"%'
--0 rows
SELECT COUNT(*) FROM tripdata WHERE end_lat LIKE '%"' OR end_lat LIKE '"%' OR end_lat LIKE '%"%'
--0 rows
SELECT COUNT(*) FROM tripdata WHERE end_lng LIKE '%"' OR end_lng LIKE '"%' OR end_lng LIKE '%"%'
--0 rows
-- No " in start_lat, start_lng, end_lat, or end_lng

--check if coordinates are in correct ranges 

SELECT COUNT(*) FROM tripdata WHERE start_lat NOT LIKE '41.%' AND start_lat NOT LIKE '42.%' 
-- 0 rows. Therefore all start_lat are like '41.%' or '42.%' with none being blank 

SELECT COUNT(*) FROM tripdata WHERE start_lng NOT LIKE '-87.%' AND start_lng NOT LIKE '-88.'
-- 0 rows. Therefore all start_lng are like '-87.%' with none being blank

SELECT COUNT(*) FROM tripdata WHERE end_lat NOT LIKE '41.%' AND end_lat NOT LIKE '42.%' 
-- 5863 rows
SELECT * FROM tripdata WHERE end_lat NOT LIKE '41.%' AND end_lat NOT LIKE '42.%' AND LEN(end_lat) != 0 
-- all non-blank end_lat outside range are 0.0


SELECT COUNT(*) FROM tripdata WHERE end_lng NOT LIKE '-87.%' AND end_lng NOT LIKE '-88.%'  --5863
SELECT * FROM tripdata WHERE end_lng NOT LIKE '-87.%' AND end_lng NOT LIKE '-88.%' AND LEN(end_lng) != 0
-- all non-blank end_lng outside range are 0.0 and have end_lat equal to 0.0
-- therefore all non-blank end_lng and end_lat outside range occur together and are zeroes. All rows with zero end_lat and end_lng have end_station_id 'chargingstx07' and there are rows with this end_station_id that have non-zero, non-blank coordinates that can be used to obtain an average position for this station

SELECT COUNT(*) FROM tripdata WHERE LEN(end_lat) = 0 --5855
SELECT COUNT(*) FROM tripdata WHERE LEN(end_lat) = 0 AND LEN(end_station_name) = 0 AND LEN(end_station_id) = 0 --5855
--therefora all blank end_lat end_lng rows have blank end_station_name and end_station_id

--remove these rows 
DELETE FROM tripdata WHERE LEN(end_lat) = 0


--deltete rows with zeroes for end_lat, end_lng (some of 'chargingstx07' entries) 
DELETE FROM tripdata WHERE end_lat = '0.0'

SELECT member_casual FROM tripdata GROUP BY member_casual
--member_casusal is either member or casual or one of these types with leading and trailing "

UPDATE tripdata SET member_casual = REPLACE(member_casual, '"', '') ; 
--remove " where present

--CASTING DATA TYPES 

ALTER TABLE tripdata ALTER COLUMN started_at DATETIME;
ALTER TABLE tripdata ALTER COLUMN ended_at DATETIME;
ALTER TABLE tripdata ALTER COLUMN start_lat REAL;
ALTER TABLE tripdata ALTER COLUMN start_lng REAL;
ALTER TABLE tripdata ALTER COLUMN end_lat REAL;
ALTER TABLE tripdata ALTER COLUMN end_lng REAL;



--MAKING COORDINATES CONSISTENT AND IMPUTING VALUES FOR BLANK STATION NAME OR ID 
--without intermediatry tables

UPDATE a
SET start_lat = (
SELECT AVG(b.start_lat) FROM tripdata b
	WHERE b.start_station_id = a.start_station_id
) FROM tripdata a WHERE LEN(a.start_station_id) > 0

UPDATE a
SET start_lng = (
SELECT AVG(b.start_lng) FROM tripdata b
	WHERE b.start_station_id = a.start_station_id
) FROM tripdata a WHERE LEN(a.start_station_id) > 0

UPDATE a
SET end_lat = (
SELECT AVG(b.end_lat) FROM tripdata b
	WHERE b.end_station_id = a.end_station_id
) FROM tripdata a WHERE LEN(a.end_station_id) > 0

UPDATE a
SET end_lng = (
SELECT AVG(b.end_lng) FROM tripdata b
	WHERE b.end_station_id = a.end_station_id
) FROM tripdata a WHERE LEN(a.end_station_id) > 0



--for blank station ids but non-blank names return coordinates and station id of first match 

UPDATE a 
SET start_lat= (
SELECT TOP 1 start_lat FROM tripdata b WHERE b.start_station_name=a.start_station_name 
AND LEN(b.start_station_id) > 0 )
FROM tripdata a WHERE LEN(a.start_station_id) = 0

UPDATE a 
SET start_lng= (
SELECT TOP 1 start_lng FROM tripdata b WHERE b.start_station_name=a.start_station_name 
AND LEN(b.start_station_id) > 0 )
FROM tripdata a WHERE LEN(a.start_station_id) = 0

UPDATE a 
SET start_station_id= (
SELECT TOP 1 start_station_id FROM tripdata b WHERE b.start_station_name=a.start_station_name 
AND LEN(b.start_station_id) > 0 )
FROM tripdata a WHERE LEN(a.start_station_id) = 0


UPDATE a 
SET end_lat= (
SELECT TOP 1 end_lat FROM tripdata b WHERE b.end_station_name=a.end_station_name 
AND LEN(b.end_station_id) > 0 )
FROM tripdata a WHERE LEN(a.end_station_id) = 0

UPDATE a 
SET end_lng= (
SELECT TOP 1 end_lng FROM tripdata b WHERE b.end_station_name=a.end_station_name 
AND LEN(b.end_station_id) > 0 )
FROM tripdata a WHERE LEN(a.end_station_id) = 0

UPDATE a 
SET end_station_id= (
SELECT TOP 1 end_station_id FROM tripdata b WHERE b.end_station_name=a.end_station_name 
AND LEN(b.end_station_id) > 0 )
FROM tripdata a WHERE LEN(a.end_station_id) = 0


--for each non-blank station id give min name 


UPDATE a 
SET start_station_name= (
SELECT TOP 1 MIN(start_station_name) FROM tripdata b WHERE b.start_station_id=a.start_station_id
AND LEN(b.start_station_name) > 0 )
FROM tripdata a WHERE LEN(a.start_station_id) > 0


UPDATE a 
SET end_station_name= (
SELECT TOP 1 MIN(end_station_name) FROM tripdata b WHERE b.end_station_id=a.end_station_id
AND LEN(b.end_station_name) > 0 )
FROM tripdata a WHERE LEN(a.end_station_id) > 0


--REMOVING DUPLICATES AND INVALID RIDES


DELETE FROM tripdata WHERE ended_at <= started_at
--539 rows removed 
 

SELECT ride_id, COUNT(*) AS num_entries FROM tripdata GROUP BY ride_id HAVING COUNT(*) > 1 ;
--there are no rows sharing same ride id and all rows are distinct



DELETE FROM tripdata WHERE ride_id != 
(SELECT TOP 1 ride_id FROM tripdata AS b WHERE
tripdata.rideable_type = b.rideable_type AND
tripdata.started_at = b.started_at AND
tripdata.ended_at = b.ended_at AND
tripdata.start_station_name = b.start_station_name AND
tripdata.start_station_id = b.start_station_id AND
tripdata.end_station_name = b.end_station_name AND
tripdata.end_station_id = b.end_station_id AND
tripdata.start_lat = b.start_lat AND
tripdata.start_lng = b.start_lng AND
tripdata.end_lat = b.end_lat AND
tripdata.end_lng = b.end_lng AND
tripdata.member_casual = b.member_casual)
--20 rows removed - removing all but one of each set of rows that are identical except for ride-id


--ADDING NEW COLLUMNS 


ALTER TABLE tripdata ADD week_day VARCHAR(255)
ALTER TABLE tripdata ADD month VARCHAR(255)
ALTER TABLE tripdata ADD duration REAL


UPDATE a 
SET week_day = (
SELECT DATENAME(w, started_at) FROM tripdata b WHERE a.ride_id = b.ride_id)
FROM tripdata a


UPDATE a 
SET month = (
SELECT DATENAME(m, started_at) FROM tripdata b WHERE a.ride_id = b.ride_id)
FROM tripdata a

UPDATE a 
SET duration = (
SELECT CAST(DATEDIFF(s, started_at, ended_at) AS REAL)/60
FROM tripdata b WHERE a.ride_id = b.ride_id)
FROM tripdata a
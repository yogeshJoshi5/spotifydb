-- New project Spotify where I have solved in total 15 problems resulting from easy to advance levels.

DROP TABLE IF EXISTS SPOTIFY

------ CREATING TABLE TO LOAD DATASET AND IMPORTING DATA SET.

CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

SELECT * FROM SPOTIFY


SELECT * FROM SPOTIFY LIMIT 5




---EDA

SELECT COUNT(*) FROM SPOTIFY 

SELECT COUNT(DISTINCT(ARTIST) ) FROM SPOTIFY

SELECT COUNT(DISTINCT(ALBUM) ) FROM SPOTIFY

---- FINDING LOUDNESS MAX WITH 2 DIFFERENT WAYS USING SUB-QUERIES AND ORDER BY CLAUSE 

SELECT * FROM SPOTIFY 
WHERE LOUDNESS = 
                (SELECT MAX(LOUDNESS) FROM SPOTIFY)


SELECT * FROM SPOTIFY 
ORDER BY LOUDNESS DESC LIMIT 1


----FINDING NULL VALUES

SELECT *
FROM spotify
WHERE artist IS NULL
   OR track IS NULL
   OR album IS NULL
   OR album_type IS NULL
   OR danceability IS NULL
   OR energy IS NULL
   OR loudness IS NULL
   OR speechiness IS NULL
   OR acousticness IS NULL
   OR instrumentalness IS NULL
   OR liveness IS NULL
   OR valence IS NULL
   OR tempo IS NULL
   OR duration_min IS NULL
   OR title IS NULL
   OR channel IS NULL
   OR views IS NULL
   OR likes IS NULL
   OR comments IS NULL
   OR licensed IS NULL
   OR official_video IS NULL
   OR stream IS NULL
   OR energy_liveness IS NULL
   OR most_played_on IS NULL;


DELETE FROM SPOTIFY 
WHERE artist IS NULL
   OR track IS NULL
   OR album IS NULL
   OR album_type IS NULL
   OR danceability IS NULL
   OR energy IS NULL
   OR loudness IS NULL
   OR speechiness IS NULL
   OR acousticness IS NULL
   OR instrumentalness IS NULL
   OR liveness IS NULL
   OR valence IS NULL
   OR tempo IS NULL
   OR duration_min IS NULL
   OR title IS NULL
   OR channel IS NULL
   OR views IS NULL
   OR likes IS NULL
   OR comments IS NULL
   OR licensed IS NULL
   OR official_video IS NULL
   OR stream IS NULL
   OR energy_liveness IS NULL
   OR most_played_on IS NULL;


 SELECT * FROM SPOTIFY
 WHERE DURATION_MIN = 0 


 --- FINDING DUPLICATE VALUE

SELECT *, COUNT(*) AS dup_count
FROM spotify
GROUP BY artist, track, album, album_type, danceability, energy, loudness,
         speechiness, acousticness, instrumentalness, liveness, valence,
         tempo, duration_min, title, channel, views, likes, comments,
         licensed, official_video, stream, energy_liveness, most_played_on
HAVING COUNT(*) > 1;


 --SOLVING PROBLEMS

 --1. Retrieve the names of all tracks that have more than 1 billion streams.

 SELECT * FROM SPOTIFY 
 WHERE STREAM >= 1000000000

 --2. List all albums along with their respective artists.

 SELECT DISTINCT ALBUM FROM SPOTIFY
 SELECT DISTINCT ARTIST FROM SPOTIFY

 SELECT DISTINCT ARTIST, ALBUM FROM SPOTIFY
 ORDER BY ARTIST 

 --2A. CHECKING THE COUNT OF ALUBMS BY ALL THE ARTIST

 SELECT ARTIST, COUNT(ALBUM)
 FROM SPOTIFY
 GROUP BY  ARTIST
 ORDER BY COUNT(ALBUM) DESC

 ---3. Get the total number of comments for tracks where licensed = TRUE.


 SELECT * FROM SPOTIFY
 SELECT DISTINCT LICENSED FROM SPOTIFY

 SELECT COMMENTS 
 FROM SPOTIFY 
 WHERE LICENSED = 'true' 

 ---3A. FINDING TOTAL NUMBER 

 SELECT SUM(COMMENTS) AS TOTAL_COMMENTS, COUNT(COMMENTS) AS TOTAL_COUNTS
 FROM SPOTIFY 
 WHERE LICENSED = 'true' 
 GROUP BY LICENSED 


 -- 4. Find all tracks that belong to the album type single.

 SELECT * FROM SPOTIFY LIMIT 5

 SELECT DISTINCT ALBUM_TYPE FROM SPOTIFY

 SELECT TRACK FROM SPOTIFY 
 WHERE ALBUM_TYPE = 'single'
 

 --5. Count the total number of tracks by each artist.

 SELECT ARTIST, COUNT(TRACK) AS TOTAL_SONGS
 FROM SPOTIFY
 GROUP BY ARTIST
 ORDER BY COUNT(TRACK) DESC


 -- 6. Calculate the average danceability of tracks in each album.


 SELECT  danceability FROM SPOTIFY

SELECT DISTINCT ALBUM FROM SPOTIFY

SELECT ALBUM, AVG(danceability) 
FROM SPOTIFY
GROUP BY ALBUM
ORDER BY 2 DESC


--7. Find the top 5 tracks with the highest energy values.

SELECT * FROM SPOTIFY LIMIT 2

SELECT TRACK, ENERGY 
FROM SPOTIFY
ORDER BY ENERGY DESC
LIMIT 5

--8. List all tracks along with their views and likes where official_video = TRUE.

SELECT DISTINCT TRACK FROM SPOTIFY

SELECT TRACK, SUM(VIEWS) AS TOTAL_VIEW, SUM(LIKES) AS TOTAL_LIKES
FROM SPOTIFY 
WHERE OFFICIAL_VIDEO = 'true'
GROUP BY TRACK
ORDER BY 2 DESC

--9. For each album, calculate the total views of all associated tracks.

SELECT DISTINCT ALBUM  FROM SPOTIFY

WITH MY_CTE AS (
SELECT ALBUM, TRACK, VIEWS FROM SPOTIFY
)

SELECT ALBUM, SUM(VIEWS) AS TOTAL_VIEWS 
FROM MY_CTE 
GROUP BY ALBUM 
ORDER BY 2 DESC


--10. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT 
    track,
    SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END) AS spotify_streams,
    SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END) AS youtube_streams
FROM spotify
GROUP BY track
HAVING SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END) >
       SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END);
 

--- 11. where track have both the views from spotify and youtube

SELECT track
FROM spotify
WHERE most_played_on IN ('Spotify', 'Youtube')
GROUP BY track
HAVING COUNT(DISTINCT most_played_on) = 2;


-- 12. Find the top 3 most-viewed tracks for each artist.

SELECT * FROM SPOTIFY LIMIT 3


WITH RNK_CTE AS (SELECT ARTIST, TRACK, SUM(VIEWS),
DENSE_RANK() OVER(PARTITION BY ARTIST ORDER BY SUM(VIEWS) DESC) AS RNK 
FROM SPOTIFY
GROUP BY ARTIST, TRACK)

SELECT * FROM RNK_CTE WHERE RNK<=3


--13. Write a query to find tracks where the liveness score is above the average.


SELECT TRACK, LIVENESS FROM SPOTIFY 
WHERE LIVENESS > (SELECT AVG(LIVENESS) FROM SPOTIFY)


-- 14. calculate the highest and lowest energy values for tracks in each album.

SELECT DISTINCT ALBUM FROM SPOTIFY

WITH ENERGY_CTE AS (
SELECT ALBUM, MAX(ENERGY),
MIN(ENERGY)
FROM SPOTIFY
GROUP BY ALBUM
)


--15. Calculate  likes for tracks for album and ranking them with highest like.


SELECT * FROM SPOTIFY

SELECT ALBUM, TRACK, LIKES,
RANK() OVER(PARTITION BY ALBUM ORDER BY LIKES DESC )
FROM SPOTIFY

 
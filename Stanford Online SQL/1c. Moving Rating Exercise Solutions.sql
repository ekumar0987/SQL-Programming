--SQL Movie Rating Query Exercises

--1. Find the titles of all movies directed by Steven Spielberg
SELECT title
FROM Movie
WHERE director = 'Steven Spielberg'

--2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
SELECT DISTINCT m.year
FROM Movie m
JOIN Rating r
	ON m.mID = r.mID
	AND stars IN (4,5)

--3.Find the titles of all movies that have no ratings.
SELECT title
FROM Movie m
LEFT JOIN Rating r
	ON m.mID = r.mID
WHERE r.mID IS NULL

--4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
SELECT DISTINCT re.name 
FROM Reviewer re
JOIN Rating ra
	ON re.rID = ra.rID
WHERE ra.ratingDate IS NULL

--5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, 
--   first by reviewer name, then by movie title, and lastly by number of stars.
SELECT re.name, m.title, ra.stars, ra.ratingDate
FROM Rating ra
JOIN Movie m
	ON ra.mID = m.mID
JOIN Reviewer re
	ON ra.rID = re.rID
ORDER BY 1,2,3

--#6. For all cases WHERE the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
SELECT r.name, m.title
FROM Rating ra1
JOIN Rating ra2
	ON ra1.rID = ra2.rID
	AND ra1.mID = ra2.mID
	AND ra2.stars > ra1.stars
	AND ra2.ratingDate > ra1.ratingDate  --Make sure the 2nd rating date was after the 1st one
JOIN Reviewer r
	ON ra1.rID = r.rID
JOIN Movie m	
	ON ra1.mID = m.mID

--7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 
SELECT m.title, sub.[Max Rating]
FROM
	(
	SELECT r.mID, MAX(stars) AS 'Max Rating'
	FROM Rating r
	JOIN Movie m
		ON r.mID = m.mID
	GROUP BY r.mID
	) sub
JOIN Movie m
	ON sub.mID = m.mID 
ORDER BY 1

--#8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
--    Sort by rating spread FROM highest to lowest, then by movie title
SELECT m.title, sub.[Rating Spread]
FROM 
(
SELECT r.mID, MAX(stars) - MIN(stars) AS 'Rating Spread'
FROM Rating r
GROUP BY r.mID
) sub
JOIN Movie m
	ON sub.mID = m.mID
ORDER BY 2 DESC,1	--Or use full expression ORDER  MAX(stars) - MIN(stars)  DESC, 1

--#9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the 
--   average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 
SELECT
(
	SELECT AVG(MovieAverageBefore)
	FROM
	(
		SELECT r.mID, AVG(stars) AS 'MovieAverageBefore'
		FROM Rating r
		JOIN Movie m
			ON r.mID = m.mID
			AND m.year < 1980
		GROUP BY r.mID
	) sub
)
-
(
	SELECT AVG(sub.MovieAverageAfter)
	FROM
	(
		SELECT r.mID, AVG(stars) AS 'MovieAverageAfter'
		FROM Rating r
		JOIN Movie m
			ON r.mID = m.mID
			AND m.year >= 1980
		GROUP BY r.mID
	) sub
)


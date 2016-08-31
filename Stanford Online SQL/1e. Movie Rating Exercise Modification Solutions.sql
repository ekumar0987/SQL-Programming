--Q1. Add the reviewer Roger Ebert to your database, with an rID of 209
INSERT INTO Reviewer(rID, name)
VALUES (209, 'Roger Ebert')

--#Q2. Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. 
INSERT INTO Rating(rID, mID, stars, ratingDate)
SELECT r.rID, m.mID, 5, NULL 
FROM Movie m, Reviewer r			--Cartesian product
WHERE r.name = 'James Cameron'

--Q3. For all movies that have an average rating of 4 stars or higher, add 25 to the release year. 
--   (Update the existing tuples; don't insert new tuples.) 
UPDATE Movie
SET year = year+25
WHERE mID IN
(
	SELECT r.mID
	FROM Rating r
	GROUP BY r.mID
	HAVING AVG(r.stars) >= 4
)

--#Q4. Remove all ratings (REMEMBER ITS NOT supposed to remove the movie entirely!!) where the movie's year is before 
--    1970 or after 2000, and the rating is fewer than 4 stars. 
DELETE FROM Rating
WHERE mID IN
(
SELECT m.mID
FROM Movie m
JOIN Rating r
	ON m.mID = r.mID
	AND ( m.year < 1970 OR m.year > 2000) 
)
AND stars < 4

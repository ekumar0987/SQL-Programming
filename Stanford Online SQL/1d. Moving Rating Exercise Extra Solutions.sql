--SQL Movie Rating Extra Query Exercises

--1. Find the names of all reviewers who rated Gone with the Wind
SELECT DISTINCT re.name
FROM Rating ra
JOIN Movie m
	ON ra.mID = m.mID
	AND m.title = 'Gone with the Wind'
JOIN Reviewer re
	ON ra.rID = re.rID

--2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
SELECT re.name, m.title, ra.stars
FROM Rating ra
JOIN Reviewer re
	ON ra.rID = re.rID
JOIN Movie m
	ON re.name = m.director
	AND ra.mID = m.mID

--3. Return all reviewer names and movie names together in a single list, alphabetized. 
--(Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 

SELECT re.name
FROM Reviewer re
UNION ALL
SELECT m.title
FROM Movie m
ORDER BY 1

--# Only 1 ORDER BY in a compound statement. Also DISTINCT and ORDER BY cannot be used in a single query

--#4. Find the titles of all movies not reviewed by Chris Jackson. 
-- If Chris Jackson reviewed Star Wars, that movie should not be in the result because someone else had also rated it

SELECT title
FROM Movie
WHERE mID NOT IN 
	(
		--Movies reviewed by Chris
		SELECT m.mID
		FROM Movie m
		JOIN Rating ra
			on m.mID = ra.mID
		JOIN Reviewer re
			ON ra.rID = re.rID
			AND re.name = 'Chris Jackson'
	)


--#5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
--   Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
SELECT DISTINCT
	CASE WHEN re1.name < re2.name THEN re1.name ELSE re2.name END,
	CASE WHEN re1.name > re2.name THEN re1.name ELSE re2.name END
FROM Rating ra1
JOIN Rating ra2
	ON ra1.mID = ra2.mID
	AND ra1.rID <> ra2.rID
JOIN Reviewer re1
	ON ra1.rID = re1.rID
JOIN Reviewer re2
	ON ra2.rID = re2.rID


--Q6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 

SELECT re.name, m.title, ra.stars
FROM Rating ra
JOIN Reviewer re
	ON ra.rID = re.rID
JOIN Movie m
	ON ra.mID = m.mID
WHERE ra.stars IN
	(
		SELECT MIN(stars)
		FROM Rating
	)


--Q7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
SELECT title,sub.Average
FROM Movie m2
JOIN
		(
		SELECT m.mID, AVG(ra.stars) AS 'Average'
		FROM Rating ra
		JOIN Movie m
			ON ra.mID = m.mID
		GROUP BY m.mID
		) sub
ON m2.mID = sub.mID
ORDER BY 2 DESC,1


--Q8 Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT)
SELECT DISTINCT re.name
FROM Rating ra
JOIN Reviewer re
	ON ra.rID = re.rID
GROUP BY re.name
HAVING COUNT(*) >= 3

--#Extra Challenge
SELECT DISTINCT re.name
FROM Rating ra1
JOIN Rating ra2 
	ON ra1.rID = ra2.rID AND ISNULL(CONVERT(VARCHAR(50),ra1.ratingDate),'NA') <> ISNULL(CONVERT(VARCHAR(50),ra2.ratingDate),'NA')
JOIN Rating ra3
	ON ra2.rID = ra3.rID AND ISNULL(CONVERT(VARCHAR(50),ra1.ratingDate),'NA') <> ISNULL(CONVERT(VARCHAR(50),ra3.ratingDate),'NA')
	AND ISNULL(CONVERT(VARCHAR(50),ra2.ratingDate),'NA') <> ISNULL(CONVERT(VARCHAR(50),ra3.ratingDate),'NA')
JOIN Reviewer re
	ON ra1.rID = re.rID

/*
CONVERT function needed because rating date is DATETIME and NA is character string. This caused conversion
issues in ISNULL wrapper. The replacement value should be of the same type as the parameter being replaced
*/


--Q9 Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. 
--Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
SELECT m1.title, m1.director
FROM Movie m1
WHERE m1.director IN
	(
		SELECT m.director
		FROM Movie m
		GROUP BY m.director
		HAVING COUNT(*) > 1
	)
ORDER BY 2,1

--Extra Challenge
SELECT m3.title, m3.director
FROM Movie m3
WHERE m3.director IN
	(
		SELECT m1.director
		FROM Movie m1
		JOIN Movie m2
			ON m1.director = m2.director
			AND m1.mID <> m2.mID
	)
ORDER BY 2,1

--Q10 Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
SELECT DISTINCT m2.title
FROM Rating ra2
JOIN Movie m2
	ON ra2.mID = m2.mID
GROUP BY m2.title
HAVING AVG(ra2.stars)    --Use aggregate function in HAVING clause not WHERE clause
IN
(
	--Find the max of all the averages
	SELECT MAX(Average) AS 'Max'
	FROM
		(
		SELECT m.mID, AVG(ra.stars) AS 'Average'
		FROM Rating ra
		JOIN Movie m
			ON ra.mID = m.mID
		GROUP BY m.mID
		) sub
)

--Q11 Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 
--Similar to previous 


--#Q12 For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value 
--of that rating. Ignore movies whose director is NULL
SELECT DISTINCT m2.director, m2.title, sub.Maximum
FROM Movie m2
JOIN Rating r2
	ON m2.mID = r2.mID
JOIN
	(
		SELECT m.director, MAX(r.stars) AS 'Maximum'
		FROM Movie m
		JOIN Rating r
			ON m.mID = r.mID
		WHERE director IS NOT NULL
		GROUP BY m.director
	) sub
ON m2.director = sub.director
AND r2.stars = sub.Maximum

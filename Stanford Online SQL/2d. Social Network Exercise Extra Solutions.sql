--Q1. For every situation where student A likes student B, but student B likes a different student C, 
--    return the names and grades of A, B, and C. 
SELECT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM Likes l1
JOIN Likes l2
	ON l1.ID2 = l2.ID1
	AND l2.ID2 <> l1.ID1   --A likes B, but B likes C
JOIN Highschooler h1
	ON l1.ID1 = h1.ID
JOIN Highschooler h2
	ON l1.ID2 = h2.ID
JOIN Highschooler h3
	ON l2.ID2 = h3.ID

--Q2. Find those students for whom "all" of their friends are in different grades from themselves. 
--    Return the students' names and grades. 
SELECT h3.name, h3.grade
FROM Highschooler h3
WHERE h3.ID NOT IN
(
	--Have atleast 1 friend in the same grade
	SELECT DISTINCT f.ID1
	FROM Friend f
	JOIN Highschooler h1
		ON f.ID1 = h1.ID
	JOIN Highschooler h2
		ON f.ID2 = h2.ID
	WHERE h1.grade = h2.grade
)

--Q3. What is the average number of friends per student? (Your result should be just one number.) 
SELECT AVG(FriendCount)
FROM
(
	SELECT COUNT(*) AS 'FriendCount'
	FROM Friend f
	GROUP BY f.ID1
) AS sub

--#Q4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. 
--    Do not count Cassandra, even though technically she is a friend of a friend.
SELECT COUNT(*)
FROM 
(
	--Friends of Cassandra
	SELECT f1.ID2 
	FROM Friend f1
	JOIN Highschooler h1
		ON h1.ID = f1.ID1
		AND h1.name = 'Cassandra'
		
	UNION
	
	--Friends of friends of Cassandra, but not Cassandra herself
    SELECT f2.ID2
    FROM Highschooler h1
    JOIN Friend f1
        ON h1.ID = f1.ID1
        AND h1.name = 'Cassandra'
    JOIN Friend f2
        ON f1.ID2 = f2.ID1
        AND f2.ID2 <> f1.ID1
) AS sub

--Q5. Find the name and grade of the student(s) with the greatest number of friends.
SELECT h.name, h.grade
FROM Highschooler h
JOIN
(
	SELECT f2.ID1
	FROM Friend f2
	GROUP BY f2.ID1
	HAVING COUNT(*)
	IN
		(
			SELECT MAX(FriendCount)
				FROM
				(
					--Friend counts
					SELECT f.ID1, COUNT(*) AS 'FriendCount'
					FROM Friend f
					GROUP BY f.ID1
				) AS sub
		)
) AS sub2
  ON sub2.Id1 = h.ID

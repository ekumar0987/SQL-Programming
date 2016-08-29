--Q1. Find the names of all students who are friends with someone named Gabriel
SELECT h2.name
FROM Highschooler h
JOIN Friend f
	ON h.ID = f.ID1
	AND h.name = 'Gabriel'
JOIN Highschooler h2
	ON f.ID2 = h2.ID


--Q2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, 
--    and the name and grade of the student they like. 
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Highschooler h1
JOIN Likes l
	ON h1.ID = l.ID1
JOIN Highschooler h2
	ON l.ID2 = h2.ID
	AND h1.grade - h2.grade >= 2

--Q3. For every pair of students who both like each other, return the name and grade of both students. 
--    Include each pair only once, with the two names in alphabetical order. 
SELECT DISTINCT
	CASE WHEN h1.name < h2.name THEN h1.name ELSE h2.name END,
	CASE WHEN h1.name < h2.name THEN h1.grade ELSE h2.grade END,
	CASE WHEN h1.name > h2.name THEN h1.name ELSE h2.name END,
	CASE WHEN h1.name > h2.name THEN h1.grade ELSE h2.grade END
FROM Likes l1
JOIN Likes l2
	ON l1.ID2 = l2.ID1 AND l2.ID2 = l1.ID1		--ID1 likes ID2, ID2 likes ID1
JOIN Highschooler h1
	ON l1.ID1 = h1.ID
JOIN Highschooler h2
	ON l1.ID2 = h2.ID


--Q4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names 
--    and grades. Sort by grade, then by name within each grade.

--Approach 1
SELECT name, grade
FROM Highschooler
WHERE ID NOT IN
(
	SELECT ID1
	FROM Likes
	UNION
	SELECT ID2
	FROM Likes 
)
ORDER BY 2,1

--Approach 2 using LEFT JOINS
SELECT h.name, h.grade
FROM Highschooler h
LEFT JOIN Likes l1
    ON l1.ID1 = h.ID        --ID1 likes someone
LEFT JOIN Likes l2
    ON l2.ID2 = h.ID        --ID2 is liked by someone
WHERE l1.ID1 IS NULL AND l2.ID2 IS NULL  


--Q5. For every situation where student A likes student B, but we have no information about whom B likes 
--   (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Likes l1
JOIN Highschooler h1
	ON l1.ID1 = h1.ID
JOIN Highschooler h2
	ON l1.ID2 = h2.ID
WHERE l1.ID2 NOT IN
(
	SELECT l2.ID1 FROM Likes l2
)


--#Q6. Find names and grades of students who only have friends in the same grade. 
--    Return the result sorted by grade, then by name within each grade. 
SELECT h3.name, h3.grade
FROM Highschooler h3
WHERE ID NOT IN
(
	--Those who have friends in another grade
	SELECT f1.ID1
	FROM Friend f1
	JOIN Highschooler h1
		ON f1.ID1 = h1.ID
	JOIN Highschooler h2
		ON f1.ID2 = h2.ID
		AND h1.grade <> h2.grade 
)
ORDER BY 2,1

--#Q7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common 
--    (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 

--Approach 1: LEFT JOIN
SELECT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM
	(
	--Like each other but are not friends
	SELECT l2.ID1, l2.ID2
	FROM Likes l2
	LEFT JOIN
	(
	--Like each other and are friends
		SELECT l.ID1, l.ID2
		FROM Likes l
		JOIN Friend f
			ON l.ID1 = f.ID1 AND l.ID2 = f.ID2
	) AS sub
	ON l2.ID1 = sub.ID1 AND l2.ID2 = sub.ID2
	WHERE sub.ID1 IS NULL AND sub.ID2 IS NULL
	) AS sub2
JOIN Friend f2
	ON f2.ID1 = sub2.ID1
JOIN Friend f3
	ON f2.ID2 = f3.ID1 AND f3.ID2 = sub2.ID2
JOIN Highschooler h1
	ON sub2.ID1 = h1.ID
JOIN Highschooler h2
	ON sub2.ID2 = h2.ID
JOIN Highschooler h3
	ON f3.ID1 = h3.ID

--Approach 2: EXCEPT
SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM 
( 
SELECT L1.ID1 AS 'ID1', L1.ID2 AS 'ID2' FROM Likes L1
EXCEPT 
--Likes + Friends
SELECT L2.ID1,L2.ID2 FROM Likes L2
    JOIN Friend F1
    ON L2.ID1 = F1.ID1 AND L2.ID2 = F1.ID2
) AS sub --Likes+not friends
JOIN Friend F2
    ON F2.ID1 = sub.ID1 
JOIN Friend F3
    ON F2.ID2 = F3.ID1 AND F3.ID2 = sub.ID2
JOIN Highschooler H1
    ON sub.ID1 = H1.ID
JOIN Highschooler H2
    ON sub.ID2 = H2.ID
JOIN Highschooler H3
    ON F3.ID1 = H3.ID

--Q8. Find the difference between the number of students in the school and the number of different first names. 
SELECT COUNT(*) - COUNT(DISTINCT name)
FROM Highschooler


--Q9. Find the name and grade of all students who are liked by more than one other student. 
SELECT h.name, h.grade
FROM Highschooler h
JOIN
(
	SELECT l.ID2
	FROM Likes l
	GROUP BY l.ID2
	HAVING COUNT(*) > 1
) AS sub
	ON sub.ID2 = h.ID
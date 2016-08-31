--Q1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 
DELETE 
FROM Highschooler
WHERE grade = 12

--Q2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 

DELETE FROM Likes WHERE ID1 IN
(
	SELECT l3.ID1
	FROM Likes l3
	LEFT JOIN
	(
		--A likes B, B likes A and they're friends
		SELECT l1.ID1, l1.ID2
		FROM Likes l1
		JOIN Likes l2
			ON l1.ID2 = l2.ID1 AND l2.ID2 = l1.ID1
		JOIN Friend f1
			ON f1.ID1 = l1.ID1 AND f1.ID2 = l1.ID2
	) AS sub
	ON l3.ID1 = sub.ID1 AND l3.ID2 = sub.ID2
	WHERE sub.ID1 IS NULL OR sub.ID2 IS NULL
)

--Q3. For all cases where A is friends with B, and B is friends with C, add a new friendship for the 
--    pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. 

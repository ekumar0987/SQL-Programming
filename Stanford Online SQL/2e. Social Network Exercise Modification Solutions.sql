--Q1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 
DELETE 
FROM Highschooler
WHERE grade = 12

--#Q2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 
DELETE l4
FROM Likes l4 
JOIN
(
	-- A and B are friends. A likes B
	SELECT l3.ID1, l3.ID2
	FROM Friend f2
	JOIN Likes l3
		ON f2.ID1 = l3.ID1 AND f2.ID2 = l3.ID2
	EXCEPT
	(
	--A and B are friends. A likes B and B likes A
	SELECT l1.ID1, l1.ID2
	FROM Likes l1
	JOIN Likes l2
		ON l1.ID2 = l2.ID1 AND l2.ID2 = l1.ID1
	JOIN Friend f1
		ON f1.ID1 = l1.ID1 AND f1.ID2 = l1.ID2
	)
) sub
ON l4.ID1 = sub.ID1 AND l4.ID2 = sub.ID2

--Note: Important to specify which table you're deleting from

--Q3. For all cases where A is friends with B, and B is friends with C, add a new friendship for the 
--    pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. 

INSERT INTO Friend(ID1,ID2)
SELECT sub.ID1, sub.ID2						--A,C combination
FROM
	(
		SELECT DISTINCT f1.ID1, f2.ID2		--SELECT A,C combinations
		FROM Friend f1
		JOIN Friend f2
			ON f1.ID2 = f2.ID1				--A is friends with B, B is friends with C
			AND f2.ID2 <> f1.ID1
	) sub
LEFT JOIN Friend f3							--Check if A,C combination already exists
	ON sub.ID1 = f3.ID1 AND sub.ID2 = f3.ID2
WHERE f3.ID1 IS NULL AND f3.ID2 IS NULL

UNION										--Friendship is mutual so we need the other combination

SELECT sub.ID2, sub.ID1						--C,A combination
FROM
	(
		SELECT DISTINCT f1.ID1, f2.ID2		--SELECT C,A combinations
		FROM Friend f1
		JOIN Friend f2
			ON f1.ID2 = f2.ID1				--A is friends with B, B is friends with C
			AND f2.ID2 <> f1.ID1
	) sub
LEFT JOIN Friend f3							--Check if A,C combination already exists
	ON sub.ID1 = f3.ID1 AND sub.ID2 = f3.ID2
WHERE f3.ID1 IS NULL AND f3.ID2 IS NULL
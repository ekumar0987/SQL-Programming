/*
Rank Scores
Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. 
Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.

+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+

+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+

*/

create table #scores(
	id int,
	score float,
)

insert into #scores
select 1, 3.50 union all
select 2, 3.65 union all
select 3, 4.00 union all
select 4, 3.85 union all
select 5, 4.00 union all
select 6, 3.65 

select score, DENSE_RANK() over (order by score desc) as 'Rank'
from #scores

drop table #scores
/*

Write a SQL query to find all numbers that appear atleast 3 times consecutively

+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+

For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

*/

create table #consecutive(
	id int,
	num int
)

insert into #consecutive
select 1, 1 union all
select 2, 1 union all
select 3, 1 union all
select 4, 2 union all
select 5, 1 union all
select 6, 2 union all
select 7, 2

select c1.num
from #consecutive c1
join #consecutive c2
	on c2.id = c1.id + 1 and c2.num = c1.num
join #consecutive c3
	on c3.id = c2.id + 1 and c3.num = c2.num 

drop table #consecutive
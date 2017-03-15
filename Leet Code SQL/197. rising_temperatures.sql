/*
Rising Temperatures

Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.
+---------+------------+------------------+
| Id(INT) | Date(DATE) | Temperature(INT) |
+---------+------------+------------------+
|       1 | 2015-01-01 |               10 |
|       2 | 2015-01-02 |               25 |
|       3 | 2015-01-03 |               20 |
|       4 | 2015-01-04 |               30 |
+---------+------------+------------------+

For example, return the following Ids for the above Weather table:
+----+
| Id |
+----+
|  2 |
|  4 |
+----+

*/

create table #temperature(
	id int,
	date date,
	temp int
)

insert into #temperature
select 1, '2015-01-01', 10 union all
select 2, '2015-01-02', 25 union all
select 3, '2015-01-03', 20 union all
select 4, '2015-01-04', 30

select t2.id
from #temperature t1
join #temperature t2
	on t2.temp > t1.temp
	and DATEADD(dd, 1, t1.date) = t2.date

drop table #temperature
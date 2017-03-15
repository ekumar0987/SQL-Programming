/*
Write a SQL query to find all duplicate emails in a table named Person

+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+

For example, your query should return the following for the above table:
+---------+
| Email   |
+---------+
| a@b.com |
+---------+

*/

create table #person(
	id int,
	email varchar(10)
)

insert into #person
select 1, 'a@b.com' union all
select 2, 'c@d.com' union all
select 3, 'a@b.com'

select email
from #person
group by email
having count(*) > 1

drop table #person
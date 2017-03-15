/*
Delete duplicate emails

Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.
+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.

For example, after running your query, the above Person table should have the following rows:
+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+

*/

create table #email(
	id int,
	email varchar(20)
)

insert into #email
select 1, 'john@example.com' union all
select 2, 'bob@example.com' union all
select 3, 'john@example.com'


select email, min(id) as 'min'
into #min
from #email
group by email
--having count(*) > 1		--important: If you add this condition even bob will be deleted


delete from #email
where id in
(
	--id s to delete
	select e.id
	from #email e
	left join #min m
		on e.email = m.email
		and e.id = m.min
	where m.email is null
)

select * from #email

drop table #email
drop table #min
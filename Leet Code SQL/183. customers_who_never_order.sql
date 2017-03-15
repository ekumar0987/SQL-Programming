/*
Customers who never order

Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

Customers
+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+

Orders
+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+

*/

create table #customers(
	id int,
	name varchar(10)
)

create table #orders(
	id int,
	customerid int
)

insert into #customers
select 1, 'Joe' union all
select 2, 'Henry' union all
select 3, 'Sam' union all
select 4, 'Max'

insert into #orders
select 1, 3 union all
select 2, 1

select c.name
from #customers c
left join #orders o
	on c.id = o.customerid
where o.id is null

drop table #customers
drop table #orders


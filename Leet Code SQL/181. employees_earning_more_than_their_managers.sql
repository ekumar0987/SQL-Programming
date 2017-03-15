/*
Employees earning more than their managers

+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+

Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.
*/

create table #employees(
	id int,
	name varchar(10),
	salary int,
	managerid int
)

insert into #employees
select 1, 'Joe', 70000, 3 union all
select 2, 'Henry', 80000, 4 union all
select 3, 'Sam', 60000, null union all
select 4, 'Max', 90000, null

select e1.name
from #employees e1
join #employees e2
	on e2.id = e1.managerid
	and e2.salary < e1.salary

drop table #employees
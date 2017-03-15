/*
Department highest salary

Employee
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
+----+-------+--------+--------------+

Department
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+

Write a SQL query to find employees who have the highest salary in each of the departments
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
*/

create table #employee(
	id int,
	name varchar(10),
	salary int,
	departmentid int
)

create table #department(
	id int,
	name varchar(10)
)

insert into #employee
select 1, 'Joe', 70000, 1 union all
select 2, 'Henry', 80000, 2 union all
select 3, 'Sam', 60000, 2 union all
select 4, 'Max', 90000, 1

insert into #department
select 1, 'IT' union all
select 2, 'Sales'

select d.name, e1.name, e1.salary
from #employee e1
join
(
	select departmentid, max(salary) as 'max salary'
	from #employee
	group by departmentid 
) e2
	on e1.departmentid = e2.departmentid
	and e1.salary = e2.[max salary]
join #department d
	on e2.departmentid = d.id

drop table #department
drop table #employee
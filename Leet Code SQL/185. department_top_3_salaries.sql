/*
Employee
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
+----+-------+--------+--------------+

Department
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+

Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows.

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
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
select 4, 'Max', 90000, 1 union all
select 5, 'Janet', 69000, 1 union all
select 6, 'Randy', 85000, 1

insert into #department
select 1, 'IT' union all
select 2, 'Sales'

select sub.Department, sub.Employee, sub.Salary
from
(
	select d.name as 'Department', e.name as 'Employee', e.salary as 'Salary', DENSE_RANK() over (partition by e.departmentid order by e.salary desc) as rank
	from #employee e
	join #department d 
		on e.departmentid = d.id
) sub
where sub.rank <= 3
order by 1

drop table #department
drop table #employee
/*
Write a SQL query to get the second highest salary from the Employee table.
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+

For example, given the above Employee table, the second highest salary is 200. If there is no second highest salary, then the query should return null.
*/


create table #employee(
	id int,
	salary int
)

insert into #employee
select 1,100 union all
select 2,200 union all
select 3,300 

--Solution 1 - Handles NULL - Using max() will return a NULL if the value doesn't exist.
SELECT max(Salary) as 'SecondHighestSalary'
FROM Employee
WHERE Salary < (SELECT max(Salary) FROM Employee)

--Solution 2 - Does not handle null
select e1.salary
from #employee e1
where 1 = (select count(distinct salary) from #employee e2 where e2.salary > e1.salary)

--Solution 3 - Does not handle null
select sub.Salary
FROM
(
select e.Salary, ROW_NUMBER() OVER (ORDER BY e.Salary DESC) as 'Rank'
from Employee e
) sub
WHERE sub.Rank = 2


drop table #employee

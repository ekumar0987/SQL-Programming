/*
Nth highest salary

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+

If there is no nth highest salary, then the query should return null.
*/

create table #employee(
	id int,
	salary int
)

insert into #employee
select 1,100 union all
select 2,200 union all
select 3,300 

/*This is the outer query part */
SELECT MAX(Salary) 'Nth Highest'
FROM #Employee Emp1
WHERE (3) = ( /* Subquery starts here */
			SELECT COUNT(DISTINCT(Emp2.Salary))
			FROM #Employee Emp2
			WHERE Emp2.Salary > Emp1.Salary)

drop table #employee
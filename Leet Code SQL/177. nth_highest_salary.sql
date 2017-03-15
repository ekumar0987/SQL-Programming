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

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
        SELECT DISTINCT(Emp1.Salary) /*This is the outer query part */
        FROM Employee Emp1
        WHERE (N-1) = ( /* Subquery starts here */
        SELECT COUNT(DISTINCT(Emp2.Salary))
        FROM Employee Emp2
        WHERE Emp2.Salary > Emp1.Salary)
  );
END
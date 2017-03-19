/*Trips and Users
+----+-----------+-----------+---------+--------------------+----------+
| Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
+----+-----------+-----------+---------+--------------------+----------+
| 1  |     1     |    10     |    1    |     completed      |2013-10-01|
| 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
| 3  |     3     |    12     |    6    |     completed      |2013-10-01|
| 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
| 5  |     1     |    10     |    1    |     completed      |2013-10-02|
| 6  |     2     |    11     |    6    |     completed      |2013-10-02|
| 7  |     3     |    12     |    6    |     completed      |2013-10-02|
| 8  |     2     |    12     |    12   |     completed      |2013-10-03|
| 9  |     3     |    10     |    12   |     completed      |2013-10-03| 
| 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
+----+-----------+-----------+---------+--------------------+----------+


+----------+--------+--------+
| Users_Id | Banned |  Role  |
+----------+--------+--------+
|    1     |   No   | client |
|    2     |   Yes  | client |
|    3     |   No   | client |
|    4     |   No   | client |
|    10    |   No   | driver |
|    11    |   No   | driver |
|    12    |   No   | driver |
|    13    |   No   | driver |
+----------+--------+--------+

Write a SQL query to find the cancellation rate of requests made by unbanned clients between Oct 1, 2013 and Oct 3, 2013. 
For the above tables, your SQL query should return the following rows with the cancellation rate being rounded to two decimal places.

+------------+-------------------+
|     Day    | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 |       0.33        |
| 2013-10-02 |       0.00        |
| 2013-10-03 |       0.50        |
+------------+-------------------+

*/

create table #trips(
	id int not null,
	client_id int,
	driver_id int,
	city_id int,
	status varchar(100),
	request_at datetime
)

create table #users(
	users_id int not null,
	banned varchar(10),
	role varchar(10)
)

insert into #trips
select 1,1,10,1,'completed','2013-10-01' union all
select 2,2,11,1,'cancelled_by_driver','2013-10-01' union all
select 3,3,12,6,'completed','2013-10-01' union all
select 4,4,13,6,'cancelled_by_client','2013-10-01' union all
select 5,1,10,1,'completed','2013-10-02' union all
select 6,2,11,6,'completed','2013-10-02' union all
select 7,3,12,6,'completed','2013-10-02' union all
select 8,2,12,12,'completed','2013-10-03' union all
select 9,3,10,12,'completed','2013-10-03' union all
select 10,4,13,12,'cancelled_by_driver','2013-10-03' 

insert into #users
select 1,'No','client' union all
select 2,'Yes','client' union all
select 3,'No','client' union all
select 4,'No','client' union all
select 10,'No','driver' union all
select 11,'No','driver' union all
select 12,'No','driver' union all
select 13,'No','driver' 


select request_at as 'Day', round(cast(sum(case when t.status like '%cancelled%' then 1 else 0 end) as float)/count(*),2)
from #trips t
join #users u
	on t.client_id = u.users_id
	and u.banned = 'No'
	and t.request_at between '2013-10-01' and '2013-10-03'
group by t.request_at


drop table #trips

drop table #users
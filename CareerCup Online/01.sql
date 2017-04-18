create table student(
	sid int,
	dept varchar(10),
	startdate datetime, 
	enddate datetime
)

insert into student(sid, dept, startdate)
select 1, 'A', '2017-01-1' union all
select 1, 'B', '2017-07-1' union all
select 1, 'C', '2017-12-1'


select s1.sid, s1.dept, s1.startdate as 'Start Date', MIN(s2.startdate) as 'End Date'
from student s1
left join student s2
	on s1.sid = s2.sid
	and s2.startdate > s1.startdate
group by s1.sid, s1.dept, s1.startdate

drop table student
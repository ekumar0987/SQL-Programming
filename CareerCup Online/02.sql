create table rsvp(
	name varchar(10),
	decision varchar(10), 
	date datetime
)

insert into rsvp(name, decision, date)
select 'Jon', 'Y', '2016-01-01' union all
select 'Jon', 'N', '2016-01-02' union all
select 'Linda', 'Y', '2016-01-01' union all
select 'Mark', 'Y', '2016-01-05' union all
select 'Rob', 'N', '2016-01-05' 


select count(*) 
from rsvp r2
join
	(
	select r.name as 'name', max(r.date) as 'LatestResponseDate'
	from rsvp r
	group by r.name
	) LatestResponse 
on  LatestResponse.name = r2.name
and LatestResponse.LatestResponseDate = r2.date
where r2.decision = 'Y'


drop table rsvp
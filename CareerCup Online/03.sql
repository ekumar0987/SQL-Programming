create table user2(
	userid varchar(10), 
	date datetime
)

insert into user2(userid, date)
select '1','2016-01-01' union all
select '1','2016-01-02' union all
select '1','2016-01-01' union all
select '2','2016-01-05' union all
select '3','2016-01-01' union all
select '3','2016-01-02' union all
select '3','2016-01-01' 


select distinct userid 
from user2
group by userid
having count(*) = 
				(
					select MAX(LoginCount) from
					(
						select userid, count(*) as 'LoginCount'
						from user2
						group by userid
					) sub
				) 

drop table user2
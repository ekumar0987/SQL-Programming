/*
Return IDs of parent along with their oldest and youngest children
*/
create table parent(
	ID int,
	Age int
)

create table children(
	ID int,
	Age int,
	pid int
)

insert into parent
select 1, 30 union all
select 2, 31 union all
select 3, 35

insert into children
select 1, 2, 1 union all
select 2, 5, 1 union all
select 3, 7, 1 union all
select 4, 9, 1 union all
select 5, 1, 2 union all
select 6, 3, 2 union all
select 7, 9, 2 union all 
select 8, 12, 3

select sub.ID as 'Parent ID', youngest.ID as 'Youngest Child ID', eldest.ID as 'Eldest Child ID'
FROM
	(
		select p.ID, MIN(c.age) as 'YoungestAge', MAX(c.age) as 'EldestAge'
		from parent p
		join children c
			on p.ID = c.pid
		group by p.ID
	) sub
	join children youngest
		on sub.ID = youngest.pid
		and sub.YoungestAge = youngest.age
	join children eldest
		on sub.ID = eldest.pid
		and sub.EldestAge = eldest.age

drop table parent
drop table children

/*
Output

Parent ID	Youngest Child ID	Eldest Child ID
1	1	4
2	5	7
3	8	8

*/
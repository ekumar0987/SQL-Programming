/*
Person:
	PersonId
	FirstName
	LastName

Address:
	AddressId
	PersonId
	City
	State

Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:
FirstName, LastName, City, State

*/


select firstname, lastname, city, state
from Person p
left join Address a
	on p.PersonId = a.PersonId
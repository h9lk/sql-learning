-- Basic
-- How can you retrieve all the information from the cd.facilities table?
Select * 
From cd.facilities;

/*You want to print out a list of all of the facilities and their cost to members. 
How would you retrieve a list of only facility names and costs?*/
Select name, membercost
From cd.facilities;

-- How can you produce a list of facilities that charge a fee to members?
Select *
From cd.facilities
Where membercost > 0;


/*How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost?
 Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.*/
Select facid, name, membercost, monthlymaintenance
From cd.facilities
Where membercost > 0 and membercost < monthlymaintenance/50;

-- How can you produce a list of all facilities with the word 'Tennis' in their name?
Select *
From cd.facilities
Where name like '%Tennis%';

-- How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.
Select *
From cd.facilities
Where facid in (1,5);

/* How can you produce a list of facilities, with each labelled as 'cheap' or 'expensive' depending on if their monthly maintenance cost is more than $100? 
Return the name and monthly maintenance of the facilities in question. */
Select name, 
	Case
		When monthlymaintenance>100 then 'expensive'
		Else 'cheap'
	End as cost
From cd.facilities

/* How can you produce a list of members who joined after the start of September 2012? 
Return the memid, surname, firstname, and joindate of the members in question.*/
SelectT memid, surname, firstname, joindate 
From cd.members
Where joindate Between '2012-09-01' and '2012-09-30';
--
Select memid, surname, firstname, joindate 	
From cd.members
Where joindate >= '2012-09-01'; 

/* How can you produce an ordered list of the first 10 surnames in the members table? 
The list must not contain duplicates.*/
Select Distinct surname
From cd.members
Order by surname
Limit 10;

/* You, for some reason, want a combined list of all surnames and all facility names.
 Yes, this is a contrived example :-). Produce that list!*/
Select surname
From cd.members
Union 
Select name
From cd.facilities;

-- You'd like to get the signup date of your last member. How can you retrieve this information?
Select joindate
From cd.members
Order by joindate desc
Limit 1;
--
Select max(joindate) as latest
From cd.members; 

/* You'd like to get the first and last name of the last member(s) who signed up - not just the date. 
How can you do that?*/
Select firstname, surname, joindate
From cd.members
Order by joindate desc
Limit 1;
--
Select firstname, surname, joindate
From cd.members
Where joindate = 
	(Select max(joindate) 
	 From cd.members); 

-- Joins and Subqueries
-- How can you produce a list of the start times for bookings by members named 'David Farrell'?
Select b.starttime 
From cd.bookings b
Join cd.members m on m.memid=b.memid 
Where m.firstname='David' and m.surname='Farrell';

/* How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? 
Return a list of start time and facility name pairings, ordered by the time.*/
Select b.starttime as start, f.name
From cd.bookings b
Join cd.facilities f on f.facid=b.facid
Where f.name like 'Tennis Court%' 
and b.starttime>='2012-09-21' 
and b.starttime<'2012-09-22'
Order by b.starttime;
--
Select b.starttime as start, f.name
From cd.bookings b
Join cd.facilities f on f.facid=b.facid
Where f.name like 'Tennis Court%' 
and b.starttime in 
		(Select starttime
		From cd.bookings
		Where starttime>='2012-09-21' 
		and starttime<'2012-09-22')
Order by b.starttime;

/* How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).*/
Select distinct r.firstname, r.surname
From cd.members m
Join cd.members r on r.memid = m.recommendedby
order by surname, firstname;

/* How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname). */
Select 
m.firstname memfname, m.surname memsnamer, 
r.firstname recfname, r.surname recsname
From cd.members m
Left Join cd.members r on r.memid = m.recommendedby
Order by m.surname, m.firstname;

/* How can you produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name followed by the facility name.*/
Select Distinct 
Concat(m.firstname,' ',m.surname) as member, 
f.name as facility
From cd.members m
	Join cd.bookings b on b.memid=m.memid
	Join cd.facilities f on f.facid=b.facid 
Where f.name like 'Tennis Court%'
Order by member, facility
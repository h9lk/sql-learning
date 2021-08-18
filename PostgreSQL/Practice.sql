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


/*How can you produce a list of facilities that charge a fee to members, 
and that fee is less than 1/50th of the monthly maintenance cost? 
Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.*/
Select facid, name, membercost, monthlymaintenance
From cd.facilities
Where membercost > 0 and membercost < monthlymaintenance/50;

-- How can you produce a list of all facilities with the word 'Tennis' in their name?
Select *
From cd.facilities
Where name like '%Tennis%';

-- How can you retrieve the details of facilities with ID 1 and 5? 
-- Try to do it without using the OR operator.
Select *
From cd.facilities
Where facid in (1,5);

/* How can you produce a list of facilities, 
with each labelled as 'cheap' or 'expensive' depending on if their monthly maintenance cost is more than $100?
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

-- You'd like to get the signup date of your last member. 
How can you retrieve this information?
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
--
Select b.starttime
From
	cd.bookings b,
	cd.members m
Where
	m.firstname='David'
	and m.surname='Farrell'
                and m.memid = b.memid;

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

/* How can you output a list of all members who have recommended another member?
Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).*/
Select distinct r.firstname, r.surname
From cd.members m
Join cd.members r on r.memid = m.recommendedby
order by surname, firstname;

/* How can you output a list of all members, including the individual who recommended them (if any)? 
Ensure that results are ordered by (surname, firstname). */
Select 
m.firstname memfname, m.surname memsnamer, 
r.firstname recfname, r.surname recsname
From cd.members m
Left Join cd.members r on r.memid = m.recommendedby
Order by m.surname, m.firstname; 

/* How can you produce a list of all members who have used a tennis court? 
Include in your output the name of the court, and the name of the member formatted as a single column.
Ensure no duplicate data, and order by the member name followed by the facility name.*/
Select Distinct 
Concat(m.firstname,' ',m.surname) as member, 
f.name as facility
From cd.members m
	Join cd.bookings b on b.memid=m.memid
	Join cd.facilities f on f.facid=b.facid 
Where f.name like 'Tennis Court%'
Order by member, facility

/* How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? 
Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. 
Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. 
Order by descending cost, and do not use any subqueries.*/
Select
Concat(m.firstname,' ', m.surname) as member, 
f.name as facility, 
	Case 
		when m.memid = 0 then
			b.slots*f.guestcost
		else
			b.slots*f.membercost
	End as cost
From cd.members m                
Join cd.bookings b
	on m.memid = b.memid
Join cd.facilities f
	on b.facid = f.facid
Where
	b.starttime >= '2012-09-14' and 
	b.starttime < '2012-09-15' and 
	((m.memid = 0 and b.slots*f.guestcost > 30) or
	(m.memid != 0 and b.slots*f.membercost > 30))
order by cost desc;   

/* How can you output a list of all members, including the individual who recommended them (if any), without using any joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.*/
Select Distinct
Concat(a.firstname,' ', a.surname) as member,
	(Select 
	 	Concat(b.firstname,' ',b.surname) as recommender 
	From cd.members b 
	Where b.memid = a.recommendedby)
From cd.members a
Order by member;

/* The Produce a list of costly bookings exercise contained some messy logic: we had to calculate the booking cost in both the WHERE clause and the CASE statement. Try to simplify this calculation using subqueries. For reference, the question was:

How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost.*/
Select member, facility, cost 
From (
	Select 
		Concat(m.firstname,' ',m.surname) as member,
		f.name as facility,
		Case
			When m.memid = 0 thenb.slots*f.guestcost
			Else b.slots*f.membercost
		End as cost
	From cd.members m
		Join cd.bookings b on m.memid = b.memid
		join cd.facilities f on b.facid = f.facid
		Where
  		b.starttime >= '2012-09-14' and
		b.starttime <  '2012-09-15'
	) as a
Where cost > 30
order by cost desc;

-- Modifying data 
/* The club is adding a new facility - a spa. 
We need to add it into the facilities table. Use the following values: 
facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800. */
Insert into cd.facilities
(facid, name,membercost, guestcost, initialoutlay, monthlymaintenance)
values
(9, 'Spa', 20, 30, 100000, 800);

/*In the previous exercise, you learned how to add a facility. Now you're going to add multiple facilities in one command. Use the following values:

facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
facid: 10, Name: 'Squash Court 2', membercost: 3.5, guestcost: 17.5, initialoutlay: 5000, monthlymaintenance: 80.*/
Insert into cd.facilities
(facid, name,membercost, guestcost, initialoutlay, monthlymaintenance)
values
(9, 'Spa', 20, 30, 100000, 800),
(10, 'Squash Court 2', 3.5, 17.5, 5000, 80);

/* Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:

Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.*/
Insert into cd.facilities
SELECT COUNT(facid) + 1, 'Spa', 20, 30, 100000, 800 FROM cd.facilities
Where facid>0;
--
Insert into cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    select (select max(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800;
--
Insert into cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
SELECT max(facid)+1, 'Spa', 20, 30, 100000, 800 FROM cd.facilities; 

/* We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error. */
UPDATE cd.facilities
SET initialoutlay=10000
Where initialoutlay=8000;

/* We want to increase the price of the tennis courts for both members and guests. 
Update the costs to be 6 for members, and 30 for guests.*/
UPDATE cd.facilities
SET membercost=6, guestcost=30
Where name like 'Tennis Court%';

/* We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.*/
Update cd.facilities f
Set
	membercost = (Select membercost*1.1 From cd.facilities Where name='Tennis Court 1'),
	guestcost = (Select guestcost*1.1 From cd.facilities Where name='Tennis Court 1')
Where f.name='Tennis Court 2'

/* As part of a clearout of our database, we want to delete all bookings from the cd.bookings table. 
How can we accomplish this? */
Delete From cd.bookings;

/*We want to remove member 37, who has never made a booking, from our database. 
How can we achieve that?*/
Delete From cd.members 
Where memid=37;

/* In our previous exercises, we deleted a specific member who had never made a booking. 
How can we make that more general, to delete all members who have never made a booking?*/
Delete From cd.members 
where memid not in (Select memid From cd.bookings);

-- Aggregation
/* For our first foray into aggregates, we're going to stick to something simple.
We want to know how many facilities exist - simply produce a total count.*/
Select Count(facid)
From cd.facilities;

/* Produce a count of the number of facilities that have a cost to guests of 10 or more.*/
Select count(*)
From cd.facilities
Where guestcost>=10;

/* Produce a count of the number of recommendations each member has made. Order by member ID.*/
Select recommendedby, count(*) 
From cd.members
Where recommendedby is not null
Group by recommendedby
Order by recommendedby;

/* Produce a list of the total number of slots booked per facility.
For now, just produce an output table consisting of facility id and slots, sorted by facility id.*/
Select facid, Sum(slots) as "Total Slots"
From cd.bookings
Group by facid
Order by facid;

/* Produce a list of the total number of slots booked per facility in the month of September 2012.
Produce an output table consisting of facility id and slots, sorted by the number of slots.*/
Select facid, Sum(slots) as "Total Slots"
From cd.bookings b
Where 
	starttime>='2012-09-01' and 
	starttime<'2012-10-01'
Group by facid
Order by "Total Slots";

/* Produce a list of the total number of slots booked per facility per month in the year of 2012.
Produce an output table consisting of facility id and slots, sorted by the id and month.*/
Select facid, extract(month from starttime) as month, Sum(slots) as "Total Slots"
From cd.bookings
Where 
	starttime>='2012-01-01' and 
	starttime<'2013-01-01'
Group by facid, month
Order by facid, month;
--
Select facid, 
	extract(month from starttime) as month, 
	sum(slots) as "Total Slots"
From cd.bookings
Where extract(year from starttime) = 2012
Group by facid, month
Order by facid, month;

/* Find the total number of members (including guests) who have made at least one booking. */
Select count(Distinct memid) 
From cd.bookings;

/* Produce a list of facilities with more than 1000 slots booked.
Produce an output table consisting of facility id and slots, sorted by facility id.*/
Select facid, sum(slots) as "Total Slots"
From cd.bookings
Group by facid
Having sum(slots)>1000
Order by facid;

/* Produce a list of facilities along with their total revenue. 
The output table should consist of facility name and revenue, sorted by revenue. 
Remember that there's a different cost for guests and members!*/
Select f.name, 
sum(slots * 
	Case
		When b.memid=0 
		Then f.guestcost
		Else f.membercost
	End) as revenue
From cd.bookings b
Join cd.facilities f on b.facid=f.facid
Group by f.name
Order by revenue;

/* Produce a list of facilities with a total revenue less than 1000. 
Produce an output table consisting of facility name and revenue, sorted by revenue. 
Remember that there's a different cost for guests and members!*/
-- For sql
Select f.name, 
sum(slots * 
	Case
		When b.memid=0 
		Then f.guestcost
		Else f.membercost
	End) as revenue
From cd.bookings b
Join cd.facilities f on b.facid=f.facid
Group by f.name
Having revenue<1000
Order by revenue;

-- PostgreSQL
Select name, revenue 
From 
	(Select f.name, sum
	  	(Case 
			When b.memid=0 
		 	Then b.slots*f.guestcost
			Else b.slots*f.membercost
		End) as revenue
	From cd.bookings b
	Join cd.facilities f on b.facid = f.facid
	Group by f.name
	) as a
Where revenue<1000
Order by revenue; 

/* Output the facility id that has the highest number of slots booked. 
For bonus points, try a version without a LIMIT clause. This version will probably look messy!*/
Select facid, sum(slots) as "Total Slots"
From cd.bookings
Group by facid
Order by sum(slots) desc
Limit 1;
--
With sum as 
	(Select facid, sum(slots) as totalslots
	From cd.bookings
	Group by facid)
	
Select facid, totalslots 
From sum
Where totalslots= 
	(Select max(totalslots) From sum);

/*
Declare @f int;
Set @f=(Select sum(slots)
        From cd.bookings);

Select name, max(@f)
From cd.bookings
Group by name
Limit 1;*/

/* Produce a list of the total number of slots booked per facility per month in the year of 2012. 
In this version, include output rows containing totals for all months per facility, and a total for all months for all facilities. 
The output table should consist of facility id, month and slots, sorted by the id and month. 
When calculating the aggregated values for all months and all facids, return null values in the month and facid columns.*/
Select 
	facid, 
	extract(month From starttime) as month, 
	sum(slots) as slots
From cd.bookings
Where
		starttime >= '2012-01-01'
		and starttime < '2013-01-01'
Group by rollup(facid, month)
Order by facid, month;

/* Produce a list of the total number of hours booked per facility, remembering that a slot lasts half an hour. 
The output table should consist of the facility id, name, and hours booked, sorted by facility id. 
Try formatting the hours to two decimal places.*/
Select 
	f.facid, 
	f.name, 
	Cast(sum(b.slots)/2.0 as decimal(5,2)) as "Total Hours"
From cd.bookings b
Join cd.facilities f on f.facid=b.facid
Group by f.facid, f.name
Order by f.facid;

-- PostgreSQL
Select 
	f.facid, 
	f.name,
	Trim(to_char(sum(b.slots)/2.0, '999D99')) as "Total Hours"
From cd.bookings b
Join cd.facilities f on f.facid = b.facid
Group by f.facid, f.name
Order by f.facid;

/* Produce a list of each member name, id, and their first booking after September 1st 2012. 
Order by member ID.*/
Select 
	m.surname, 
	m.firstname, 
	m.memid, 
	min(b.starttime) as starttime
From cd.bookings b
Join cd.members m on m.memid=b.memid
Where b.starttime>='2012-09-01'
Group by m.surname, m.firstname, m.memid
Order by m.memid;

/* Produce a list of member names, with each row containing the total member count. 
Order by join date, and include guest members.*/
Select count(*) over(), firstname, surname
From cd.members
Order by joindate;

/* Window function example
select count(*) over(partition by date_trunc('month',joindate) order by joindate),
	firstname, surname
	from cd.members
order by joindate
--
select count(*) over(partition by date_trunc('month',joindate) order by joindate asc), 
	count(*) over(partition by date_trunc('month',joindate) order by joindate desc), 
	firstname, surname
	from cd.members
order by joindate */

/* Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. 
Remember that member IDs are not guaranteed to be sequential.*/
Select row_number() over(Order by joindate), firstname, surname
From cd.members;

/* Output the facility id that has the highest number of slots booked. 
Ensure that in the event of a tie, all tieing results get output.*/
Select facid, total
From (
	Select 
		facid, 
		sum(slots) total, 
		rank() over(Order by sum(slots) desc) rank
    From cd.bookings
	Group by facid
	) as r
Where rank=1;

--
Select facid, total 
From (
	Select 
		facid, 
		total, 
		rank() over(Order by total desc) rank 
	From (
		Select facid, sum(slots) total
		From cd.bookings
		Group by facid
		) as s
	) as r
Where rank = 1;

/* Produce a list of members (including guests), along with the number of hours they've booked in facilities, rounded to the nearest ten hours. 
Rank them by this rounded figure, producing output of first name, surname, rounded hours, rank. Sort by rank, surname, and first name.*/
Select 
	m.firstname, 
	m.surname, 
	Round(Cast(sum(b.slots)/2 as decimal(10,1)), -1) as hours,
	rank() over(order by ((sum(b.slots)+10)/20)*10 desc) as rank
From cd.bookings b
Join cd.members m on m.memid=b.memid
Group by m.memid
Order by rank, surname, firstname;
--
Select 
	m.firstname, 
	m.surname,
	((Sum(b.slots)+10)/20)*10 as hours,
	rank() over (order by ((Sum(b.slots)+10)/20)*10 desc) as rank
From cd.bookings b
Join cd.members m on b.memid = m.memid
Group by m.memid
Order by rank, m.surname, m.firstname;  

/* Produce a list of the top three revenue generating facilities (including ties). 
Output facility name and rank, sorted by rank and facility name.*/
Select name, rank 
From (
	Select f.name, 
		rank() over(Order by sum(
						Case
							When b.memid=0 
							Then b.slots*f.guestcost
							Else b.slots*f.membercost
						End) desc) as rank
	From cd.bookings b
	Join cd.facilities f on b.facid=f.facid
	Group by f.name
	) as sub
Where rank<=3
Order by rank;

/* Classify facilities into equally sized groups of high, average, and low based on their revenue. 
Order by classification and facility name.*/
Select 
	name, 
	Case 
		When class=1 then 'high'
		When class=2 then 'average'
		Else 'low'
	End as revenue
From (
	Select 
  		f.name, 
  		ntile(3) over(Order by sum(
	  				Case
						When b.memid=0 
	  					Then b.slots*f.guestcost
						Else b.slots*f.membercost
					End) desc) as class
	From cd.bookings b
Join cd.facilities f on b.facid=f.facid
Group by f.name
	) as sub
Order by class, name;

/*Based on the 3 complete months of data so far, calculate the amount of time each facility will take to repay its cost of ownership. 
Remember to take into account ongoing monthly maintenance. Output facility name and payback time in months, order by facility name. 
Don't worry about differences in month lengths, we're only looking for a rough value here!*/
Select 	f.name,
		f.initialoutlay/((sum(
						case
							When b.memid=0 
							Then b.slots*f.guestcost
							Else b.slots*f.membercost
						end)/3)-f.monthlymaintenance) as months
From cd.bookings b
Join cd.facilities f on b.facid = f.facid
Group by f.facid
Order by name; 

/* For each day in August 2012, calculate a rolling average of total revenue over the previous 15 days. 
Output should contain date and revenue columns, sorted by the date. 
Remember to account for the possibility of a day having zero revenue. 
This one's a bit tough, so don't be afraid to check out the hint!*/
Select gen.date,
	(
	Select sum(
			Case
				When b.memid=0 
				Then b.slots*f.guestcost
				Else b.slots*f.membercost
			End) as rev
	From cd.bookings b
	Join cd.facilities f on b.facid=f.facid
	Where b.starttime>gen.date-interval '14 days'
		and b.starttime<gen.date+interval '1 day'
	)/15 as revenue
From
	(
	Select 	
		Cast(generate_series(timestamp '2012-08-01',
			'2012-08-31','1 day') as date) as date
	)  as gen
Order by gen.date;

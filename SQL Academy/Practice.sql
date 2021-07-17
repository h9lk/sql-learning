
-- Exercise № 1 
SELECT name 
FROM Passenger;

-- Exercise № 2 
SELECT name 
FROM Company;

-- Exercise № 3 
SELECT * 
FROM Trip 
WHERE town_from='Moscow';

-- Exercise № 4 
SELECT name 
FROM Passenger 
WHERE name LIKE '%man';

-- Exercise № 5 
SELECT COUNT(*) AS `count` 
FROM Trip 
WHERE plane='TU-134';

-- Exercise № 6 
SELECT DISTINCT name 
FROM Company, Trip 
WHERE company.id = trip.company and plane = 'Boeing';

-- Exercise № 7
SELECT DISTINCT plane 
FROM Trip 
WHERE town_to='Moscow';

-- Exercise № 8
SELECT town_to, TIMEDIFF(time_in, time_out) AS 'flight_time' 
FROM Trip 
WHERE town_from='Paris';

-- Exercise № 9
SELECT name 
From Company, Trip 
WHERE company.id=trip.company AND town_from='Vladivostok';

-- Exercise № 10
SELECT * 
FROM Trip
WHERE time_out BETWEEN "1900-01-01T10:00:00.000Z" 
AND "1900-01-01T14:00:00.000Z";

-- Exercise № 11
SELECT name
FROM  Passenger
ORDER BY LENGTH(name) DESC LIMIT 1;

-- Exercise № 12
SELECT trip, COUNT(passenger) AS count 
FROM  Pass_in_trip
GROUP BY trip;

-- Exercise № 13
SELECT name 
FROM Passenger
GROUP BY name 
HAVING COUNT(name)>1;

-- Exercise № 14
SELECT t.town_to
FROM Trip AS t 
JOIN Pass_in_trip AS pt ON pt.trip=t.id
JOIN Passenger AS p ON p.id=pt.passenger 
AND p.name='Bruce Willis'
GROUP BY t.town_to

-- Exercise № 15
SELECT DISTINCT Trip.time_in
FROM Trip, Passenger
WHERE Passenger.name='Steve Martin' AND town_to='London'
GROUP BY time_in LIMIT 1

-- Exercise № 16
SELECT p.name, COUNT(pt.trip) AS count
FROM Passenger AS p
JOIN Pass_in_trip AS pt ON pt.passenger=p.id 
GROUP BY p.name HAVING count>0
ORDER BY count DESC, p.name ASC;

-- Exercise № 17
SELECT fm.member_name, fm.status, SUM(p.amount*p.unit_price) as costs
FROM FamilyMembers AS fm
JOIN Payments AS p ON p.family_member=fm.member_id
WHERE YEAR(p.date) = 2005
GROUP BY fm.member_id, fm.member_name, fm.status;

-- Exercise № 18
SELECT member_name 
FROM FamilyMembers
WHERE birthday = (SELECT MIN(birthday) FROM FamilyMembers);

-- Exercise № 19
SELECT fm.status
FROM FamilyMembers AS fm
JOIN Payments AS p ON p.family_member=fm.member_id 
JOIN Goods AS g ON g.good_id=p.good 
WHERE g.good_name='potato'
GROUP BY fm.status;

-- Exercise № 20
SELECT fm.status, fm.member_name, SUM(p.amount*p.unit_price) AS costs
FROM FamilyMembers AS fm
JOIN Payments AS p ON p.family_member=fm.member_id
JOIN Goods AS g ON g.good_id=p.good
JOIN GoodTypes AS gt ON gt.good_type_id=g.type 
WHERE gt.good_type_name='entertainment'
GROUP BY fm.status, fm.member_name
ORDER BY costs

-- Exercise № 21
SELECT g.good_name 
FROM Goods AS g
JOIN Payments AS p ON p.good=g.good_id
GROUP BY g.good_name
HAVING COUNT(g.good_name)>1;

-- Exercise № 22
SELECT fm.member_name
FROM FamilyMembers AS fm
WHERE fm.status='mother';

-- Exercise № 23
SELECT g.good_name, p.unit_price
FROM Payments AS p
JOIN Goods AS g ON g.good_id=p.good
JOIN GoodTypes AS gt ON gt.good_type_id=g.type 
WHERE gt.good_type_name='delicacies'
GROUP BY g.good_name, p.unit_price
ORDER BY p.unit_price DESC LIMIT 1;
//-----
SELECT good_name, unit_price
FROM Payments, Goods, GoodTypes
WHERE good_type_id=type
    AND good_type_name='delicacies'
    AND good_id=good
    AND unit_price=
    (SELECT MAX(unit_price)
    FROM Payments, Goods, GoodTypes
    WHERE good_id=good
        AND good_type_id=type
        AND good_type_name='delicacies');

-- Exercise № 24
SELECT fm.member_name, SUM(p.amount*p.unit_price) as costs
FROM FamilyMembers AS fm
JOIN Payments AS p ON p.family_member=fm.member_id
WHERE Year(p.date)=2005 AND MONTH(p.date)=6
GROUP BY fm.member_name

-- Exercise № 25
SELECT g.good_name 
FROM Goods AS g                                                        
LEFT JOIN Payments AS p ON g.good_id=p.good AND YEAR(p.date)=2005 
WHERE p.good IS NULL
GROUP BY g.good_id
//-----
SELECT g.good_name FROM Goods AS g
WHERE NOT EXISTS 
	(SELECT good FROM Payments AS p
	WHERE p.good=g.good_id AND YEAR(p.date)='2005');

-- Exercise № 26
SELECT gt.good_type_name
FROM GoodTypes AS gt
WHERE gt.good_type_id NOT IN 
	(SELECT gt.good_type_id
	FROM Goods AS g
	JOIN GoodTypes AS gt ON gt.good_type_id=g.type
	JOIN Payments AS p ON g.good_id=p.good AND YEAR(p.date)=2005);

-- Exercise № 27
SELECT gt.good_type_name, SUM(p.amount*p.unit_price) as costs
FROM GoodTypes AS gt
JOIN Goods AS g ON gt.good_type_id=g.type
JOIN Payments AS p ON p.good=g.good_id
WHERE YEAR(p.date)=2005
GROUP BY gt.good_type_name;

-- Exercise № 28
SELECT  COUNT(*) AS count 
FROM Trip
WHERE town_from='Rostov' AND town_to='Moscow';

-- Exercise № 29
SELECT p.name
FROM Passenger AS p
WHERE p.id IN 
(SELECT p.id
FROM Passenger AS p
JOIN Pass_in_trip AS pt ON p.id=pt.passenger
JOIN Trip AS t ON t.id=pt.trip 
WHERE t.town_to='Moscow' AND t.plane='TU-134')

-- Exercise № 30
SELECT pt.trip, COUNT(pt.passenger) AS count 
FROM Pass_in_trip AS pt
GROUP BY pt.trip
ORDER BY count DESC

-- Exercise № 31
SELECT *
FROM FamilyMembers
WHERE member_name LIKE '%Quincey'

-- Exercise № 32
SELECT FLOOR(AVG((YEAR(CURRENT_DATE)-YEAR(birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(birthday,5)))) AS age
FROM FamilyMembers

-- Exercise № 33
SELECT AVG(p.unit_price) as cost
FROM Payments AS p
JOIN Goods AS g On g.good_id=p.good
WHERE g.good_name LIKE '%caviar'

-- Exercise № 34
SELECT COUNT(c.name) as count 
FROM Class AS c
WHERE c.name LIKE '10%';

-- Exercise № 35
SELECT COUNT(s.class) as count 
FROM Schedule AS s 
WHERE s.id IN 
	(SELECT s.id
	FROM Class AS c
	JOIN Student_in_class AS sc ON sc.class=c.id
	JOIN Schedule AS s ON s.class=c.id
	WHERE s.date LIKE '2019-09-02%');

-- Exercise № 36
SELECT *
FROM Student
WHERE student.address like 'ul. Pushkina%';

-- Exercise № 37
SELECT Min((YEAR(CURRENT_DATE)-YEAR(birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(birthday,5))) AS year
FROM Student

-- Exercise № 38
SELECT COUNT(s.first_name) as count
FROM Student AS s 
WHERE s.first_name='Anna';

-- Exercise № 39
SELECT COUNT(sc.student) as count
FROM Student_in_class AS sc 
JOIN Class AS c ON c.id=sc.class And name='10 B'
GROUP BY c.id;

-- Exercise № 40
SELECT sub.name as subjects
FROM Subject AS sub 
JOIN Schedule AS s ON s.subject=sub.id
JOIN Teacher AS t ON t.id=s.teacher
WHERE t.last_name LIKE 'Romashkin'

-- Exercise № 41
SELECT tp.start_pair
FROM Timepair AS tp
ORDER BY tp.start_pair
LIMIT 3, 1;

-- Exercise № 42
SELECT TIMEDIFF(
    (SELECT end_pair
    FROM Timepair
    WHERE id=4),
        (SELECT start_pair
        FROM Timepair
        WHERE id=2)) AS time

-- Exercise № 43
SELECT t.last_name
FROM  Teacher as t
JOIN Schedule AS s ON s.teacher=t.id
JOIN Subject AS sub ON sub.id=s.subject
WHERE sub.name LIKE 'Physical Culture'
ORDER BY t.last_name

-- Exercise № 46
SELECT c.name 
FROM Class AS c 
WHERE c.id IN 
    (SELECT c.id
    FROM Class AS c
    JOIN Schedule AS s ON s.class=c.id
    JOIN Teacher AS t ON t.id=s.teacher
    WHERE t.last_name LIKE 'Krauze')

-- Exercise № 47
SELECT COUNT(s.number_pair) as count
FROM Schedule AS s
JOIN Teacher AS t ON t.id=s.teacher
WHERE t.last_name='Krauze' AND s.date Like '2019-08-30'

-- Exercise № 48
SELECT c.name, COUNT(sc.class) AS count
FROM Class AS c
JOIN Student_in_class AS sc ON sc.class=c.id 
GROUP BY c.name, sc.class
ORDER BY count DESC

-- Exercise № 49	
SELECT
    (SELECT COUNT(*)
    FROM Student_in_class
    JOIN Class
        ON class=Class.id
    WHERE Class.name='10 A') /
    (SELECT COUNT(*)
    FROM Student_in_class) * 100 AS percent

-- Exercise № 50	
SELECT
    FLOOR((SELECT COUNT(*)
    FROM Student AS s
    JOIN Student_in_class AS sc ON s.id=sc.student
    WHERE YEAR(s.birthday)=2000) /
    (SELECT COUNT(*)
    FROM Student) * 100) AS percent

-- Exercise № 51
INSERT INTO Goods 
SELECT COUNT(*) + 1, 'Cheese', 2 FROM Goods

-- Exercise № 52
INSERT INTO GoodTypes 
SELECT COUNT(*) + 1, 'auto' FROM GoodTypes

-- Exercise № 53
UPDATE FamilyMembers
SET member_name = "Andie Anthony"
WHERE member_name = "Andie Quincey"

-- Exercise № 54
DELETE FROM FamilyMembers
WHERE member_name LIKE '%Quincey'

-- Exercise № 56
DELETE FROM Trip
WHERE Trip.town_from='Moscow'

-- Exercise № 57
UPDATE Timepair
SET start_pair=(start_pair+INTERVAL 30 MINUTE),
	end_pair=(end_pair+INTERVAL 30 MINUTE)
//-----
UPDATE Timepair
SET start_pair=ADDTIME(start_pair,
        '00:30:00'), end_pair=ADDTIME(end_pair, '00:30:00')

-- Exercise № 59
SELECT *
FROM Users
WHERE phone_number LIKE '+375%'

-- Exercise № 65
SELECT res.room_id, FLOOR(AVG(rev.rating)) AS rating
FROM Reservations AS res
JOIN Reviews AS rev ON res.id=rev.reservation_id
GROUP BY res.room_id
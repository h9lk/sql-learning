-- Only MS SQL

-- Revising the Select Query I
Select *
From city
Where population>100000 and countrycode='USA';

-- Revising the Select Query II
Select name
From city
Where population>120000 and countrycode='USA';

-- Select All
Select * 
From city;

-- Select By ID
Select *
From city
Where id=1661;

-- Japanese Cities' Attributes
Select *
From city
Where countrycode='JPN';

-- Japanese Cities' Names
Select name
From city
Where countrycode='JPN';

-- Weather Observation Station 1
Select city, state
From station;

-- Weather Observation Station 2
SELECT 
        CAST(round(sum(lat_n),2) as decimal (10,2)), 
        CAST(round(sum(long_w),2) as decimal (10,2)) 
FROM station;

-- Weather Observation Station 3
Select Distinct city
From station
Where id % 2 = 0;

-- Weather Observation Station 4
Select (count(*) - count(Distinct city)) as number
From station;

Select top(1) city, len(city) as l
From station
Order by l, city;

-- Weather Observation Station 5
Select top(1) city, len(city) as l
From station
Order by l desc, city desc;

-- Weather Observation Station 6
Select city
From station
Where city like '[aeiou]%';

-- Weather Observation Station 7
Select distinct city
From station
Where city like '%[aeiou]';

-- Weather Observation Station 8
Select distinct city
From station
Where city like '[aeiou]%' and city like '%[aeiou]';

-- Weather Observation Station 9
Select Distinct city
From station
Where city not like '[aeiou]%';

-- Weather Observation Station 10
Select Distinct city
From station
Where city not like '%[aeoiu]';

-- Weather Observation Station 11
Select distinct city 
From station
Where city not like '[aeiou]%' or city not like '%[aeiou]';

-- Weather Observation Station 12
Select distinct city
From station
Where city not like '[aeiou]%' and city not like '%[aeiou]';

-- Weather Observation Station 13
Select
    Cast(Sum(lat_n) as decimal(10,4))
From station
Where lat_n>38.7880 and lat_n<137.2345;

-- Weather Observation Station 14
Select
    Cast(Max(lat_n) as decimal(10,4))
From station
Where lat_n<137.2345;

-- Weather Observation Station 15
Select 
    Cast(long_w as decimal(10,4))
From station
Where lat_n in (Select max(lat_n) 
                From station 
                Where lat_n<137.2345);

-- Weather Observation Station 16
Select Top(1) cast(lat_n as decimal (10,4))
From station
Where lat_n>38.7780
Order by lat_n;

-- Weather Observation Station 17
Select cast(long_w as decimal (10, 4))
From station
Where lat_n in (Select top(1) lat_n
               From station
               Where lat_n>38.7780
               Order by lat_n);

-- Weather Observation Station 18
Select 
    Cast(max(lat_n)-min(lat_n)+max(long_w)-min(long_w) as decimal (10,4))
From Station;

-- Weather Observation Station 19
Select 
    Cast(sqrt(power(min(lat_n)-max(lat_n),2) + power(min(long_w)-max(long_w),2)) as decimal (10,4))
From station;

-- Weather Observation Station 20
Select Cast(lat_n as decimal(10,4)) 
From
    (Select lat_n, row_number() over (order by lat_n desc) as r1 
     From station) as a
Where r1 = 
    (Select 
        Case 
            When Max(r2)%2=0 
                Then Max(r2)/2
                Else Max(r2)/2+1 
        End 
    From 
        (Select row_number() over (order by lat_n desc) as r2 
         From station) as b);

-- Higher Than 75 Marks        
Select name 
From students
Where marks > 75
Order by RIGHT(name, 3), id;

-- Employee Names
Select name
From employee
Order by name;

-- Employee Salaries
Select name
From employee
where salary>2000 and months<10
Order by employee_id;

-- Type of Triangle
Select
    Case 
        When a+b>c and a+c>b and b+c>a Then 
                Case
                    When a= b and b=c Then 'Equilateral' 
                    When a=b or b=c or a=c Then 'Isosceles' 
                    When a<>b or b<>c or a<>c Then 'Scalene' 
                End 
        Else 'Not A Triangle' 
    End 
From triangles;

-- The PADS
Select 
    Concat(name, '(', left(occupation, 1), ')')
From occupations
Order by name;

Select 
    Concat('There are a total of', ' ',count(*),' ', lower(occupation), 's.') as name
From occupations
Group by occupation
Order by count(*);

-- Occupations
Select min(Doctor), min(Professor), min(Singer), min(Actor)
From
(
    Select row_number() over(partition by Occupation order by name) as a,
    
    Case 
        When OCCUPATION = "Doctor" Then name 
    End as Doctor,
    Case 
        when OCCUPATION = "Professor" Then name 
    End as Professor,
    Case 
        when OCCUPATION = "Actor" Then name 
    End as Actor,
    Case 
        when OCCUPATION = "Singer" Then name 
    End as Singer
    
    From occupations
) as b
Group by b.a
Order by b.a;

-- Revising Aggregations - The Count Function
Select count(name)
From city
Where population>100000;

-- Revising Aggregations - The Sum Function
Select sum(population)
From city
Where district='California';

-- Revising Aggregations - Averages
Select avg(population)
From city
where district='California';

-- Average Population
Select round(avg(population),0)
From city;

-- Japan Population
Select sum(population)
From city
Where countrycode ='JPN';

-- Population Density Difference
Select (max(population)-min(population))
From city;

-- The Blunder
Select
    Cast(Ceiling((Avg(Cast(salary AS Float)) - 
                  Avg(Cast(Replace(salary, 0, '')AS Float)))) AS INT)
From employees;

-- Top Earners
Select max(months*salary), count(months*salary)
From employee
Where employee_id in 
    (Select employee_id 
    From employee 
    Where months*salary in 
        (Select Max(months*salary) 
        From employee));

-- Population Census
Select sum(ct.population)
From city ct
Join country cn on cn.Code=ct.CountryCode 
Where cn.continent = 'Asia';

-- African Cities
Select city.name
From city
Join country on country.Code=city.CountryCode
Where continent='Africa';

-- Average Population of Each Continent
Select cn.Continent, floor(avg(ct.Population))
From city ct
Join country cn on cn.Code=ct.CountryCode 
Group by cn.Continent;

-- The Report
Select
    Case
        When g.Grade >= 8 Then s.Name
        When g.Grade<8 Then Null
    End, g.Grade, s.Marks 
From Students as s
Join Grades as g on s.Marks Between g.Min_Mark and g.Max_Mark
Order by g.Grade desc, s.Name;

-- Top Competitors
Select h.hacker_id, h.name 
From hackers as h
    Join submissions as s on h.hacker_id=s.hacker_id 
    Join challenges as c on c.challenge_id=s.challenge_id
    Join difficulty as d on c.difficulty_level=d.difficulty_level
Where s.score=d.score
Group by h.hacker_id,h.name 
Having count(h.hacker_id)>1
Order by count(c.challenge_id) desc, h.hacker_id;
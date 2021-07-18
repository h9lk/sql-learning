-- SQL Lesson 1: Select queries 101 
-- Find the title of each film
Select title From movies;

-- Find the director of each film 
Select director From movies;

-- Find the title and director of each film 
Select title, director From movies;

-- Find the title and year of each film
Select title, year From movies;

-- Find all the information about each film 
Select * From movies;

-- SQL Lesson 2: Queries with constraints (Pt. 1) 
-- Find the movie with a row id of 6
Select *
From movies
Where id=6;

-- Find the movies released in the years Between 2000 and 2010
Select *
From movies
Where year Between 2000 and 2010;

-- Find the movies not released in the years Between 2000 and 2010
Select *
From movies
Where not year Between 2000 and 2010;

-- Find the first 5 Pixar movies and their release year 
Select *
From movies
Limit 5;

-- SQL Lesson 3: Queries with constraints (Pt. 2)
-- Find all the Toy Story movies
Select * 
From movies
Where title like 'Toy%';

-- Find all the movies directed by John Lasseter 
Select * 
From movies
Where director='John Lasseter';

-- Find all the movies (and director) not directed by John Lasseter 
Select * 
From movies
Where not director='John Lasseter';

-- Find all the WALL-* movies
Select * 
From movies
Where title like 'WALL%';

-- SQL Lesson 4: Filtering and sorting Query results
-- List all directors of Pixar movies (alphabetically), without duplicates 
Select Distinct director 
From movies
Order by director;

-- List the last four Pixar movies released (ordered From most recent to least)
Select *
From movies
Order by year desc
Limit 4;

-- List the first five Pixar movies sorted alphabetically 
Select *
From movies
Order by title
Limit 5;

-- List the next five Pixar movies sorted alphabetically
Select *
From movies
Order by title
Limit 5, 5;

-- SQL Review: Simple Select Queries
-- List all the Canadian cities and their populations 
Select * 
From north_american_cities
Where country='Canada';

-- Order all the cities in the United States by their latitude From north to south 
Select * 
From north_american_cities
Where country='United States'
Order by latitude desc;

-- List all the cities west of Chicago, ordered From west to east 
Select city
From north_american_cities
Where longitude < -87.629798
Order by longitude;

-- List the two largest cities in Mexico (by population) 
Select city
From north_american_cities
Where country='Mexico'
Order by population desc
Limit 2;

-- List the third and fourth largest cities (by population) in the United States and their population
Select city
From north_american_cities
Where country='United States'
Order by population desc
Limit 2,2;

-- SQL Lesson 6: Multi-table queries with JOINs 
-- Find the domestic and international sales for each movie
Select * 
From movies
Join boxoffice on movies.id=boxoffice.movie_id;

-- Show the sales numbers for each movie that did better internationally rather than domestically 
Select * 
From movies
Join boxoffice on movies.id=boxoffice.movie_id
Where international_sales>domestic_sales;

-- List all the movies by their ratings in descending order 
Select * 
From movies
Join boxoffice on movies.id=boxoffice.movie_id
Order by rating desc;

-- SQL Lesson 7: OUTER JOINs 
-- Find the list of all buildings that have employees 
Select Distinct building
From employees;

-- Find the list of all buildings and their capacity 
Select Distinct building_name, capacity
From buildings;

-- List all buildings and the distinct employee roles in each building (including empty buildings) 
Select Distinct b.building_name, e.role
From buildings b
Left Join employees e
    on b.building_name=e.building;

--SQL Lesson 8: A short note on NULLs 
-- Find the name and role of all employees who have not been assigned to a building
Select name, role 
From employees 
Where building is Null;

-- Find the names of the buildings that hold no employees 
Select b.building_name 
From buildings b
Left Join employees e
    on b.building_name = e.building
Where e.building is Null;

-- SQL Lesson 9: Queries with expressions 
-- List all movies and their combined sales in millions of dollars
Select m.title, 
(b.domestic_sales+b.international_sales)/1000000 as sales
From movies m
Join boxoffice b on b.movie_id=m.id;

-- List all movies and their ratings in percent
Select m.title, 
(b.rating*10) as percent
From movies m
Join boxoffice b on b.movie_id=m.id;

-- List all movies that were released on even number years 
Select title
From movies
Where year%2=0;
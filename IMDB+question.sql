USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) FROM director_mapping;
-- 3867 RECORDS
SELECT COUNT(*) FROM genre;
-- 14662 RECORDS
SELECT COUNT(*) FROM movie;
-- 7997 RECORDS
SELECT COUNT(*) FROM names;
-- 25735 RECORDS
SELECT COUNT(*) FROM ratings;
-- 7997 RECORDS
SELECT COUNT(*) FROM role_mapping;
-- 15615 RECORDS

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_cnt,
       SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_cnt,
       Sum(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_cnt,
       Sum(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_cnt,
       Sum(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_cnt,
       Sum(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_cnt,
       Sum(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null_cnt,
       Sum(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_cnt,
       Sum(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_cnt
FROM   movie; 

-- columns in the movie table having null values are 
-- country, worlwide_gross_income,languages, production_company

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? 
-- How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- SELECT * FROM movie limit 4;

-- Year wise Number of movies released
SELECT year,
       COUNT(title) AS number_of_movies
FROM   movie
GROUP  BY year
order by year;

-- Month wise Number of movies released 
SELECT Month(date_published) AS month_num,
       COUNT(*) AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 
-- The highest number of movies was produced in the year 2017.
-- The highest number of movies is produced in the month of March is 824

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(DISTINCT id) AS number_of_movies
FROM   movie
WHERE  year = 2019 AND 
		( UPPER(country) LIKE '%INDIA%' OR UPPER(country) LIKE '%USA%' ); 
-- 1059 movies were produced in the USA or India in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre;
-- There are 13 Genres in dataset

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre,COUNT(movie_id) AS number_of_movies
FROM genre  
GROUP BY genre
ORDER BY number_of_movies DESC ;
-- Drama is the genre having the highest number of movies produced overall.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH movies_only_one_genre AS 
(
	SELECT movie_id
	FROM genre
	GROUP BY movie_id
	HAVING COUNT(DISTINCT genre) = 1
)
SELECT COUNT(*) AS movies_only_one_genre
FROM movies_only_one_genre; 
-- A total of 3289 movies can be categorized as belonging to only one genre.

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, ROUND(AVG(duration),2) AS avg_duration
FROM movie m
INNER JOIN genre g ON m.id=g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;
-- 'Action' movies have the longest average duration of 112.99 minutes, 
-- whereas 'Horror' movies have the shortest average duration of 92.72 minutes.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres 
-- in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_count_summary AS 
(
SELECT genre, 
	   COUNT(movie_id) as movie_count,
	   RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre
)
SELECT genre, movie_count,genre_rank
FROM genre_count_summary
WHERE genre='Thriller';
-- The rank of the ‘thriller’ genre of movies is 3rd among all the genres in 
-- terms of number of movies produced

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT MIN(avg_rating) AS min_avg_rating,
       MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes,
       MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS min_median_rating
FROM ratings; 

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT title, avg_rating,
		RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM ratings r
INNER JOIN movie m ON m.id = r.movie_id 
LIMIT 10;
-- favourite movie 'Kirket,'Love in Kilnerry' in the top 10 movies with an highest average rating of 10.0?
-- 'Shibu' an average rating in the top 10 movies with an highest average rating of 9.4.

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC; 
-- Movies with a median rating of 7 are highest with 2257 movie count 
-- whereas movies with a median rating of 1 are lowest in number with 94 movie count.

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_company_AvgRating_gt8_summary AS 
(
SELECT production_company,
	   COUNT(movie_id) AS movie_count,
       RANK() OVER(ORDER BY COUNT(movie_id) DESC ) AS prod_company_rank
FROM ratings r
INNER JOIN movie m ON m.id = r.movie_id
WHERE avg_rating > 8 AND     
	  production_company IS NOT NULL
GROUP  BY production_company
)
SELECT production_company, movie_count, prod_company_rank
FROM   prod_company_AvgRating_gt8_summary
WHERE  prod_company_rank = 1; 
-- Production companies 'Dream Warrior Pictures' and 'National Theatre Live' has produced the most number of hit movies (average rating > 8)

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:
+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       COUNT(M.id) AS MOVIE_COUNT
FROM   movie m
INNER JOIN genre g ON g.movie_id = m.id
INNER JOIN ratings r ON R.movie_id = M.id
WHERE  year = 2017
       AND MONTH(date_published) = 3  -- March Month
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC; 
-- 'Drama' is the top genre with 24 number of movies & 
-- 'Family' is in the lowest position with above condition

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT  title, avg_rating, genre
FROM movie m
INNER JOIN genre g ON g.movie_id = m.id
INNER JOIN ratings r ON r.movie_id = m.id
WHERE title LIKE 'THE%' AND 
      avg_rating > 8
ORDER BY avg_rating DESC;
-- 'The Brighton Miracle' has the highest average rating in Drama Genre 
-- while 'The King and I' has lowest avg rating among list of movies that start with the word ‘The’ having average rating > 8
-- There are total 8 movies with this criteria

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT COUNT(*) AS movie_count
FROM   movie m
INNER JOIN ratings r ON r.movie_id = m.id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01' AND 
      median_rating = 8;
-- There were 361 movies released between 1 April 2018 and 1 April 2019 having median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country, SUM(total_votes) as total_votes
FROM movie m
INNER JOIN ratings r ON m.id=r.movie_id
WHERE country = 'Germany' or country = 'Italy'
GROUP BY country;
-- In terms of the number of movies, German films outnumbered Italian films by approximately 28700+.
-- Germany	106710
-- Italy	77965

-- Answer is Yes
/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;
-- columns in the names table containing NULLS values are Height, date_of_birth, known_for_movies 

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_three_genres AS
(
SELECT genre,
       COUNT(m.id) AS movie_count,
       Rank() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM movie m
INNER JOIN genre g ON g.movie_id = m.id
INNER JOIN ratings r ON r.movie_id = m.id
WHERE avg_rating > 8
GROUP BY genre LIMIT 3 
)
SELECT n.NAME AS director_name ,
       COUNT(d.movie_id) AS movie_count
FROM director_mapping d
INNER JOIN genre g using (movie_id)
INNER JOIN names n ON n.id = d.name_id
INNER JOIN top_three_genres using (genre)
INNER JOIN ratings using (movie_id)
WHERE avg_rating > 8
GROUP BY n.NAME
ORDER BY movie_count DESC LIMIT 3 ;

-- top three genres whose movies have an average rating > 8 are 'Drama', 'Action' & 'Comedy'
-- & their directors are James Mangold , Anthony Russo & Soubin Shahir are top three directors 

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name AS actor_name,
       Count(movie_id) AS movie_count
FROM role_mapping AS r
INNER JOIN names AS n ON n.id = r.name_id
INNER JOIN movie AS m ON m.id = r.movie_id
INNER JOIN ratings AS rt USING(movie_id)
WHERE rt.median_rating >= 8
	  AND category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT  2; 
-- top two actors whose movies have a median rating >= 8 are Mammootty and Mohanlal.

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_house_ranking AS 
(
SELECT production_company, 
	   SUM(total_votes) AS vote_count,
	   RANK() OVER(ORDER BY SUM(total_votes) DESC) AS production_house_rank
FROM movie AS m
INNER JOIN ratings AS r ON r.movie_id=m.id
GROUP BY production_company
)
SELECT production_company, vote_count, production_house_rank
FROM production_house_ranking
WHERE production_house_rank<=3;
-- 'Marvel Studios','Twentieth Century Fox' and 'Warner Bros' are the top three production houses based on the number of votes received by their movies.

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. 
-- Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. 
-- If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below

with actor_summary as 
(SELECT n.name AS actor_name,
		Sum(total_votes) as total_votes,
		Count(movie_id) AS movie_count,
        Sum(avg_rating * total_votes)/Sum(total_votes) AS actor_avg_rating
 FROM role_mapping AS r
INNER JOIN names AS n ON n.id = r.name_id
INNER JOIN movie AS m ON m.id = r.movie_id
INNER JOIN ratings AS rt USING(movie_id)
WHERE upper(m.country)='INDIA' AND 
	  category = 'actor'
GROUP BY actor_name
having movie_count>=5
)
select actor_name, total_votes,movie_count,round(actor_avg_rating,2) as actor_avg_rating,
	   rank() over (order by actor_avg_rating desc,total_votes desc) actor_rank
from actor_summary;

-- Top actor is Vijay Sethupathi followed by Fahadh Faasil & Yogi Babu, based on the average ratings of movies released in India.

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. 
-- If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with actor_summary as 
(SELECT n.name AS actor_name,
		Sum(total_votes) as total_votes,
		Count(movie_id) AS movie_count,
        Sum(avg_rating * total_votes)/Sum(total_votes) AS actor_avg_rating
 FROM role_mapping AS r
INNER JOIN names AS n ON n.id = r.name_id
INNER JOIN movie AS m ON m.id = r.movie_id
INNER JOIN ratings AS rt USING(movie_id)
WHERE upper(m.country)='INDIA' AND 
	  category = 'actress' AND
      upper(languages) like '%HINDI%'
GROUP BY actor_name
having movie_count>=3
)
select actor_name, total_votes,movie_count,round(actor_avg_rating,2) as actor_avg_rating,
	   rank() over (order by actor_avg_rating desc,total_votes desc) actor_rank
from actor_summary;

-- Top five actresses that have acted in at least three Indian movies based on their average ratings are 
-- Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor & Kriti Kharbanda

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title, avg_rating,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         WHEN avg_rating < 5 THEN 'Flop movies'
       END AS avg_rating_category
FROM   genre g 
INNER JOIN movie m on g.movie_id = m.id
INNER JOIN ratings AS r using (movie_id)
WHERE  UPPER(genre) LIKE '%THRILLER%'
order by 3,2;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- DOUBT
SELECT genre, 
	   AVG(m.duration) as avg_duration,
        SUM(ROUND(AVG(m.duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(m.duration),2)) OVER(ORDER BY genre ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg_duration
FROM   genre g 
INNER JOIN movie m on g.movie_id = m.id
group by genre;

-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.
-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Top 3 Genres based on most number of movies

WITH top_3_genres AS
(
SELECT genre, 
	   -- COUNT(movie_id) as movie_count,
	   RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre limit 3 
),
movie_std AS (
SELECT genre,
	   year,
	   m.title AS movie_name,
       m.worlwide_gross_income,
       CAST(case when m.worlwide_gross_income LIKE '%INR%' then REPLACE(m.worlwide_gross_income,'INR','')*0.012   -- converting INR into $
             when m.worlwide_gross_income LIKE '%$%' then replace(m.worlwide_gross_income,'$','') 
             when m.worlwide_gross_income is NULL then 0 END AS decimal(10)) AS worlwide_gross_income_std
FROM movie m
INNER JOIN genre g ON m.id = g.movie_id
WHERE genre IN ( SELECT genre FROM top_3_genres)
),
movie_rank AS (
SELECT genre,year,movie_name,worlwide_gross_income,worlwide_gross_income_std,
	   DENSE_RANK() OVER (PARTITION BY year ORDER BY worlwide_gross_income_std desc ) AS rnk
	   from movie_std
)
select genre,year,movie_name,worlwide_gross_income,rnk
from movie_rank
where rnk<=5
ORDER BY YEAR,rnk;
-- The top movies are 'The Fate of the Furious'(2017),'Bohemian Rhapsody'(2018) & 'Avengers: Endgame'(2019).

-- Finally, let’s find out the names of the top two production houses that have produced the highest 
-- number of hits among multilingual movies.

-- Q27.  Which are the top two production houses that have produced the highest number of hits 
-- (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
	  COUNT(*) AS movie_count,
      RANK() OVER(ORDER BY COUNT(*) DESC) AS prod_comp_rank
FROM   movie m
inner join ratings r ON r.movie_id = m.id
WHERE  production_company IS NOT NULL AND 
       median_rating >= 8 AND
       languages like '%,%'  -- to check multilingual movies seperated by comma
GROUP BY production_company
LIMIT 2;

-- Top 2 production houses that have produced the highest number of hits (median rating >= 8) 
-- among multilingual movies are 'Star Cinema' and 'Twentieth Century Fox'

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_details AS
(
SELECT n.NAME AS actress_name,
       SUM(r.total_votes) AS total_votes,
       COUNT(r.movie_id) AS movie_count,
	   ROUND(SUM(r.avg_rating*r.total_votes)/Sum(r.total_votes),2) AS actress_avg_rating
FROM movie m
INNER JOIN ratings r ON m.id=r.movie_id
INNER JOIN GENRE g ON m.id= g.movie_id 
INNER JOIN role_mapping rm ON m.id = rm.movie_id
INNER JOIN names n ON n.id= rm.name_id 
WHERE r.avg_rating>8 AND 
	  rm.category = 'ACTRESS' AND 
      g.genre = "Drama"
GROUP BY NAME 
)
SELECT actress_name, total_votes, movie_count,actress_avg_rating,
	   Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM  actress_details LIMIT 3;

-- 'Parvathy Thiruvothu', 'Susan Brown' and 'Amanda Lawrenceare' top 3 actresses based on number of 
-- Super Hit movies (average rating >8) in drama genre

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH directors_summary AS
(
SELECT d.name_id AS director_id, 
       NAME as director_name, 
       d.movie_id, 
       duration, 
       avg_rating, total_votes, m.date_published,
	   LEAD(date_published) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) AS date_published_next
FROM director_mapping d
INNER JOIN names n ON n.id = d.name_id
INNER JOIN movie m ON m.id = d.movie_id
INNER JOIN ratings r ON r.movie_id = m.id 
)
SELECT director_id,director_name,
	   COUNT(movie_id) AS number_of_movies,
	   ROUND(Avg(DATEDIFF(date_published_next, date_published)),2) AS avg_inter_movie_days,
	   ROUND(Avg(avg_rating),2) AS avg_rating,
	   SUM(total_votes) AS total_votes,
	   MIN(avg_rating) AS min_rating,
	   MAX(avg_rating) AS max_rating,
       SUM(duration) AS total_duration
FROM  directors_summary
GROUP BY director_id
ORDER BY COUNT(movie_id) DESC limit 9;





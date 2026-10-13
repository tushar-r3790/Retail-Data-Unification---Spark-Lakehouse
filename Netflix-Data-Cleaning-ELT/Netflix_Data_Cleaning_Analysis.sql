SELECT *
  FROM netflix_raw
  where show_id = 's5023';
--handled the foreign characters by changing the data type

--remove duplicates (on column show_id)
select show_id,
       COUNT(*)
 from netflix_raw
 group by show_id
 having COUNT(*) > 1; -- COUNT(*) counts all rows in a group, even if some columns contain NULL.

 --to check exact rows 
 select * 
  from netflix_raw
  where concat(upper(title), type) in      -- as for 'in clause' - there can only be 1 column hence concat
   (
     select concat(upper(title), type)
      from netflix_raw
      group by upper(title), type
      having COUNT(*) > 1
  )
  order by title;

--removing the above 3 duplicates from the whole table

with cte as (
             select *,
                    ROW_NUMBER() over(partition by title, type order by show_id) as rn
              from netflix_raw
            )
select show_id, 
       type,
       title,
       CAST(date_added as date) as date_added,
       release_year,
       rating,
       case when duration is null then rating else duration end as duration,
       description 
 from cte;


 --New table creation for columns - listed in, director, country, cast - as they 've multiple values
 select show_id,
        trim(value) as director --to remove extra spaces
 into netflix_directors -- creating a new table from the resulting output
 from netflix_raw
 cross apply string_split(director, ',') -- string_split separates the director names wherever it finds a comma.
  --cross apply -> For each row in the table, split the director value and create a separate output row 
  --for each resulting name.
  --string_split doesn't take null values 

--Similarly, for columns - country, cast & listed_in

select show_id,
       trim(value) as country 
into netflix_county
from netflix_raw
cross apply string_split(country, ',')

select show_id,
       trim(value) as cast 
into netflix_cast
from netflix_raw
cross apply string_split(cast, ',')

select show_id,
       trim(value) as genre 
into netflix_genre
from netflix_raw
cross apply string_split(listed_in, ',')

--Data type conversion for date added

--Populate missing values in country, duration columns

--assume that if a director has directed any movie in a certain country, there is a high possibility that
--another movie of his is also in the same country. So, we can populate all the available combination
--of director + country

select director,
       country
 from netflix_county nc -- contains country information
 inner join netflix_directors nd -- contains director information.
 on nc.show_id = nd.show_id
 group by country, director
 order by director; -- this is mapping m giving available combination of country & director

--matching each record in netflix_raw with the lookup table (mapping m) using the director's name
select show_id,
       m.country
from netflix_raw nr
inner join (
             select director,
                    country
             from netflix_county nc -- contains country information
             inner join netflix_directors nd -- contains director information.
             on nc.show_id = nd.show_id
             group by country, director
            ) m
on nr.director = m.director
where nr.country is null; --find records with missing country information
--once we have matching records of country we can insert it into netflix_country

insert into netflix_county
select show_id,
       m.country
from netflix_raw nr
inner join (
             select director,
                    country
             from netflix_county nc -- contains country information
             inner join netflix_directors nd -- contains director information.
             on nc.show_id = nd.show_id
             group by country, director
            ) m
on nr.director = m.director
where nr.country is null;
----------------------------------------------
select *
from netflix_raw
where duration is null;

select * from netflix;

-------------------- netflix data analysis
--Q.1> For each director, count the no. of movies and tv_shows created by them in separate columns for
--directors, who have created tv shows and movies both
select nd.director,
       count(distinct case when n.type = 'Movie' then n.show_id end) as no_of_movies, 
       count(distinct case when n.type = 'TV Show' then n.show_id end) as no_of_tvshow     
from netflix n
inner join netflix_directors nd
on n.show_id = nd.show_id
group by nd.director
having COUNT(distinct n.type) > 1;

--Q.2> Which country has highest no of only comedy movies
select top 1 nc.country,
       COUNT(distinct ng.show_id) as no_of_movies
from netflix_county nc --since we want country
inner join netflix_genre ng
on nc.show_id = ng.show_id
inner join netflix n  -- as we need only 'type' as Movie
on nc.show_id = n.show_id
where ng.genre = 'Comedies' and n.type = 'Movie'
group by nc.country
order by no_of_movies desc;

---------------------
--Q.3> For each year(as per date added to Netflix), which director has maximum no of movies released
with cte as (
             select nd.director,
                    year(date_added) as date_year,
                    COUNT(n.show_id) as no_of_movies
             from netflix n
             inner join netflix_directors nd
             on n.show_id = nd.show_id
             where type = 'Movie'
             group by nd.director, year(date_added)
            ),
cte2 as (
          select *,
                 ROW_NUMBER() over(partition by date_year order by no_of_movies desc, director) as rn
          from cte
        )
select *
from cte2
where rn = 1;

--Q.4> What is the average duration of movies in each genre
select ng.genre,
       avg(cast(REPLACE(duration, ' min','') as int)) as avg_duration 
from netflix_genre ng
inner join netflix n
on ng.show_id = n.show_id
where type = 'Movie'
group by ng.genre;

--Q.5> Find the list of directors who have created horror and comedy movies both. Display director names
-- along with number of comedy and horror movies directed by them
select nd.director,
       count(distinct case when ng.genre='Comedies' then n.show_id end) as no_of_comedy,
       count(distinct case when ng.genre='Horror Movies' then n.show_id end) as no_of_horror
from netflix n
inner join netflix_genre ng
on n.show_id = ng.show_id
inner join netflix_directors nd
on n.show_id = nd.show_id
where genre in ('Comedies', 'Horror Movies') and type = 'Movie'
group by nd.director
having COUNT(distinct ng.genre) = 2;

select *
from netflix_genre 
where show_id in (
                   select show_id 
                   from netflix_directors 
                   where director = 'Steve Brill'
                 )
order by genre 
            

      


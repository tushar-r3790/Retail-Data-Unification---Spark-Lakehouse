select *
from enhanced_yelp_reviews
limit 10;

select *
from enhanced_yelp_businesses
limit 10;

--Q.1 Find number of businesses in each category
with cte as (
              select business_id,
                     trim(A.value) as category       
              from  enhanced_yelp_businesses,
              lateral split_to_table(categories, ',') as A
            )
select category,
       count(*) as no_of_businesses
from cte
group by category
order by no_of_businesses desc;

--SPLIT_TO_TABLE() splits a text value into separate rows using a specified delimiter
--LATERAL allows the splitting operation to use the categories value from the current business row
----------------------------------------------------------------------------------------------------

--Q.2 Find the top 10 users who have reviewed the most businesses in the "Restaurants" category.
select r.user_id,
       count(distinct r.business_id) as no_of_business
from enhanced_yelp_reviews r 
inner join enhanced_yelp_businesses b 
on r.business_id = b.business_id
where b.categories ilike '%Restaurants%'
group by 1
order by 2 desc
limit 10;

---------------------------------------------------------------------------------------------------

--Q.3 Find the most popular categories of businesses (based on the no of reviews).
with cte as (
              select business_id,
                     trim(A.value) as category       
              from  enhanced_yelp_businesses,
              lateral split_to_table(categories, ',') as A
            )
select category,
       count(*) as no_of_reviews
from cte 
inner join enhanced_yelp_reviews r
on cte.business_id = r.business_id
group by 1
order by 2 desc

--------------------------------------------------------------------------------
--Q.4 Find the top 3 most recent reviews for each business
with cte as (
              select r.*,
                     b.name,
                     row_number() over (partition by r.business_id order by review_date desc) as rn
              from enhanced_yelp_reviews r
              inner join enhanced_yelp_businesses b
              on r.business_id = b.business_id
            )
select * 
from cte 
where rn <= 3;
-----------------------------------------------------------------------------------------------------
--Q.5 Find the month with the highest no of reviews
select month(review_date) as review_month,
       count(*) as no_of_reviews
from enhanced_yelp_reviews
group by 1
order by 2 desc
-----------------------------------------------------------------------------------------

--Q.6 Find the percentage of 5-star reviews for each business
select b.business_id,
       b.name,
       count(*) as total_reviews,
       sum(case when r.review_stars = 5 then 1 else 0 end) as star5_reviews,
       (star5_reviews/total_reviews)*100 as percentage_5_star
from enhanced_yelp_reviews r
inner join enhanced_yelp_businesses b
on r.business_id = b.business_id
group by 1, 2
----------------------------------------------------------------------------------------------
--Q.7 Find the top 5 most reviewed buinesses in each city
with cte as (
              select b.city,
                     b.business_id,
                     b.name,
                     count(*) as total_reviews
              from enhanced_yelp_reviews r
              inner join enhanced_yelp_businesses b
              on r.business_id = b.business_id
              group by 1,2,3
            )
select *
from cte 
qualify row_number() over (partition by city order by total_reviews desc) <= 5;
------------------------------------------------------------------------------------------

--Q.8 Find the average rating of businesses that have at least 100 reviews.
select b.business_id,
       b.name,
       count(*) as total_reviews,
       avg(review_stars) as avg_rating
from enhanced_yelp_reviews r
inner join enhanced_yelp_businesses b
on r.business_id = b.business_id
group by 1,2
having count(*) >= 100;
-----------------------------------------------------------------------------------------------

--Q.9 List the top 10 users who have written the most reviews, along with the businesses they reviewed.
with cte as ( 
              select r.user_id,
                     b.name,
                     count(*) as total_reviews
              from enhanced_yelp_reviews r
              inner join enhanced_yelp_businesses b
              on r.business_id = b.business_id
              group by 1,2
              order by 3 desc
              limit 10
            )
select user_id,
       business_id
from enhanced_yelp_reviews
where user_id in (
                   select user_id
                   from cte
                 )
group by 1, 2                 
order by user_id;
-------------------------------------------------------------------------------------------

--Q.10 Find the top 10 businesses with highest positive sentiment reviews
select r.business_id,
       b.name,
       count(*) as total_reviews
from enhanced_yelp_reviews r
inner join enhanced_yelp_businesses b
on r.business_id = b.business_id
where sentiments = 'Positive'
group by 1,2
order by 3 desc
limit 10

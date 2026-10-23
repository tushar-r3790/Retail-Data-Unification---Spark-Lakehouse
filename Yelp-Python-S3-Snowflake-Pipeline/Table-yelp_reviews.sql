create or replace table yelp_reviews (review_text variant)

-- Load Yelp JSON data from S3 using a Snowflake storage integration.
-- Configure YELP_S3_INTEGRATION in your own Snowflake account.

COPY INTO yelp_reviews
FROM @YELP_S3_STAGE
FILE_FORMAT = (TYPE = JSON);


create or replace table enhanced_yelp_reviews as 
select review_text:business_id::string as business_id,
       review_text:date::date as review_date,
       review_text:user_id::string as user_id,
       review_text:stars::number as review_stars,
       review_text:text::string as review_text,
       analyze_sentiment(review_text) as sentiments
from yelp_reviews;
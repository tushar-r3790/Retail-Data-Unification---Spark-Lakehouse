create or replace table yelp_businesses (business_text variant)

-- Load Yelp business JSON data from S3 using a Snowflake storage integration.
-- Configure YELP_S3_INTEGRATION in your own Snowflake account.

COPY INTO yelp_businesses
FROM @YELP_S3_STAGE
FILE_FORMAT = (TYPE = JSON);

create table enhanced_yelp_businesses as 
select business_text:business_id::string as business_id,
       business_text:name::string as name,
       business_text:city::string as city,
       business_text:state::string as state,
       business_text:review_count::number as review_count,
       business_text:stars::number as stars,
       business_text:categories::string as categories
from yelp_businesses;
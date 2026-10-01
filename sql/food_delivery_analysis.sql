CREATE TABLE food_delivery (
    order_id VARCHAR(100) PRIMARY KEY,
    city_tier SMALLINT,
    customer_age INT,
    customer_loyalty_score DECIMAL(5,2),
    order_hour INT,
    order_day_of_week INT,
    order_month INT,
    delivery_distance_km DECIMAL(8,2),
    preparation_time_minutes INT,
    delivery_time_minutes INT,
    estimated_delivery_time INT,
    traffic_level_score DECIMAL(5,2),
    weather_severity_score DECIMAL(5,2),
    restaurant_rating DECIMAL(3,2),
    delivery_partner_rating DECIMAL(3,2),
    customer_rating DECIMAL(3,2),
    order_value DECIMAL(10,2),
    delivery_fee DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    tip_amount DECIMAL(10,2),
    final_amount_paid DECIMAL(10,2),
    number_of_items INT,
    cancellation_flag BOOLEAN,
    delayed_delivery_flag BOOLEAN,
    refund_flag BOOLEAN,
    promo_code_used BOOLEAN,
    premium_customer_flag BOOLEAN,
    festival_or_weekend_flag BOOLEAN,
    delivery_partner_experience_years DECIMAL(5,2),
    delivery_efficiency_score DECIMAL(5,2)
);

select * from food_delivery limit 10;
SELECT COUNT(*) AS total_rows
FROM food_delivery;


--OPERATION SECTION
--QUERY 1:which city tier has the longest delivery time;
select city_tier,avg(delivery_time_minutes) as average_delivery_time
from food_delivery group by city_tier order by average_delivery_time desc;

--QUERY 2:how does traffic affect delivery time
select floor(traffic_level_score) as traffic_level,
COUNT(*) AS total_orders,
ROUND(AVG(delivery_time_minutes), 2) AS average_delivery_time 
from food_delivery group by traffic_level order by traffic_level;

--QUERY 3:does distance increase the delivery delay
SELECT
    CASE
        WHEN delivery_distance_km < 5 THEN '0-5 km'
        WHEN delivery_distance_km < 10 THEN '5-10 km'
        WHEN delivery_distance_km < 15 THEN '10-15 km'
        ELSE '15+ km'
    END AS distance_category,

    COUNT(*) AS total_orders,

    
      ROUND(
        AVG(delivery_time_minutes - estimated_delivery_time), 2
    ) AS avg_delay_minutes

FROM food_delivery

GROUP BY distance_category

ORDER BY avg_delay_minutes DESC;
--distance vs delivery_time
SELECT
    CASE
        WHEN delivery_distance_km < 5 THEN '0-5 km'
        WHEN delivery_distance_km < 10 THEN '5-10 km'
        WHEN delivery_distance_km < 15 THEN '10-15 km'
        ELSE '15+ km'
    END AS distance_category,
    COUNT(*) AS total_orders,
    ROUND(AVG(delivery_time_minutes), 2) AS avg_delivery_time
FROM food_delivery
GROUP BY distance_category
ORDER BY avg_delivery_time;

--QUERY 4:does preparation time contribute to delays?
SELECT
    CASE
        WHEN preparation_time_minutes < 10 THEN '0-10 min'
        WHEN preparation_time_minutes < 20 THEN '10-20 min'
        WHEN preparation_time_minutes < 30 THEN '20-30 min'
        ELSE '30+ min'
    END AS preparation_category,

    COUNT(*) AS total_orders,

    ROUND(
        AVG(delivery_time_minutes - estimated_delivery_time), 2
    ) AS avg_delay_minutes

FROM food_delivery

GROUP BY preparation_category

ORDER BY avg_delay_minutes DESC;

--QUERY 5:which conditions lead to poor delivery efficiency?
SELECT
    CASE
        WHEN delivery_efficiency_score >= 90 THEN 'Excellent'
        WHEN delivery_efficiency_score < 50 THEN 'Poor'
    END AS efficiency_status,

    COUNT(*) AS total_orders,
    ROUND(AVG(delivery_distance_km), 2) AS avg_distance_km,
    ROUND(AVG(traffic_level_score), 2) AS avg_traffic_score,
    ROUND(AVG(preparation_time_minutes), 2) AS avg_preparation_time,
    ROUND(AVG(delivery_time_minutes), 2) AS avg_delivery_time

FROM food_delivery

WHERE delivery_efficiency_score >= 90
   OR delivery_efficiency_score < 50

GROUP BY efficiency_status;

select * from food_delivery limit 10;




--customers insights
--QUERY 2:do premium customer spend more time?
select 
       case 
	     when premium_customer_flag=true then 'premium'
		 else 'non premium' end as customer_premium_status,
count(*) as total_customers,
avg(final_amount_paid) as average_amount_value,
avg(order_value) as avg_order_value

from food_delivery group by customer_premium_status;

--QUERY 2:does loyality correlate with spending?
SELECT
    CASE
        WHEN customer_loyalty_score < 40 THEN 'Low Loyalty'
        WHEN customer_loyalty_score < 70 THEN 'Medium Loyalty'
        ELSE 'High Loyalty'
    END AS loyalty_category,

    COUNT(*) AS total_customers,

    ROUND(AVG(final_amount_paid), 2) AS avg_amount_paid,
    ROUND(AVG(order_value), 2) AS avg_order_value

FROM food_delivery

GROUP BY loyalty_category

ORDER BY avg_amount_paid DESC;

--OR
SELECT
    ROUND(
        CORR(customer_loyalty_score, final_amount_paid)::numeric,
        3
    ) AS loyalty_spending_correlation
FROM food_delivery;

--QUERY 3:Which age group spends the most?
select 
    case
	  when customer_age<18 then 'minor'
	  when customer_age between 18 and 35 then 'young'
	  when customer_age between 36 and 56 then 'Middle-age'
	  when customer_age>56 then 'senior'
	  else 'not in slab' end as age_slab,
SUM(final_amount_paid) AS total_revenue,
count(*) as total_orders,
avg(order_value) as avg_order_value
from food_delivery group by age_slab order by total_revenue desc;


--QUERY 4:Do discounts affect customer spending?
select 
    case 
	   when discount_amount=0 then 'no discount'
	   when discount_amount between 1 and 10 then 'small discount'
	   when discount_amount>10 and discount_amount<20 then 'medium discount'
	   else 'high discount' end as discount_status,
count(*) as total_orders,
avg(discount_amount) as avg_discount_amount,
avg(order_value) AS avg_raw_food_spend,     -- Do they add more food to the cart?
avg(final_amount_paid) AS avg_net_revenue
FROM food_delivery
GROUP BY discount_status
ORDER BY MIN(discount_amount) ASC;

--QUERY 5:What factors are associated with low customer ratings?
SELECT 
    CASE 
        WHEN customer_rating <= 2 THEN 'Low Rating'
        WHEN customer_rating > 2 AND customer_rating <= 3.5 THEN 'Average Rating'
        WHEN customer_rating > 3.5 THEN 'High Rating'
        ELSE 'No Rating Given' 
    END AS customer_rating_slab,
    COUNT(*) AS total_problematic_orders
    
FROM food_delivery 
WHERE cancellation_flag = true 
   OR delayed_delivery_flag = true 
   OR refund_flag = true 
GROUP BY customer_rating_slab
ORDER BY total_problematic_orders DESC;


--BUSINESS INSIGHTS
--QUERY 1:What is the cancellation rate? 
SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN cancellation_flag = true THEN 1 ELSE 0 END) AS total_canceled_orders,
    ROUND(
        AVG(CASE WHEN cancellation_flag = true THEN 1.0 ELSE 0.0 END) * 100, 
        2
    ) AS cancellation_rate_percentage
FROM food_delivery;

--QUERY 2:What is the refund rate?
SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN refund_flag = true THEN 1 ELSE 0 END) AS total_refund_orders,
    ROUND(
        AVG(CASE WHEN refund_flag = true THEN 1.0 ELSE 0.0 END) * 100, 
        2
    ) AS refund_percentage
FROM food_delivery;

--QUERY 3:How does weekend/festival demand differ?
SELECT 
    CASE 
        WHEN festival_or_weekend_flag = true THEN 'Weekend / Festival'
        ELSE 'Non-Weekend / Weekday'
    END AS day_type,
    COUNT(*) AS total_orders
FROM food_delivery
GROUP BY festival_or_weekend_flag;


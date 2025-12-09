create database funnelAnalysis ;

use funnelAnalysis;

CREATE TABLE users (
    visitor_id INT,
    signup_date DATE
);

CREATE TABLE events (
    visitor_id INT,
    event_timestamp DATETIME,
    event_type VARCHAR(50),
    page_url VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT,
    visitor_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);

select * from events;

select * from orders;

-- Funnel Analysis SQL Queries

-- Total unique visitors who viewed any page
SELECT COUNT(DISTINCT visitor_id) AS total_visitors
FROM events
WHERE event_type = 'page_view';

-- How many visitors signed up
SELECT COUNT(DISTINCT visitor_id) AS signup_count
FROM users
WHERE signup_date IS NOT NULL;

-- How many visitors made a purchase
-- Count unique users who made a purchase
SELECT COUNT(DISTINCT visitor_id) AS purchasers
-- From the orders table
FROM orders;

-- Full Funnel Conversion (Page View → Signup → Purchase)
-- Step 1: Find visitors who viewed any page
WITH funnel_pageview AS (
    SELECT DISTINCT visitor_id          -- unique visitors who viewed any page
    FROM events
    WHERE event_type = 'page_view'      -- only page views
),

-- Step 2: Find visitors who signed up
funnel_signup AS (
    SELECT DISTINCT visitor_id
    FROM users
    WHERE signup_date IS NOT NULL       -- must have signup date
),

-- Step 3: Find visitors who purchased
funnel_purchase AS (
    SELECT DISTINCT visitor_id
    FROM orders
)

-- Final: Show funnel numbers and conversion percentages
SELECT
    (SELECT COUNT(*) FROM funnel_pageview) AS total_visitors,      -- total viewers
    (SELECT COUNT(*) FROM funnel_signup) AS total_signups,         -- total signups
    (SELECT COUNT(*) FROM funnel_purchase) AS total_purchasers,    -- total buyers

    -- % of visitors who signed up
    ROUND(
        100 * (SELECT COUNT(*) FROM funnel_signup) 
        / (SELECT COUNT(*) FROM funnel_pageview),
    2) AS pct_pageview_to_signup,

    -- % of signups who purchased
    ROUND(
        100 * (SELECT COUNT(*) FROM funnel_purchase) 
        / (SELECT COUNT(*) FROM funnel_signup),
    2) AS pct_signup_to_purchase,

    -- Overall conversion from visitor → purchase
    ROUND(
        100 * (SELECT COUNT(*) FROM funnel_purchase) 
        / (SELECT COUNT(*) FROM funnel_pageview),
    2) AS pct_overall_conversion;

 -- Drop-off rate between page view and signup
	-- Step 1: Find all users who viewed any page
	WITH viewed AS (
    SELECT DISTINCT visitor_id
    FROM events
),

	-- Step 2: Find all users who signed up
signed AS (
    SELECT DISTINCT visitor_id
    FROM users
    WHERE signup_date IS NOT NULL
)

	-- Final step: Compare viewers vs signups to calculate drop-off
SELECT
    COUNT(viewed.visitor_id) AS total_viewed,         -- people who saw any page
    COUNT(signed.visitor_id) AS total_signed,         -- people who signed up

    -- Dropoff% = (viewers - signups) / viewers
    ROUND(
        100 * (COUNT(viewed.visitor_id) - COUNT(signed.visitor_id))
        / COUNT(viewed.visitor_id),
    2) AS dropoff_pct
FROM viewed
LEFT JOIN signed 
ON viewed.visitor_id = signed.visitor_id;            -- match viewer → signup

-- Page-wise event counts

-- Count how many times each page was viewed
SELECT 
    page_url,                      -- which page
    COUNT(*) AS views              -- how many views
FROM events
WHERE event_type = 'page_view'     -- only count page views
GROUP BY page_url                  -- group by page
ORDER BY views DESC;               -- most viewed pages first

-- Users who saw pricing page but DID NOT sign up

 -- Step 1: Find users who viewed the pricing page
WITH pricing_viewers AS (
    SELECT DISTINCT visitor_id
    FROM events
    WHERE page_url = '/pricing'
),

-- Step 2: Find users who signed up
signed_up AS (
    SELECT DISTINCT visitor_id
    FROM users
    WHERE signup_date IS NOT NULL
)

-- Step 3: Return users who viewed pricing but didn't sign up
SELECT pv.visitor_id
FROM pricing_viewers pv
LEFT JOIN signed_up su
ON pv.visitor_id = su.visitor_id
WHERE su.visitor_id IS NULL;        -- user did not sign up



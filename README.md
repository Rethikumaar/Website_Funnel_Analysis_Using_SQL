# 1\. 🛍️ Website Funnel Analysis Using SQL

## 2\. Executive Summary

This project conducts a comprehensive **website funnel analysis** using SQL to track the user journey from **Page View → Signup → Purchase**. By leveraging event-tracking data, the analysis quantifies conversion rates, identifies major drop-off points, and isolates user segments who show interest but fail to convert. This study is fundamental for improving **product analytics**, optimizing the **user experience (UX)**, and driving data-backed **marketing decisions**.

-----

## 3\. Business Problem

The core business challenge is to understand and improve the website's conversion efficiency. Key questions addressed are:

  * **Where are users dropping off?** Pinpointing the largest leakage in the funnel (e.g., between Page View and Signup).
  * **What is the conversion efficiency?** Calculating step-by-step and overall conversion rates.
  * **Which pages are bottlenecks?** Identifying pages (like the `/pricing` page) that attract interest but fail to motivate the next action.

The ultimate goal is to convert raw event data into **actionable metrics** to optimize the conversion pathway and maximize revenue.

-----

## 4\. Methodology

The analysis involved integrating three distinct datasets (`users`, `events`, `orders`) into a SQL database and utilizing Common Table Expressions (CTEs) and various joins to trace user movement through the funnel.

### 4.1. Database Setup

The project began by creating and populating three relational tables:

```sql
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
```

### 4.2. Funnel Tracking Queries

The funnel was quantified using **CTEs** to define each step and then aggregated to calculate conversion rates and drop-offs.

#### **Full Funnel Conversion Rate (Query 4)**

```sql
WITH funnel_pageview AS ( /* ... Step 1: unique page viewers ... */ ),
funnel_signup AS ( /* ... Step 2: unique signups ... */ ),
funnel_purchase AS ( /* ... Step 3: unique purchasers ... */ )

SELECT
    (SELECT COUNT(*) FROM funnel_pageview) AS total_visitors,
    (SELECT COUNT(*) FROM funnel_signup) AS total_signups,
    /* ... (and calculates conversion % between steps) ... */
```

#### **Drop-off Between Page View and Signup (Query 5)**

This query uses a **LEFT JOIN** to identify users who were present in the `viewed` set but were *not* present in the `signed` set.

```sql
WITH viewed AS ( /* ... all viewed any page ... */ ),
signed AS ( /* ... all signed up ... */ )

SELECT
    /* ... (Drop-off calculation using COUNT and division) ... */
FROM viewed
LEFT JOIN signed
ON viewed.visitor_id = signed.visitor_id;
```

#### **Pricing Page Bottleneck Identification (Query 7)**

Identifies users who viewed a high-intent page (`/pricing`) but failed to take the next crucial action (`signup`).

```sql
WITH pricing_viewers AS ( /* ... users who viewed /pricing ... */ ),
signed_up AS ( /* ... users who signed up ... */ )

SELECT 
    pv.visitor_id
FROM pricing_viewers pv
LEFT JOIN signed_up su
ON pv.visitor_id = su.visitor_id
WHERE su.visitor_id IS NULL; -- The core filtering logic
```

-----

## 5\. Skills

This project demonstrates core competencies essential for a Data Analyst or Product Analyst role:

  * **SQL Mastery:** Expert use of Data Definition Language ($\text{CREATE}$) and advanced filtering.
  * **Advanced SQL Techniques:** Proficient application of **Common Table Expressions (CTEs)** for staging complex steps, **LEFT JOINs** for drop-off analysis, and **Subqueries** for comprehensive metric calculation.
  * **Analytical Methodology:** Deep understanding of the **Funnel Analysis** methodology, including defining steps, calculating conversion/drop-off rates, and identifying bottlenecks.
  * **Data Transformation:** Effective use of aggregation ($\text{COUNT}$, $\text{DISTINCT}$), casting (`DECIMAL`), and rounding ($\text{ROUND}$) to produce business-ready metrics.

-----

## 6\. Results & Business Recommendation

The analysis revealed the following critical insights regarding user behavior:

### Key Insights

  * **Major Drop-off:** The most significant user leakage occurs early, specifically between **Page View → Signup**. This represents the primary bottleneck for conversion.
  * **High-Intent Leakage:** The `/pricing` page successfully drives interest, but a significant number of visitors who view it **do not proceed to sign up**, indicating a potential issue with the page content, call-to-action, or friction in the signup process.
  * **Conversion Efficiency:** The total number of users decreases predictably at every funnel step, validating the need for continuous optimization across the entire user journey.

### Business Recommendations

1.  **Optimize the Signup Path:** Prioritize UX testing and design improvements on the pages immediately preceding the signup action to reduce the massive **Page View → Signup drop-off**.
2.  **A/B Test Pricing Page:** Implement A/B testing on the `/pricing` page to experiment with different pricing structures, guarantee details, or clear calls-to-action to better convert high-intent viewers into registered users.
3.  **Content Strategy:** Leverage the **high-traffic pages** (identified in Query 6) to place more visible calls-to-action for signup, channeling more users into the funnel earlier.

-----

## 7\. Next Steps

To build upon this foundation and drive further business impact, the following steps are recommended:

1.  **Time-to-Convert Analysis:** Calculate the average time elapsed between the **Signup Event** and the **Purchase Event** to understand sales cycle velocity.
2.  **Cohort Analysis:** Segment users by $\text{signup\_date}$ to track how conversion and retention rates change over time, assessing the long-term quality of acquired users.
3.  **Visualization Layer:** Connect the SQL database to a Business Intelligence tool (e.g., Tableau or Looker) to visualize the conversion rates and drop-offs in a clear, interactive funnel diagram for executive reporting.

-----

### 🧑‍💻 Author

**P. Rethi Kumaar**
Aspiring Data Analyst • Information Science Engineering
CGPA: 7.8

| Platform | Link |
| :--- | :--- |
| **GitHub** | [https://github.com/JackieRK](https://github.com/JackieRK) |
| **LinkedIn** | [https://linkedin.com/in/rethi-kumaar](https://linkedin.com/in/rethi-kumaar) |# Website_Funnel_Analysis_Using_SQL

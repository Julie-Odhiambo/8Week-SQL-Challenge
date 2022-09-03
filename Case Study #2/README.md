## 🍕Case Study #2: Pizza Runner

<img src="https://github.com/Julie-Odhiambo/8Week-SQL-Challenge/blob/main/Case%20study/case-study-2.png" width="350" height="350">

## 📝Table of Contents
   - Problem Statement
   - Entity Relationship Diagram
   - Dataset
   - Case Study Questions
   - Solution
      - Data Processing/Cleaning
      - Pizza Metrics
      - Runner and Customer Experience
      - Ingredient Optimization
      - Pricing and Ratings
      - Ingredient Optimization
      - Bonus questions
## 🤔Problem Statement
Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!"

He was sold on the idea and wants to exand his **Pizza Empire** but pizza alone wont get him seed funding for expansion. He therefore decides to Uberize it, hence **Pizza Runner** was launched.

He starts by recruiting runners to deliver fresh pizza from pizza runner and maxes his credit card paying freelance developers to build a mobile app to accept orders from customers.
## 🔗Entity Relationship Diagram
<img src="https://github.com/Julie-Odhiambo/8Week-SQL-Challenge/blob/main/Case%20study/PizzaRunner.png" width="600" height="350">

## 📂Dataset
## ♦Case Study Question
## 📊Solution
### A. Pizza Metrics                 

 
**1. How many pizzas were ordered?**

```SQL
SELECT COUNT(*) as total_pizzas_ordered
FROM clean_customer_orders;
```
    
**2. How many unique customer orders were made?**

```SQL
SELECT COUNT(DISTINCT order_id) AS number_of_unique_orders
FROM clean_customer_orders;
```

**3. How many successful orders were delivered by each runner?**

```SQL
SELECT runner_id, 
   COUNT (*) AS successful_orders_delivered
FROM clean_runner_orders
WHERE duration IS NOT NULL
GROUP BY runner_id;
```

**4. How many of each type of pizza was delivered?**  

```SQL
SELECT p.pizza_name, 
        COUNT (*) AS Number_Of_Pizza_Delivered
FROM clean_runner_orders AS r
LEFT JOIN clean_customer_orders AS c
ON r.order_id = c.order_id
INNER JOIN pizza_names AS p
ON p.pizza_id = c.pizza_id
WHERE duration IS NOT NULL
GROUP BY p.pizza_name;
```
 
**5. How many Vegetarian and Meatlovers were ordered by each customer?**

```SQL
SELECT c.customer_id,
       p.pizza_name,
       COUNT (*) AS Number_Of_Pizza_Delivered
FROM clean_customer_orders AS c
INNER JOIN pizza_names AS p
ON c.pizza_id = p.pizza_id
GROUP BY p.pizza_name, c.customer_id
ORDER BY c.customer_id;
  ```
  
 **6. What was the maximum number of pizzas delivered in a single order?**
 
 ```SQL
SELECT COUNT(*) AS max_pizzas_delivered
FROM customer_orders AS c
INNER JOIN runner_orders AS r
ON c.order_id = r.order_id
WHERE r.distance IS NOT NULL
GROUP BY r.order_id
ORDER BY max_pizzas_delivered DESC
LIMIT 1;
 ```
 
**7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**

```SQL
SELECT cco.customer_id,
       SUM(CASE WHEN cco.exclusions IS NOT NULL 
       OR cco.extras IS NOT NULL THEN 1 ELSE 0 END) AS at_least_1_change,
       SUM(CASE WHEN cco.exclusions IS NULL AND cco.extras IS NULL THEN 1 
       ELSE 0 END) AS no_change
FROM clean_customer_orders AS cco
INNER JOIN clean_runner_orders AS cro
ON cco.order_id = cro.order_id
WHERE cro.distance IS NOT NULL
GROUP BY customer_id;
 ```
 
**8. How many pizzas were delivered that had both exclusions and extras?**

```SQL
SELECT SUM(CASE WHEN cco.exclusions IS NOT NULL AND cco.extras IS NOT NULL THEN 1 
            ELSE 0 END) AS pizza
FROM clean_customer_orders AS cco
INNER JOIN clean_runner_orders AS cro
ON cco.order_id = cro.order_id
WHERE cro.distance IS NOT NULL;
```

**9. What was the total volume of pizzas ordered for each hour of the day?**

```SQL
SELECT COUNT(*), 
       EXTRACT('HOUR' FROM order_time) as time_of_day
FROM clean_customer_orders
GROUP BY EXTRACT('HOUR' FROM order_time);
```

**10. What was the volume of orders for each day of the week?**

```SQL
SELECT TO_CHAR(order_time, 'Day') AS day_of_week,
       COUNT(*) AS pizza_count
FROM clean_customer_orders
GROUP BY day_of_week;
```

 ## B. Runner and Customer Experience
    
**1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)**

```SQL
SELECT EXTRACT(WEEK FROM registration_date) AS week,
        COUNT(*)
FROM runners
GROUP BY EXTRACT(WEEK FROM registration_date);
```

**2.  What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?**

```SQL
SELECT cro.runner_id, 
    date_part('minutes', AVG(cro.pickup_time-cco.order_time)) AS avg
FROM clean_customer_orders AS cco
INNER JOIN clean_runner_orders AS cro
ON cco.order_id = cro.order_id
WHERE cro.pickup_time IS NOT NULL
GROUP BY cro.runner_id;
```

**3. Is there any relationship between the number of pizzas and how long the order takes to prepare?**

```SQL
WITH relationship AS 
            (SELECT cco.order_id,
                COUNT(*) AS number_of_pizzas,                 
                  (cro.pickup_time-cco.order_time) AS mins_taken
             FROM clean_customer_orders AS cco
             INNER JOIN clean_runner_orders AS cro
             ON cco.order_id = cro.order_id
             WHERE cro.pickup_time IS NOT NULL
             GROUP BY cco.order_id, mins_taken)

SELECT 
  number_of_pizzas, 
  AVG(mins_taken)
FROM relationship
GROUP BY number_of_pizzas;
```

**4. What was the average distance travelled for each customer?**

```SQL
SELECT ROUND(AVG(cro.distance),2),
        cco.customer_id
 FROM clean_customer_orders AS cco
 INNER JOIN clean_runner_orders AS cro
 ON cco.order_id = cro.order_id
 GROUP BY cco.customer_id
 ORDER BY cco.customer_id;
```     
 
**5. What was the difference between the longest and shortest delivery times for all orders?**

```SQL
SELECT MAX(duration)- MIN(duration) as difference_delivery_time
FROM clean_runner_orders;

    -- 6. What was the average speed for each runner for each delivery 
            and do you notice any trend for these values? */
SELECT runner_id, order_id,
     ROUND((AVG(distance))/(AVG(duration/60)),2) AS avg_speed
FROM clean_runner_orders
WHERE pickup_time IS NOT NULL
GROUP BY runner_id, order_id
ORDER BY runner_id;
```

**7. What is the successful delivery percentage for each runner?**

```SQL
SELECT runner_id,
    ROUND((AVG(CASE WHEN distance IS NULL THEN 0
        WHEN distance IS NOT NULL THEN 1 END)*100)) AS percentage
FROM clean_runner_orders
GROUP BY runner_id;
```

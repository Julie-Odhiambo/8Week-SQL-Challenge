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
<details><summary>Click arrow to view Tables</summary>
<p>

<details><summary>customer_orders table</summary>
<p>

```customer_orders```                                                                             
| **order_id**   | **customer_id**| **pizza_id**|**exclusions**|	**extras**|**order_time**      |
| :---           |  :---          |     :---    |  :---        |     :---   |   :---             |
| 1              |   101          |     1       |              |            |2021-01-01 18:05:02 |
| 2              |   101          |     1       |              |            |2021-01-01 19:00:52 |
| 3              |   102          |     1       |              |            |2021-01-02 23:51:23 |
| 3              |   102          |     2       |              |    NaN     |2021-01-02 23:51:23 | 
| 4              |   103          |     1       |  4           |            |2021-01-04 13:23:46 |
| 4              |   103          |     1       |  4           |            |2021-01-04 13:23:46 |
| 4              |   103          |     2       |  4           |            |2021-01-04 13:23:46 |             
| 5              |   104          |     1       |  null        |    1       |2021-01-08 21:00:29 |        
| 6              |   101          |     2       |  null        |    null    |2021-01-08 21:03:13 |
| 7              |   105          |     2       |  null        |    1       |2021-01-08 21:20:29 | 
| 8              |   102          |     1       |  null        |    null    |2021-01-09 23:54:33 | 
| 9              |   103          |     1       |  4           |    1,5     |	2021-01-10 11:22:59|
| 10             |   104          |     1       |  null        |    null    |2021-01-11 18:34:49 |
| 10             |   104          |     1       |  2,6         |    1,4     |2021-01-11 18:34:49 |
</p>
</details>

<details><summary>runner_orders table</summary>
<p>

 ```runner_orders```
| **order_id**   | **runner_id**|**pickup_time**    |**distance**|**duration**|**cancellation**        |
| :---           |  :---        |     :---          |  :---      |     :---   |   :---                 |
| 1              |   1          |2021-01-01 18:15:34| 20km       | 32 minutes |                        |
| 2              |   1          |2021-01-01 19:10:54| 20km       | 27 minutes |                        |
| 3              |   1          |2021-01-03 00:12:37| 13.4km     | 20 mins    |NaN                     |
| 4              |   2          |2021-01-04 13:53:03| 23.4       | 40         |NaN                     | 
| 5              |   3          |2021-01-08 21:10:57| 10         | 15         |NaN                     |
| 6              |   3          |     null          | null       | null       |Restaurant Cancellation |
| 7              |   2          |2020-01-08 21:30:45| 25km       | 25mins     |null                    |             
| 8              |   2          |2020-01-10 00:15:02| 23.4 km    | 15 minute  |null                    |        
| 9              |   2          |   null            | null       | null       |Customer Cancellation   |
| 10             |   1          |2020-01-11 18:50:20| 10km       | 10minutes  |null                    | 
</p>
</details>

<details><summary>pizza_names table</summary>
<p>

  ```pizza_names```
|**pizza_id**|**pizza_name**|
|:---        |:---          |
|1           |Meat Lovers   |
|2           |Vegetarian    |
</p>
</details>

<details><summary>Runners table</summary>
<p>

  ```runners```
|**runner_id**|**Registration Date**|
| :---        | :---                |
|1            |2021-01-01           |
|2            |2021-01-03           |
|3            |2021-01-08           |
|4            |2021-01-15           |
</p>
</details>

<details><summary>pizza_recipes table</summary>
<p>

  ```pizza_recipes```
|**pizza_id**|**toppings**              |
|:---        |:---                      |
|1           |1, 2, 3, 4, 5, 6, 8, 10   |
|2           |4, 6, 7, 9, 11, 12        |
</p>
</details>

<details><summary>pizza_toppings table</summary>
<p>

```pizza_toppings```                                                                             
| **topping_id** | **topping_name**|
| :---           |  :---           |
| 1              |   Bacon         |
| 2              |   BBQ Sauce     |
| 3              |   Beef          | 
| 4              |   Cheese        |  
| 5              |   Chicken       | 
| 6              |   Mushrooms     | 
| 7              |   Onions        |              
| 8              |   Pepperoni     |         
| 9              |   Peppers       | 
| 10             |   Salami        | 
| 11             |   Tomatoes      | 
| 12             |   Tomato Sauce  |

</p>
</details>

</p>
</details>

## ♦Case Study Questions
<details><summary>Click here for case study questions</summary>
<p>
   
A. Pizza Metrics
1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?
   
B. Runner and Customer Experience
1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?
   
C. Ingredient Optimisation
1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
 - Meat Lovers
 - Meat Lovers - Exclude Beef
 - Meat Lovers - Extra Bacon
 - Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
 - For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
   
D. Pricing and Ratings
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
- Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
   
E. Bonus Questions
If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

</p>
</details>

## 📊Solution
<details><summary>Click here to view solution</summary>
<p>
   
## Data Processing/Cleaning

Inspecting customer_orders table:
   
```SQL
SELECT
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'customer_orders';
```
Inspecting runner_orders table:

```SQL
SELECT
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'runner_orders';
```
   
A. Customer_order:
   - Create temp table from customer_order table.
   - Replace nulls and blanks with NULLs for consistency in exclusions and extras columns

```SQL
DROP TABLE IF EXISTS clean_customer_orders;
CREATE TEMP TABLE clean_customer_orders AS
     (SELECT order_id, customer_id, pizza_id, order_time,
        CASE WHEN exclusions = 'null' or exclusions = '' THEN NULL 
            ELSE exclusions END AS exclusions,
         CASE WHEN extras = '' or extras = 'null' THEN NULL 
            ELSE extras END AS extras
     FROM customer_orders);
```
   
Checking clean_customer_orders table:

```SQL
SELECT * FROM clean_customer_orders;

-- Inspecting clean_customer_orders table:
SELECT
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'clean_customer_orders';
```
   
B. Runner_orders table:
   1. Remove nulls and blanks from pickup_time, distance, duration & cancellation columns and replace with NULLs for consistency.
   2. Convert pickup_time column to datetime data type.
   3. Remove km from distance column and convert column to numeric data type.
   4. Remove mins, minute, minutes from duration and convert to integer
```SQL          
DROP TABLE IF EXISTS clean_runner_orders;
CREATE TEMP TABLE clean_runner_orders AS 
    (SELECT order_id, runner_id, 
       CASE WHEN pickup_time = 'null' THEN NULL
            ELSE pickup_time END::timestamp AS pickup_time,
       CASE WHEN distance = 'null' THEN NULL
            WHEN distance LIKE '%km' THEN TRIM('km' from distance)
                ELSE distance END::numeric AS distance,
       CASE WHEN duration = 'null' THEN NULL
            WHEN duration LIKE '%min%' THEN LEFT(duration, 2)
                ELSE duration END::numeric AS duration,
       CASE WHEN cancellation = 'null' OR cancellation LIKE '' THEN NULL 
            ELSE cancellation END AS cancellation
    FROM runner_orders);
```

Checking clean_runner_orders table:

```SQL
SELECT * FROM clean_runner_orders
```
   
Inspecting clean_runner_orders table

```SQL
SELECT
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'clean_runner_orders';
```
   
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
```

 **6. What was the average speed for each runner for each delivery and do you notice any trend for these values?**
   
 ```SQL
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
</p>
</details>

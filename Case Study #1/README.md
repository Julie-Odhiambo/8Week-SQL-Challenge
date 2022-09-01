## Case Study #1 : Danny's Diner

<img src="https://github.com/Julie-Odhiambo/8Week-SQL-Challenge/blob/main/Case%20study/case-study-1.png" width="350" height="350">

## Table of Contents

   1. Problem Statement
   2. Entity Relationship Diagram
   3. Dataset
   4. Case Study Questions
   5. Solution

## Problem Statement

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

## Entity Relationship Diagram

## Dataset

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:
<details><summary>Click to view questions</summary>
<p>

## Case Study Questions

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer      A and B have at the end of January?
11. Recreate the following table output using the available data:  
12. Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he    	expects null ranking values for the records when customers are not yet part of the loyalty program.
</p>
</details>
   
## Solution

**1. What is the total amount each customer spent at the restaurant?**

```sql
SELECT s.customer_id, SUM(m.price) AS amount_spent
FROM menu AS m
INNER JOIN sales AS s
ON m.product_id = s.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;
```

**2. How many days has each customer visited the restaurant?**

```SQL
SELECT customer_id, COUNT(DISTINCT order_date) AS days
FROM sales
GROUP BY customer_id
```

**3. What was the first item from the menu purchased by each customer?**

```SQL
WITH purchase AS (SELECT s.customer_id, m.product_name, s.order_date,
      RANK() 
      OVER(PARTITION BY s.customer_id ORDER BY order_date) AS rank
      FROM sales AS s
      INNER JOIN menu AS m
      ON m.product_id = s.product_id)
SELECT DISTINCT purchase.customer_id, purchase.product_name, purchase.order_date
FROM purchase
WHERE rank = 1
```

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

```SQL
WITH most_purchased AS (
     SELECT COUNT(*) AS count, product_id
     FROM sales
       GROUP BY product_id
      )
SELECT m.product_name, m_p.count
FROM menu AS m
INNER JOIN most_purchased AS m_p
ON m_p.product_id = m.product_id
ORDER BY m_p.count DESC
LIMIT 1
```

**5. Which item was the most popular for each customer?**

```SQL
WITH most_popular AS (
          SELECT s.customer_id, m.product_name, COUNT(*) AS order_count,
        RANK() OVER(PARTITION BY s.customer_id 
          ORDER BY count(s.customer_id) DESC) AS count
          FROM sales AS s
          INNER JOIN menu AS m
          ON s.product_id = m.product_id
                GROUP BY s.customer_id, m.product_name			
         )
SELECT most_popular.customer_id, most_popular.product_name
FROM most_popular
WHERE most_popular.count = 1
```

**6. Which item was purchased first by the customer after they became a member?**

```SQL
WITH member_purchase AS (SELECT	s.customer_id, m.product_name,
        RANK()
          OVER(partition by s.customer_id 
          ORDER BY s.order_date) AS first_purchased, 
        s.order_date
             FROM sales AS s
       INNER JOIN members AS m1
       ON s.customer_id = m1.customer_id
       INNER JOIN menu AS m
       ON s.product_id = m.product_id
       WHERE s.order_date >= m1.join_date)
SELECT customer_id, product_name, order_date
FROM member_purchase
WHERE first_purchased = 1
```

**7. Which item was purchased just before the customer became a member?**

```SQL
WITH member_purchase AS (SELECT	s.customer_id, m.product_name,
          RANK()
            OVER(partition by s.customer_id 
         ORDER BY s.order_date DESC) AS last_purchased, 
          s.order_date
       FROM sales AS s
       INNER JOIN members AS m1
       ON s.customer_id = m1.customer_id
       INNER JOIN menu AS m
       ON s.product_id = m.product_id
       WHERE s.order_date < m1.join_date)
SELECT customer_id, product_name, order_date
FROM member_purchase
WHERE last_purchased = 1
```

**8. What is the total items and amount spent for each member before they became a member?**

```SQL
SELECT  s.customer_id, COUNT (*) AS total_items, SUM(m.price) AS amount_spent
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
JOIN members AS m1
ON s.customer_id = m1.customer_id 
WHERE order_date < join_date
GROUP BY s.customer_id
```

**9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**

```SQL
SELECT s.customer_id,
    SUM( CASE WHEN product_name = 'sushi' THEN price*10*2
      ELSE price*10 END) AS points
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id
```

**10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**

```SQL
SELECT s.customer_id,
    SUM(CASE WHEN product_name = 'sushi' 
      OR order_date BETWEEN CAST(join_date as timestamp) 
      AND CAST(join_date as timestamp) + INTERVAL '6 DAY' THEN price*10*2
       ELSE price*10 END) AS points
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
LEFT JOIN members AS m1
ON s.customer_id = m1.customer_id
WHERE s.customer_id IN ('A', 'B')
AND EXTRACT(month from order_date) = 1
GROUP BY s.customer_id
```

## BONUS QUESTIONS 
 
**1. JOIN ALL THINGS**

```SQL
SELECT  s.customer_id, s.order_date, m.product_name, m.price, 
    CASE WHEN order_date >= join_date THEN 'Y'
        ELSE 'N' END AS member
FROM sales AS s
INNER JOIN menu AS m
ON s. product_id = m.product_id
LEFT JOIN members AS m1
ON s.customer_id = m1.customer_id
ORDER BY s.customer_id, s.order_date, m.price DESC
```

**2. RANK ALL THE THINGS**

```SQL
WITH rankings1 AS (
                 SELECT  s.customer_id, s.order_date, m.product_name, m.price, 
                   CASE WHEN order_date >= join_date THEN 'Y'
                     ELSE 'N' END AS member
                 FROM sales AS s
                 INNER JOIN menu AS m
                 ON s. product_id = m.product_id
                 LEFT JOIN members AS m1
                 ON s.customer_id = m1.customer_id
                 ORDER BY s.customer_id, s.order_date, m.price DESC
                )
SELECT *, CASE WHEN member = 'N' THEN NULL
          WHEN member = 'Y' THEN RANK() 
           OVER(PARTITION BY customer_id, member
                ORDER BY order_date) END AS ranking
FROM rankings1
```

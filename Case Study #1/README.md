## Case Study #1 : Danny's Diner

<img src="https://github.com/Julie-Odhiambo/8Week-SQL-Challenge/blob/main/Case%20study/case-study-1.png" width="350" height="350">

## Table of Contents

   1. Problem Statement
   2. Entity Relationship Diagram
   3. Dataset
   4. Case Study Questions
   5. Solution

## Problem Statement

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers. He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

## Entity Relationship Diagram
<details><summary>Click to view ERD Diagram</summary>
<p>

<img src="https://github.com/Julie-Odhiambo/8Week-SQL-Challenge/blob/main/Case%20study/download%20(1).png" width="700" height="350">

</p>
</details>

## Dataset
<details><summary>Click to view Dataset</summary>
<p>
Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:
</p>
</details>

## Case Study Questions
<details><summary>Click to view questions</summary>
<p>

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
<details><summary>Click to view solution</summary>
<p>

**1. What is the total amount each customer spent at the restaurant?**

```sql
SELECT s.customer_id, SUM(m.price) AS amount_spent
FROM menu AS m
INNER JOIN sales AS s
ON m.product_id = s.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;
```
**Steps:**
- Use **SUM** and **GROUP BY** to get ```amount_spent``` for each customer.
- Use **INNER JOIN** to merge ```sales``` and ```menu``` tables on ```product_id.```

**Output:**
| **cutomer_id** | **amount_spent** | 
| :---           |     :---         |     
| A              |      76          | 
| B              |      74          |
| C              |      36          |

**Answer:**
- Customer A spent $76.
- Customer B spent $74.
- Customer C spent $36.

**2. How many days has each customer visited the restaurant?**

```SQL
SELECT customer_id, COUNT(DISTINCT order_date) AS days
FROM sales
GROUP BY customer_id
```

**Steps:**
- Use **COUNT DISTINCT** on ```order_date``` to calculate the number of visits to the restaurant for each customer.
- using **COUNT** alone without **DISTINCT** would result in repetition of the number of ```days.```

**Output:**
| **cutomer_id** | **days**        | 
| :---           |     :---        |     
| A              |      4          | 
| B              |      6          |
| C              |      2          |

**Answer:**
- Customer A visited the restaurant 4 times.
- Customer B visited the restaurant 6 times.
- Customer C visited the restaurant 2 times.

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

**Steps:**
- Create a CTE ```purchase.```
- Use **Windows function**'s **RANK** to create a new column ```rank``` based on ```order_date.```
- Use **INNER JOIN** to merge tables ```menu``` and ```sales.```
- In the main query, **SELECT** ```purchase.customer_id,``` ```purchase.product_name``` and ```purchase.order_date```
  and subset using **where** for **RANK** 1.

**Output:**
| **cutomer_id** | **product_name**| **order_date**|
| :---           |     :---        |  :---         | 
| A              |      curry      |    2011-01-01 |  
| A              |      sushi      |    2011-01-01 | 
| B              |      curry      |    2011-01-01 | 
| C              |      ramen      |    2011-01-01 |

**Answer:**
- Customer A's first order was sushi and curry.
- Customer B's first order is curry.
- Customer C's first order is ramen.

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

```SQL
WITH most_purchased AS (
     SELECT COUNT(*) AS count, 
               product_id
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
**Steps:**
- Create a CTE ```most_purchased.```
- Use **GROUP BY** and **COUNT** to get total count for each ```product_id.```
- Create another query and **INNER JOIN** ```menu``` table and ```most_purchased``` CTE.
- Use **ORDER BY** ```DESC``` to get output from largest to smallest.
- Use **LIMIT** ```1``` to output the most purchased item only.

**Output**
| **product_name**| **count**|
|     :---        |  :---    | 
|      ramen      |    8     |  

**Answer:**
Ramen is the most purchased item on the menu and was bought 8 times.

**5. Which item was the most popular for each customer?**

```SQL
WITH most_popular AS (
          SELECT s.customer_id, 
                      m.product_name, 
                        COUNT(*) AS order_count,
                         RANK() OVER(PARTITION BY s.customer_id 
          ORDER BY count(s.customer_id) DESC) AS count
          FROM sales AS s
          INNER JOIN menu AS m
          ON s.product_id = m.product_id
                GROUP BY s.customer_id, m.product_name			
         )
SELECT most_popular.customer_id, 
            most_popular.product_name
FROM most_popular
WHERE most_popular.count = 1
```
**Steps:**
- Create a cte ```most_popular```.
- Use **RANK** to sort the ```order_count``` for each product in descending order for each customer.
- Use **WHERE** to subset results for```most_popular.count``` = 1 to get most popular item for each customer.

**Output:**
| **cutomer_id** | **product_name**|
| :---           |     :---        | 
| A              |      ramen      |  
| B              |      sushi      | 
| B              |      curry      |
| B              |      ramen      |
| C              |      ramen      |

**Answer:**
- Ramen is a fave for all customers.
- In addition to that, curry and sushi are also popular for customer B.

**6. Which item was purchased first by the customer after they became a member?**

```SQL
WITH member_purchase AS (SELECT	s.customer_id, m.product_name,
                                 RANK()
                                     OVER(partition by s.customer_id ORDER BY s.order_date) AS first_purchased, 
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
**Steps:**
- Create a cte ```member_purchase```.
- Use **windows function**'s **RANK** to **partition by** ```customer_id``` in ascending order of ```order_date```. 
- Use **WHERE** to filter for ```order_date``` on or after ```join_date```.
- In the main query, **SELECT** ```cutomer_id``` and use **WHERE** to filter for first ```rank``` only to get first item purchased by each customer.

**Output:**
| **cutomer_id** | **product_name**| **order_date**|
| :---           |     :---        |  :---         | 
| A              |      sushi      |    2011-01-07 |  
| B              |      curry      |    2011-01-11 |

**Answer:**
Customer A's first order as member is sushi.
Customer B's first order as member is curry.

**7. Which item was purchased just before the customer became a member?**

```SQL
WITH member_purchase AS (SELECT s.customer_id, m.product_name,
                                  RANK() OVER(partition by s.customer_id 
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

**Steps:**
- Create a **cte** ```member_purchase```.
- Use **Window functions**'s **Rank** to create new column **Partition by** ```customer_id``` in descending order_date to find out the last order_date before  customer becomes a member.
- Create a main query and **Select** ```customer_id```, ```product_name,``` ```order_date```.
- Use **WHERE** to filter for ```last_purchased``` before join_date.

**Output**
| **cutomer_id** | **product_name**| **order_date**|
| :---           |     :---        |  :---         | 
| A              |      sushi      |    2011-01-01 |  
| A              |      curry      |    2011-01-01 | 
| B              |      sushi      |    2011-01-04 | 

**Answer**
Customer A’s last order before becoming a member is sushi and curry.
Customer B's last order before becoming a member is sushi.

**8. What is the total items and amount spent for each member before they became a member?**

```SQL
SELECT  s.customer_id, 
         COUNT (*) AS total_items, 
            SUM(m.price) AS amount_spent
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
JOIN members AS m1
ON s.customer_id = m1.customer_id 
WHERE order_date < join_date
GROUP BY s.customer_id
```

**Steps:**
- **JOIN** tables ```menu```, ```members``` and ```sales```.
- Use **WHERE** to filter for ```order_date``` before ```join_date```.
- Use **COUNT** and **SUM** to get ```total_items``` and total ```amount_spent``` respectively together with **GROUP BY** on  ```customer_id```.

**Output**
| **cutomer_id** | **product_name**| **order_date**|
| :---           |     :---        |  :---         | 
| A              |      3          |    25         |  
| B              |      2          |    40         | 

**Answer:**

Customer A spent $ 25 on 3 items.
Customer B spent $40 on 2 items.

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
**Steps:**
- Use **CASE WHEN** to create conditional statements. If product_name = sushi, then multiply price by 2*10 points.
- Else, multiply $1 by 10 points ```price``` and **SUM** the points.

**Output:**

| **cutomer_id** | **points**      |
| :---           |     :---        |
| A              |      860        |  
| B              |      940        | 
| C              |      360        |

**Answer**
- Customer A's total points is 860.
- Customer B's total points is 940.
- Customer C's total points is 360.

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
**Output:**
| **cutomer_id** | **points**      |
| :---           |    :---         |
| A              |    1370         |  
| B              |    940          | 

**Answer:**
Total points for Customer A is 1,370.
Total points for Customer B is 820.
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
**Answer**

| **cutomer_id** | **order_date**| **product_name**|**price**|	**member**|
| :---           |  :---         |     :---        |  :---   | :---      |
| A              |   2021-01-01  |     sushi       |  10     |    N      |
| A              |   2021-01-01  |     curry       |  15     |    N      |
| A              |   2021-01-07  |     curry       |  15     |    Y      |
| A              |   2021-01-10  |     ramen       |  12     |    Y      |
| A              |   2021-01-11  |     ramen       |  12     |    Y      |
| A              |   2021-01-11  |     ramen       |  12     |    Y      |
| B              |   2021-01-01  |     curry       |  15     |    N      |
| B              |   2021-01-02  |     curry       |  15     |    N      |
| B              |   2021-01-04  |     sushi       |  10     |    N      |
| B              |   2021-01-11  |     sushi       |  10     |    Y      |
| B              |   2021-01-16  |     ramen       |  12     |    Y      |
| B              |   2021-02-01  |     ramen       |  12     |    Y      |
| C              |   2021-01-01  |     ramen       |  12     |    N      |
| C              |   2021-01-01  |     ramen       |  12     |    N      |
| C              |   2021-01-07  |     ramen       |  12     |    N      |

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

**Answer**

| **cutomer_id** | **order_date**| **product_name**|**price**|	**member**|	**ranking**|
| :---           |  :---         |     :---        |  :---   | :---      | :---       |
| A              |   2021-01-01  |     sushi       |  10     |    N      |   NULL     |
| A              |   2021-01-01  |     curry       |  15     |    N      |   NULL     |
| A              |   2021-01-07  |     curry       |  15     |    Y      |    1       |
| A              |   2021-01-10  |     ramen       |  12     |    Y      |    2       |
| A              |   2021-01-11  |     ramen       |  12     |    Y      |    3       |
| A              |   2021-01-11  |     ramen       |  12     |    Y      |    3       |
| B              |   2021-01-01  |     curry       |  15     |    N      |   NULL     |
| B              |   2021-01-02  |     curry       |  15     |    N      |   NULL     |
| B              |   2021-01-04  |     sushi       |  10     |    N      |   NULL     |
| B              |   2021-01-11  |     sushi       |  10     |    Y      |    1       |
| B              |   2021-01-16  |     ramen       |  12     |    Y      |    2       |
| B              |   2021-02-01  |     ramen       |  12     |    Y      |    3       |
| C              |   2021-01-01  |     ramen       |  12     |    N      |   NULL     |
| C              |   2021-01-01  |     ramen       |  12     |    N      |   NULL     |
| C              |   2021-01-07  |     ramen       |  12     |    N      |   NULL     |

</p>
</details>

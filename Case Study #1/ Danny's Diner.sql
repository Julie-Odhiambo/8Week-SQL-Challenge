
/* CASE STUDY #1 - DANNY'S DINER */

CREATE SCHEMA dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
	 -- 1. What is the total amount each customer spent at the restaurant?
  SELECT s.customer_id, SUM(m.price) AS amount_spent
  FROM menu AS m
  INNER JOIN sales AS s
  ON m.product_id = s.product_id
  GROUP BY s.customer_id
  ORDER BY s.customer_id;

   -- 2. How many days has each customer visited the restaurant?
  SELECT customer_id, COUNT(DISTINCT order_date) AS days
  FROM sales
  GROUP BY customer_id

   -- 3. What was the first item from the menu purchased by each customer?
  WITH purchase AS (SELECT s.customer_id, m.product_name, s.order_date,
  			RANK() 
			  OVER(PARTITION BY s.customer_id ORDER BY order_date) AS rank
		    FROM sales AS s
		    INNER JOIN menu AS m
		    ON m.product_id = s.product_id)
  SELECT DISTINCT purchase.customer_id, purchase.product_name, purchase.order_date
  FROM purchase
  WHERE rank = 1

   -- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
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

-- 5. Which item was the most popular for each customer?
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
					
-- 6. Which item was purchased first by the customer after they became a member?

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

-- 7. Which item was purchased just before the customer became a member?

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

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT  s.customer_id, COUNT (*) AS total_items, SUM(m.price) AS amount_spent
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
JOIN members AS m1
ON s.customer_id = m1.customer_id 
WHERE order_date < join_date
GROUP BY s.customer_id

 /*9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many 
	points would each customer have? */
SELECT s.customer_id,
		SUM( CASE WHEN product_name = 'sushi' THEN price*10*2
			ELSE price*10 END) AS points
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id

/*10. In the first week after a customer joins the program (including their join date) they 
  earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January? */
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

/*BONUS QUESTIONS 
 2. JOIN ALL THINGS */

SELECT  s.customer_id, s.order_date, m.product_name, m.price, 
    CASE WHEN order_date >= join_date THEN 'Y'
        ELSE 'N' END AS member
FROM sales AS s
INNER JOIN menu AS m
ON s. product_id = m.product_id
LEFT JOIN members AS m1
ON s.customer_id = m1.customer_id
ORDER BY s.customer_id, s.order_date, m.price DESC

-- 2. RANK ALL THE THINGS

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

/* --------------------
   Case Study Questions
   --------------------*/
-- 1. What is the total amount each customer spent at the restaurant?
SELECT sales.customer_id, sum(menu.price)
FROM dannys_diner.sales as sales
JOIN dannys_diner.menu as menu ON sales.product_id = menu.product_id 
GROUP BY sales.customer_id ;

-- 2. How many days has each customer visited the restaurant?
SELECT sales.customer_id, count(distinct(sales.order_date)) as days
FROM dannys_diner.sales as sales
GROUP BY sales.customer_id;

-- 3. What was the first item from the menu purchased by each customer?
WITH ranking as (
	SELECT sales.customer_id, menu.product_name, sales.order_date,
			dense_rank() over(partition by sales.customer_id order by sales.order_date) AS order_rank
    FROM dannys_diner.sales as sales
    JOIN dannys_diner.menu as menu
    ON sales.product_id = menu.product_id
)
SELECT customer_id, product_name
FROM ranking
WHERE order_rank = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT menu.product_name, COUNT(sales.product_id) as number_purchased
FROM dannys_diner.menu as menu
JOIN dannys_diner.sales as sales
ON menu.product_id = sales.product_id
GROUP BY menu.product_name
ORDER BY number_purchased DESC
limit 1;

-- 5. Which item was the most popular for each customer?
WITH ranking AS(
	SELECT sales.customer_id, 
			menu.product_name, 
			COUNT(sales.product_id) as number_purchased,
			dense_rank() OVER (partition by sales.customer_id order by COUNT(sales.product_id) DESC) AS pur_rank
    FROM dannys_diner.sales as sales
    JOIN dannys_diner.menu as menu
    ON sales.product_id = menu.product_id
    GROUP BY sales.customer_id, sales.product_id, menu.product_name
)
SELECT customer_id, product_name, number_purchased
FROM ranking
WHERE pur_rank = 1;

-- 6. Which item was purchased first by the customer after they became a member?
WITH ranking as(
	SELECT sales.customer_id, menu.product_name, sales.order_date,
			dense_rank() OVER(partition by sales.customer_id order by sales.order_date) as order_rank
    FROM dannys_diner.sales AS sales
    JOIN dannys_diner.menu AS menu
    ON sales.product_id = menu.product_id
    JOIN dannys_diner.members as members
    ON sales.customer_id = members.customer_id
    WHERE sales.order_date >= members.join_date
)
SELECT customer_id, product_name, order_date
FROM ranking
WHERE order_rank = 1;

-- 7. Which item was purchased just before the customer became a member?
WITH ranking as(
	SELECT sales.customer_id, menu.product_name, sales.order_date,
			dense_rank() OVER(partition by sales.customer_id order by sales.order_date) as order_rank
    FROM dannys_diner.sales AS sales
    JOIN dannys_diner.menu AS menu
    ON sales.product_id = menu.product_id
    JOIN dannys_diner.members as members
    ON sales.customer_id = members.customer_id
    WHERE sales.order_date < members.join_date
)
SELECT customer_id, product_name, order_date
FROM ranking
WHERE order_rank = 1;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT sales.customer_id, count(sales.product_id) as items, sum(menu.price) as total_price
FROM dannys_diner.sales AS sales
JOIN dannys_diner.menu AS menu
ON sales.product_id = menu.product_id
JOIN dannys_diner.members as members
ON sales.customer_id = members.customer_id
WHERE sales.order_date < members.join_date
GROUP BY sales.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
WITH points as(
	SELECT *, CASE
			WHEN product_id = 1 THEN price*20
            ELSE price*10
            END as mem_point
    FROM dannys_diner.menu
)
SELECT sales.customer_id, SUM(points.mem_point) as get_point
FROM dannys_diner.sales as sales
JOIN points
ON sales.product_id = points.product_id
GROUP BY sales.customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

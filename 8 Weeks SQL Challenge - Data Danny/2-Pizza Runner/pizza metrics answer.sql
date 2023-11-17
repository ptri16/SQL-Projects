SELECT * 
FROM customer_orders;

SELECT *
FROM pizza_recipes;

SELECT * 
FROM pizza_toppings;

SELECT *
FROM runner_orders;

-- 1. How many pizzas were ordered?
 SELECT COUNT(*) as total_pizzas
 FROM customer_orders;
 
 -- 2. How many unique customer orders were made?
 SELECT COUNT(DISTINCT(order_id)) as unique_orders
 FROM customer_orders;
 
 -- 3. How many successful orders were delivered by each runner?
 SELECT runner_id,
		COUNT(order_id) as successful_order 
 FROM runner_orders
 WHERE distance != 0
 GROUP BY runner_id;
 
-- 4. How many of each type of pizza was delivered?
SELECT cust_orders.pizza_id, 
		COUNT(cust_orders.pizza_id) as total_delivered
FROM customer_orders AS cust_orders
JOIN runner_orders AS run_orders
ON cust_orders.order_id = run_orders.order_id
WHERE run_orders.duration != 0
GROUP BY cust_orders.pizza_id;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT co.customer_id,
		pn.pizza_name,
        COUNT(co.pizza_id) as order_count
FROM customer_orders AS co
JOIN pizza_names as pn
ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id, pn.pizza_name
ORDER BY co.customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT COUNT(co.order_id) as pizza_count
FROM customer_orders AS co
JOIN runner_orders as ro
ON co.order_id = ro.order_id
WHERE ro.distance != 0
GROUP BY co.order_id
ORDER BY pizza_count DESC
limit 1;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT co.customer_id,
		COUNT(CASE WHEN co.exclusions != '' OR co.extras != '' THEN 1 END) AS changes,
        COUNT(CASE WHEN co.exclusions = '' OR co.extras = '' THEN 1 END) as no_changes
FROM customer_orders AS co
JOIN runner_orders AS ro
ON co.order_id = ro.order_id
WHERE ro.duration != 0 
GROUP BY co.customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(co.order_id) as pizza_w_extras_and_exclusion
FROM customer_orders AS co
JOIN runner_orders AS ro
ON co.order_id = ro.order_id
WHERE ro.duration != 0 AND co.exclusions != '' AND co.extras != '';

-- 9. What was the total volume of pizzas ordered for each hour of the day?

-- 10. What was the volume of orders for each day of the week?
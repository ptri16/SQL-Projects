USE pizza_runner;

DROP TABLE IF EXISTS customer_orders_backup;
CREATE TABLE customers_orders_backup
SELECT * 
FROM customer_orders;

UPDATE customer_orders 
SET 
    exclusions = CASE
        WHEN exclusions IS NULL OR exclusions = 'null' THEN ''
        ELSE exclusions
    END,
    extras = CASE
        WHEN extras IS NULL OR extras = 'null' THEN ''
        ELSE extras
    END;

DROP TABLE IF EXISTS runner_orders_backup;
CREATE TABLE runner_orders_backup
SELECT * 
FROM runner_orders;

UPDATE runner_orders 
SET 
    pickup_time = CASE
        WHEN
            pickup_time IS NULL OR pickup_time = 'null' THEN '0000-00-00 00:00:00'
        ELSE pickup_time
    END,
    distance = CASE
		WHEN distance IS NULL OR distance = "null" THEN "0"
		WHEN distance LIKE "%km" THEN TRIM('km' FROM distance)
        ELSE distance
	END,
    duration = CASE
		WHEN duration IS NULL OR duration = 'null' THEN '0'
        WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration)
        WHEN duration LIKE '%minute' THEN TRIM('minute' FROM duration)
        WHEN duration LIKE '%mins' THEN TRIM('mins' FROM duration)
        ELSE duration
	END,
    cancellation = CASE
		WHEN cancellation IS NULL OR cancellation = 'null' THEN ''
        ELSE cancellation
	END;
  
-- Alter pickup_time column to TIMESTAMP without time zone
ALTER TABLE runner_orders
MODIFY COLUMN pickup_time TIMESTAMP;

-- Alter distance column to FLOAT
ALTER TABLE runner_orders
MODIFY COLUMN distance FLOAT;

-- Alter duration column to INT
ALTER TABLE runner_orders
MODIFY COLUMN duration INT;


select *
from runner_orders
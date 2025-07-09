
*** Project PIZZA_SALES *****

use Pizza_Hut

select order_details_id from order_details

select * from order_details
select* from orders
select * from pizza_types
select * from pizzas

--- Question- 1. Retrieve the total number of orders placed.--

select count(order_id)as total_numbers from orders

--Question- 2. Calculate the total revenue generated from pizza sales

select round (sum(order_details.quantity*pizzas.price),2) as total_sales from order_details
Join pizzas on pizzas.pizza_id=order_details.pizza_id

---Question- 3.Identify the highest-priced pizza.

SELECT TOP 1 pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC;

 ----Question  4.  Identify the most common pizza size ordered
 SELECT TOP 10 pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC;

Select pizzas.size,COUNT(order_details.order_details_id) as order_count from pizzas join order_details 
on pizzas.pizza_id=order_details.pizza_id group by pizzas.size order by order_count desc;

----Question -5. List the top 5 most ordered pizza types along with their quantities.

SELECT TOP 5 pizza_types.name, sum( order_details.quantity) as Sum_Quantity from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id join order_details 
on order_details.pizza_id=pizzas.pizza_id group by pizza_types.name order by Sum_Quantity desc;

**********************************************************************
-------Intermediate:
--- 6. Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT pizza_types.category AS pizza_category, SUM(order_details.quantity) AS total_quantity
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY total_quantity DESC;

-----------6. Determine the distribution of orders by hour of the day.

select * from order_details
select* from orders
select * from pizza_types
select * from pizzas

SELECT DATEPART(HOUR, time) AS order_hour, COUNT(*) AS order_count
FROM orders
GROUP BY DATEPART(HOUR, time)
ORDER BY order_hour;



-----7.Join relevant tables to find the category-wise distribution of pizzas.
SELECT CATEGORY, COUNT(NAME) FROM PIZZA_TYPES GROUP BY CATEGORY;

----8.Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT ROUND(AVG(quantity_order), 0) AS avg_quantity_per_day
FROM (
    SELECT orders.date, SUM(order_details.quantity) AS quantity_order
    FROM orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.date
) AS order_quantity;


-----9.Determine the top 3 most ordered pizza types based on revenue.

SELECT top 3 PIZZA_TYPES.name AS pizza_type, SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types 
JOIN pizzas  ON PIZZA_TYPES.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
JOIN orders  ON order_details.order_id = orders.order_id
GROUP BY PIZZA_TYPES.name
ORDER BY revenue DESC;



--------------------Advanced:
select * from order_details
select* from orders
select * from pizza_types
select * from pizzas
------10.Calculate the percentage contribution of each pizza type to total revenue.
-- Calculate total revenue
SELECT SUM(pizzas.price * order_details.quantity) AS total_revenue
FROM pizzas 
JOIN order_details  ON pizzas.pizza_id = order_details.pizza_id;

-- Calculate percentage contribution of each pizza type to total revenue

SELECT top 15 pizza_types.name AS pizza_type,
    SUM(pizzas.price * order_details.quantity) AS revenue,
    (SUM(pizzas.price * order_details.quantity) / total_revenue * 100) AS percentage_contribution
FROM pizza_types 
JOIN pizzas  ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
JOIN (
    SELECT SUM(pizzas.price * order_details.quantity) AS total_revenue
    FROM pizzas 
    JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
) AS total_rev ON 1=1
GROUP BY pizza_types.name, total_revenue
ORDER BY revenue DESC;

---11.Analyze the cumulative revenue generated over time.
--

select date, sum(revenue) over(order by date) as Cum_revenue from 
(select orders.date, sum(order_details.quantity*pizzas.price) as revenue from order_details join 
pizzas on order_details.pizza_id=pizzas.pizza_id 
join orders on orders.order_id=order_details.order_id
group by orders.date) as sales;


----12. Determine the top 3 most ordered pizza types based on revenue for each pizza category.


    SELECT top 3
        pizza_types.category AS pizza_category,
        pizza_types.name AS pizza_type,
        SUM(pizzas.price * order_details.quantity) AS revenue,
        ROW_NUMBER() OVER(PARTITION BY pizza_types.category ORDER BY SUM(pizzas.price * order_details.quantity) DESC) AS rank
    FROM pizza_types
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
    JOIN orders ON order_details.order_id = orders.order_id
    GROUP BY pizza_types.category, pizza_types.name;



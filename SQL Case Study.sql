SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(total_amount) AS total_revenue
FROM 
    Orders
WHERE 
    order_date >= '2023-01-01' AND order_date < '2023-04-01'
GROUP BY 
    month;


----


SELECT 
    p.product_id,
    p.name AS product_name,
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM 
    Products p
JOIN 
    Order_Items oi ON p.product_id = oi.product_id
JOIN 
    Orders o ON oi.order_id = o.order_id
JOIN 
    Customers c ON o.customer_id = c.customer_id
WHERE 
    c.join_date < '2023-01-01'
GROUP BY 
    p.product_id, p.name, p.category
ORDER BY 
    total_revenue DESC
LIMIT 
    5;


----

SELECT 
    c.customer_id,
    c.name AS customer_name,
    COUNT(DISTINCT p.category) AS distinct_categories_ordered
FROM 
    Customers c
JOIN 
    Orders o ON c.customer_id = o.customer_id
JOIN 
    Order_Items oi ON o.order_id = oi.order_id
JOIN 
    Products p ON oi.product_id = p.product_id
GROUP BY 
    c.customer_id, c.name
HAVING 
    COUNT(DISTINCT p.category) >= 3;


-----

SELECT 
    r.product_id,
    AVG(r.rating) AS average_rating
FROM 
    Reviews r
GROUP BY 
    r.product_id
HAVING 
    COUNT(*) >= 5;


----

SELECT 
    c.customer_id,
    c.name AS customer_name,
    SUM(o.total_amount) AS total_spending
FROM 
    Customers c
JOIN 
    Orders o ON c.customer_id = o.customer_id
WHERE 
    o.total_amount >= 100
GROUP BY 
    c.customer_id, c.name
ORDER BY 
    total_spending DESC
LIMIT 
    1;


------- level 2 

SELECT 
    category,
    MONTH(order_date) AS month,
    YEAR(order_date) AS year,
    (SUM(total_amount) - LAG(SUM(total_amount), 1, 0) OVER (PARTITION BY category ORDER BY YEAR(order_date), MONTH(order_date))) / LAG(SUM(total_amount), 1, 1) OVER (PARTITION BY category ORDER BY YEAR(order_date), MONTH(order_date)) * 100 AS month_over_month_growth_percentage
FROM 
    Orders o
JOIN 
    Order_Items oi ON o.order_id = oi.order_id
JOIN 
    Products p ON oi.product_id = p.product_id
WHERE 
    order_date >= '2023-01-01' AND order_date < '2023-04-01'
GROUP BY 
    category, MONTH(order_date), YEAR(order_date);

----
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    AVG(total_amount) AS average_order_value
FROM 
    Orders
WHERE 
    total_amount > 100
    AND order_date >= '2023-01-01' AND order_date < '2023-04-01'
GROUP BY 
    YEAR(order_date), MONTH(order_date);

------
SELECT 
    product_id,
    CASE 
        WHEN AVG(rating) >= 4 THEN 'Highly Rated'
        WHEN AVG(rating) >= 3 AND AVG(rating) < 4 THEN 'Moderately Rated'
        ELSE 'Low Rated'
    END AS review_sentiment
FROM 
    Reviews
GROUP BY 
    product_id;

-----
SELECT 
    customer_id,
    SUM(total_amount) AS total_revenue
FROM 
    Orders
WHERE 
    customer_id NOT IN (
        SELECT 
            customer_id
        FROM 
            Customers
        WHERE 
            join_date >= '2023-03-01'
    )
    AND order_date >= '2023-01-01' AND order_date < '2023-04-01'
GROUP BY 
    customer_id
ORDER BY 
    total_revenue DESC
LIMIT 
    (SELECT COUNT(*) * 0.1 FROM (SELECT DISTINCT customer_id FROM Orders WHERE order_date >= '2023-01-01' AND order_date < '2023-04-01') AS total_customers);



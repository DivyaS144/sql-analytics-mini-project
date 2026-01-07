-- SQL Mini Project: E-Commerce Database Analysis

-- ===============================
-- Level 1: Basics
-- ===============================

-- 1. Retrieve customer names and emails for email marketing
SELECT 
    name, email
FROM
    customers;

-- 2. View complete product catalog with all available details
SELECT 
    *
FROM
    products;

-- 3. List all unique product categories
SELECT DISTINCT
    category
FROM
    products; 

-- 4. Show all products priced above ₹1,000
SELECT 
    *
FROM
    products
WHERE
    price > 1000;

-- 5. Display products within a mid-range price bracket (₹2,000 to ₹5,000)
SELECT 
    *
FROM
    products
WHERE
    price BETWEEN 2000 AND 5000;

-- 6. Fetch data for specific customer IDs (e.g., from loyalty program list)
-- Assuming customer IDs 1, 2, 3 are from a loyalty program
SELECT 
    *
FROM
    customers
WHERE
    customer_id IN (1 , 2, 3);

-- 7. Identify customers whose names start with the letter 'A'
SELECT 
    *
FROM
    customers
WHERE
    name LIKE 'A%';

-- 8. List electronics products priced under ₹3,000
SELECT 
    *
FROM
    products
WHERE
    category = 'electronics'
        AND price < 3000;

-- 9. Display product names and prices in descending order of price
SELECT 
    name, price
FROM
    products
ORDER BY price DESC;

-- 10. Display product names and prices, sorted by price and then by name
SELECT 
    name, price
FROM
    products
ORDER BY price , name;


-- ========================================
-- Level 2: Filtering and Formatting
-- ========================================

-- 1. Retrieve orders where customer information is missing (possibly due to data migration or deletion)
SELECT 
    *
FROM
    orders
WHERE
    customer_id IS NULL;

-- 2. Display customer names and emails using column aliases for frontend readability
SELECT 
    name AS customer_name, email AS customer_email
FROM
    customers;

-- 3. Calculate total value per item ordered by multiplying quantity and item price
SELECT 
    p.name, o.quantity * o.item_price AS total_value_per_item
FROM
    products p
        INNER JOIN
    order_items o ON p.product_id = o.product_id;

-- 4. Combine customer name and phone number in a single column
SELECT 
    CONCAT(name, '_', phone) AS customers_name_phone
FROM
    customers;

-- 5. Extract only the date part from order timestamps for date-wise reporting
SELECT 
    DATE(order_date) AS order_date
FROM
    orders;

-- 6. List products that do not have any stock left
SELECT 
    *
FROM
    products
WHERE
    stock_quantity = 0;


-- ===============================
-- Level 3: Aggregations
-- ===============================

-- 1. Count the total number of orders placed
SELECT 
    COUNT(*) AS total_no_of_orders
FROM
    orders;

-- 2. Calculate the total revenue collected from all orders
SELECT 
    SUM(total_amount) AS total_revenue
FROM
    orders;

-- 3. Calculate the average order value
SELECT 
    AVG(total_amount) AS avg_order_value
FROM
    orders;

-- 4. Count the number of customers who have placed at least one order
select count(distinct customer_id) as number_of_active_customers from orders;

-- 5. Find the number of orders placed by each customer
SELECT 
    o.customer_id, c.name, COUNT(o.order_id) AS num_of_orders
FROM
    orders o
        JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY customer_id , c.name;

-- 6. Find total sales amount made by each customer
SELECT 
    o.customer_id, c.name, SUM(o.total_amount) AS total_sales
FROM
    orders o
        LEFT JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id , c.name;
 
-- 7. List the number of products sold per category
SELECT 
    category, COUNT(name) AS num_of_products
FROM
    products
GROUP BY category;

-- 8. Find the average item price per category
SELECT 
    category, avg(price) as avg_price
FROM
    products
GROUP BY category;

-- 9. Show number of orders placed per day
SELECT 
    DATE(order_date), COUNT(order_id) AS num_of_orders_per_day
FROM
    orders
GROUP BY DATE(order_date);

-- 10. List total payments received per payment method
SELECT 
    method, SUM(amount_paid) AS total_payment
FROM
    payments
GROUP BY method; 

 
 
-- ==================================================================
-- Level 4: Multi-Table Queries (JOINS)
-- ===================================================================
 
 
-- 1. Retrieve order details along with the customer name (INNER JOIN) 
SELECT 
    o.order_id,
    c.customer_id,
    c.name AS customer_name,
    o.order_date,
    o.status,
    o.total_amount
FROM
    orders o
        INNER JOIN
    customers c ON o.customer_id = c.customer_id;
 
-- 2. Get list of products that have been sold (INNER JOIN with order_items)
SELECT 
    o.product_id,
    p.name,
    SUM(o.quantity) AS toatl_qunatity,
    SUM(o.item_price) AS total_price
FROM
    order_items o
        INNER JOIN
    products p ON o.product_id = p.product_id
GROUP BY o.product_id , p.name;

-- 3. List all orders with their payment method (INNER JOIN)
SELECT 
    o.order_id, p.method
FROM
    orders o
        INNER JOIN
    payments p ON o.order_id = p.order_id;

-- 4. Get list of customers and their orders (LEFT JOIN)
SELECT 
    c.customer_id, c.name, o.order_id
FROM
    customers c
        LEFT JOIN
    orders o ON c.customer_id = o.customer_id;
    
-- 5. List all products along with order item quantity (LEFT JOIN)
SELECT 
    p.name AS product_name,
    SUM(o.quantity) AS toal_quantity_ordered
FROM
    products p
        LEFT JOIN
    order_items o ON p.product_id = o.product_id
GROUP BY p.name;

-- 6. List all payments including those with no matching orders (RIGHT JOIN)
SELECT 
    o.order_id, p.payment_id, p.amount_paid, p.method
FROM
    orders o
        RIGHT JOIN
    payments p ON o.order_id = p.order_id;

-- 7. Combine data from three tables: customer, order, and payment 
SELECT 
    c.customer_id,
    c.name,
    o.order_id,
    p.payment_id,
    p.amount_paid,
    p.method
FROM
    customers c
        RIGHT JOIN
    orders o ON c.customer_id = o.customer_id
        RIGHT JOIN
    payments p ON o.order_id = p.order_id;


-- ==================================================================
-- Level 5: Subqueries (Inner Queries)
-- ===================================================================
 
-- 1. List all products priced above the average product price
SELECT 
    *
FROM
    products
WHERE
    price > (SELECT 
            AVG(price)
        FROM
            products);

-- 2. Find customers who have placed at least one order
SELECT 
    customer_id, COUNT(order_id) AS num_of_orders
FROM
    orders
GROUP BY customer_id
HAVING COUNT(order_id) >= 1;

-- 3. Show orders whose total amount is above the average for that customer
SELECT 
    *
FROM
    orders o
WHERE
    o.total_amount > (SELECT 
            AVG(o2.total_amount)
        FROM
            orders o2
        WHERE
            o2.customer_id = o.customer_id);

-- 4. Display customers who haven’t placed any orders
SELECT 
    customer_id, name
FROM
    customers
WHERE
    customer_id NOT IN (SELECT 
            customer_id
        FROM
            orders);

-- 5. Show products that were never ordered
SELECT 
    product_id, name
FROM
    products
WHERE
    product_id NOT IN (SELECT 
            product_id
        FROM
            order_items); 
 
-- 6. Show highest value order per customer
SELECT 
    o.customer_id, o.order_id, o.total_amount
FROM
    orders o
WHERE
    o.total_amount = (SELECT 
            MAX(o2.total_amount)
        FROM
            orders o2
        WHERE
            o2.customer_id = o.customer_id);

-- 7. Highest Order Per Customer (Including Names)
SELECT 
    c.customer_id, c.name, o.order_id, o.total_amount
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
WHERE
    o.total_amount = (SELECT 
            MAX(o2.total_amount)
        FROM
            orders o2
        WHERE
            o2.customer_id = o.customer_id);


-- ==================================================================
-- Level 6: Set Operations
-- ===================================================================


-- 1. List all customers who have either placed an order or written a product review
SELECT customer_id
FROM orders

UNION

SELECT customer_id
FROM product_reviews;

-- 2. List all customers who have placed an order as well as reviewed a product 
SELECT DISTINCT
    o.customer_id
FROM
    orders o
        JOIN
    product_reviews r ON o.customer_id = r.customer_id;






USE operations;
Select * from inventory;

-- Products with its inventory quantity 
Select p.product_id, p.product_name, p.category, i.quantity_on_hand 
from products p
lEFT JOIN inventory i 
ON p.product_id = i.product_id 
ORDER BY i.quantity_on_hand DESC;

-- Product below their reorder level 
Select p.product_id, p.product_name, p.category,p.reorder_level, i.quantity_on_hand,
 (p.reorder_level - i.quantity_on_hand) AS "Unit Below Level" 
from products p
lEFT JOIN inventory i 
ON p.product_id = i.product_id 
WHERE p.reorder_level > i.quantity_on_hand
ORDER BY i.quantity_on_hand DESC;

-- count of customers Status 
WITH orderstatus AS(
Select customer_id,
order_date,
shipped_date,
status 
From sales_orders
)
Select count(*) as Number_of_services  from orderstatus where status = "Pending";

-- Shipped Customers Orders 
Select customer_id, order_date, shipped_date from sales_orders
WHERE status = "Shipped";

-- Pending Customers Orders 
Select Sales_order_id, customer_id, order_date from sales_orders
WHERE status = "Pending";

-- Total inventory value
Select product_name, category, unit_cost,quantity_on_hand, 
format((unit_cost*quantity_on_hand),'C','en-GB') AS inventory_value from products p
lEFT JOIN inventory i 
ON p.product_id = i.product_id;

-- Top 3 customers by revenue 

WITH customerinfo AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        FORMAT(SUM(so.quantity * so.selling_price),-2) AS total_sales,
        ROW_NUMBER() OVER (ORDER BY FORMAT(SUM(so.quantity * so.selling_price),-2)  DESC) AS Ranking 
    FROM customers c
    JOIN sales_orders s
        ON c.customer_id = s.customer_id
    JOIN sales_order_items so
        ON s.sales_order_id = so.sales_order_id
    GROUP BY
        c.customer_id,
        c.customer_name,
        c.city
)

SELECT *
FROM customerinfo
Order by total_sales DESC
LIMIT 3;


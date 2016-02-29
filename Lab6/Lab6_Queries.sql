-- Lab 6:  Interesting and Painful Queries
-- Author: Graham Burek


-- 1. Display the name and city of customers who live in any city that makes the most
-- different kinds of products. (There are two cities that make the most different 
-- products. Return the name and city of customers from either one of those.)

SELECT c.name, c.city
FROM customers c
WHERE c.city IN (SELECT p.city
                 FROM products p
                 GROUP BY p.city
                 HAVING count(p.city) = (SELECT count(city) AS ctyCount
                                        FROM products p
                                        GROUP BY p.city
                                        ORDER BY ctyCount DESC
                                        LIMIT 1 )
                );


-- 2. Display the names of products whose priceUSD is strictly above the average priceUSD, 
-- in reverse-alphabetical order. 

SELECT name
FROM products
WHERE priceusd > (SELECT avg(priceusd)
                  FROM products
                 )
ORDER BY name DESC;

-- 3. Display the customer name, pid ordered, and the total for all orders, sorted by total 
-- from high to low.         
-- This query shows customer name, a product pid they ordered, and the total for all the orders of this product that
-- customer made (not sure if this is the query you are looking for).

SELECT customers.name, pid, sum(totalusd) AS totalProductAmount
FROM orders INNER JOIN customers ON orders.cid = customers.cid
GROUP BY  customers.name, pid
ORDER BY  totalProductAmount DESC;

-- Alternatively, this query shows the totalUSD, name, pid for all the customers:

SELECT customers.name, pid, totalUSD
FROM   customers INNER JOIN orders ON customers.cid = orders.cid
ORDER BY totalUSD DESC;

-- 4. Display all customer names (in alphabetical order) and their total ordered, and 
-- nothing more. Use coalesce to avoid showing NULLs.

SELECT name, COALESCE(sum(qty), 0) AS qtyBought
FROM customers LEFT OUTER JOIN orders ON orders.cid = customers.cid
GROUP BY name
ORDER BY name ASC;

-- 5. Display the names of all customers who bought products from agents based in Tokyo
-- along with the names of the products they ordered, and the names of the agents who 
-- sold it to them.

SELECT c.name, p.name, a.name
FROM   customers c INNER JOIN orders o   ON o.cid = c.cid
                   INNER JOIN products p ON o.pid = p.pid
                   INNER JOIN agents a   ON o.aid = a.aid
WHERE a.city = 'Tokyo';


-- 6. Write a query to check the accuracy of the dollars column in the Orders table. This 
-- means calculating Orders.totalUSD from data in other tables and comparing those 
-- values to the values in Orders.totalUSD. Display all rows in Orders where 
-- Orders.totalUSD is incorrect, if any. 

SELECT *
FROM orders o INNER JOIN products p ON o.pid = p.pid
              INNER JOIN customers c ON o.cid = c.cid
WHERE totalusd != qty * p.priceUSD * (1 - (discount / 100));

-- 7. What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give 
-- example queries in SQL to demonstrate. (Feel free to use the CAP2 database to make 
-- your points here.)

-- A LEFT OUTER JOIN will join two tables together based on a relationship between column in each table, with the condition that every row in the left table is displayed, regardless of relation. If a row in the left table
-- has no corresponding row in the right table, the right tables values will be filled with null values. For example, the following query displays Weyland, a customer who has made no orders, because Weyland is a row in the left table:

SELECT * 
FROM customers LEFT OUTER JOIN orders ON customers.cid = orders.cid;

-- A RIGHT OUTER JOIN, on the other hand, acts the same as a LEFT OUTER JOIN, except it displays all the rows in the right table. 
-- For example, this RIGHT OUTER JOIN excludes Weyland, since he made no orders (all orders can be shown without including Weyland): 

SELECT * 
FROM customers RIGHT OUTER JOIN orders ON customers.cid = orders.cid;
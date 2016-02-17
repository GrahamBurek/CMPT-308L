-- Lab 5 Queries. Author: Graham Burek 
-- 1. Show the cities of agents booking an order for a customer whose id is 'c002'. Use joins; no subqueries. 

SELECT city
FROM   agents a INNER JOIN orders o ON o.aid = a.aid
WHERE  cid = 'c002'; 

-- 2. Show the ids of products ordered through any agent who makes at least one order for 
-- a customer in Dallas, sorted by pid from highest to lowest. Use joins; no subqueries.

SELECT DISTINCT p.pid
FROM products p INNER JOIN orders o ON o.pid = p.pid
                INNER JOIN customers c ON o.cid = c.cid
WHERE c.city = 'Dallas'
ORDER BY p.pid DESC;   

 -- 3. Show the names of customers who have never placed an order. Use a subquery. 

SELECT name
FROM   customers c
WHERE  c.cid NOT IN (SELECT cid 
                      FROM   orders
                     );

 -- 4. Show the names of customers who have never placed an order. Use an outer join. 

SELECT name
FROM   customers c LEFT OUTER JOIN orders o ON o.cid = c.cid
WHERE  ordnum IS NULL;

-- 5. Show the names of customers who placed at least one order through an agent in their 
-- own city, along with those agent(s') names.

SELECT DISTINCT c.name, a.name
FROM   customers c INNER JOIN orders o ON o.cid = c.cid
                   INNER JOIN agents a ON o.aid = a.aid
WHERE  c.city = a.city;

-- 6. Show the names of customers and agents living in the same city, along with the name 
-- of the shared city, regardless of whether or not the customer has ever placed an order 
-- -- with that agent. 

SELECT c.name, a.name, c.city 
FROM customers c FULL OUTER JOIN agents a ON c.city = a.city
WHERE c.city IS NOT NULL
AND   a.city IS NOT NULL;

-- 7. Show the name and city of customers who live in the city that makes the fewest
-- different kinds of products. (Hint: Use count and group by on the Products table.)
-- Side note: Why?


SELECT name, city
FROM   customers
WHERE  city IN (SELECT city 
                FROM   products             
                GROUP BY city
                HAVING count(city) = (SELECT min(fewest)
                                      FROM   (SELECT count(city) AS fewest
                                              FROM   products
                                              GROUP BY city
                                             )AS     countCity
                                    )
               );
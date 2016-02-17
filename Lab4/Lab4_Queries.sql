-- Lab 4 Queries, Graham Burek

-- 1. Get the cities of agents booking an order for a customer whose cid is 'c002'. 

SELECT city
FROM agents
WHERE aid IN (SELECT aid
              FROM   orders
              WHERE  cid = 'c002'
             ); 

-- 2. Get the ids of products ordered through any agent who takes at least one order from a customer in Dallas, sorted by pid from highest to lowest. 
-- (This is not the same as asking for ids of products ordered by customers in Dallas.)

SELECT DISTINCT pid
FROM   orders
WHERE  aid IN (SELECT aid
               FROM   orders
               WHERE  cid IN (SELECT cid
                              FROM   customers
                              WHERE  city = 'Dallas'
                              )
               )
ORDER BY pid DESC;

-- 3. Get the ids and names of customers who did not place an order through agent a01. 

SELECT cid, name
FROM   customers
WHERE  cid NOT IN (SELECT cid
                   FROM   orders
                   WHERE  aid = 'a01');

-- 4. Get the ids of customers who ordered both product p01 and p07.

SELECT cid
FROM   customers
WHERE  cid IN (SELECT cid
               FROM   orders
               WHERE  pid = 'p01'
              ) 
               AND cid IN (SELECT cid
                           FROM   orders
                           WHERE  pid = 'p07'
                          );

-- 5. Get the ids of products not ordered by any customers who placed any order through agent a07 in pid order from highest to lowest.
-- Since agent a07 does not exist in the database, the query returns all the products in the database.

SELECT pid
FROM   products
WHERE  pid NOT IN (SELECT pid
                   FROM   orders
                   WHERE  aid = 'a07'
                  )
ORDER BY pid DESC; 

-- 6. Get the name, discounts, and city for all customers who place orders through agents in London or New York.

SELECT name, discount, city
FROM   customers
WHERE  cid IN (SELECT cid
               FROM   orders
               WHERE  aid IN (SELECT aid
                              FROM   agents
                              WHERE  city IN ('New York', 'London')
                              )
              ); 

-- 7. Get all customers who have the same discount as that of any customers in Dallas or London
-- Since there are no other customers with the same discount, the query only returns the customers in Dallas or London

SELECT *
FROM   customers
WHERE  discount IN (SELECT discount
FROM   customers
                    WHERE  city IN ('Dallas', 'London')
                   );
--Problem Statement: Identify users who started a session and placed an order on the same day. For these users, calculate the total number of orders and the total order value for that day.

--Your output should include the user, the session date, the total number of orders, and the total order value for that day.

--Here are the top three reasons for performing this analysis:

--Understand User Behavior Patterns: Identifies customers who browse and purchase on the same day, revealing decisive purchasing behavior and informing strategies for instant conversions.
--Evaluate Marketing Effectiveness: Assesses whether specific campaigns or promotions encourage immediate purchases, allowing marketers to optimize strategies that drive same-day conversions.
--Boost Sales Strategies: Pinpoints high-conversion days, enabling targeted sales and discount tactics that maximize immediate purchase opportunities.

CREATE TABLE sessions2 (
    session_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    session_date DATETIME NOT NULL
);

INSERT INTO sessions2 (session_id, user_id, session_date) VALUES
(1, 1, '2024-01-01 00:00:00'),
(2, 2, '2024-01-02 00:00:00'),
(3, 3, '2024-01-05 00:00:00'),
(4, 3, '2024-01-05 00:00:00'),
(5, 4, '2024-01-03 00:00:00'),
(6, 4, '2024-01-03 00:00:00'),
(7, 5, '2024-01-04 00:00:00'),
(8, 5, '2024-01-04 00:00:00'),
(9, 3, '2024-01-05 00:00:00'),
(10, 5, '2024-01-04 00:00:00');


CREATE TABLE order_summary2 (
    order_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    order_value DECIMAL(10, 2) NOT NULL,
    order_date DATETIME NOT NULL
);

INSERT INTO order_summary2 (order_id, user_id, order_value, order_date) VALUES
(1, 1, 152, '2024-01-01 00:00:00'),
(2, 2, 485, '2024-01-02 00:00:00'),
(3, 3, 398, '2024-01-05 00:00:00'),
(4, 3, 320, '2024-01-05 00:00:00'),
(5, 4, 156, '2024-01-03 00:00:00'),
(6, 4, 121, '2024-01-03 00:00:00'),
(7, 5, 238, '2024-01-04 00:00:00'),
(8, 5, 70, '2024-01-04 00:00:00'),
(9, 3, 152, '2024-01-05 00:00:00'),
(10, 5, 171, '2024-01-04 00:00:00');

SELECT * FROM Sessions2;

SELECT * FROM order_summary2;

--Answer:
SELECT 
    s.user_id, 
    CAST(s.session_date AS DATE) AS session_date, 
    COUNT(o.order_id) AS total_orders, 
    SUM(o.order_value) AS total_order_value
FROM sessions2 s
JOIN order_summary2 o 
    ON s.user_id = o.user_id 
    AND CAST(s.session_date AS DATE) = CAST(o.order_date AS DATE)
GROUP BY s.user_id, CAST(s.session_date AS DATE)
HAVING COUNT(o.order_id) > 0
ORDER BY s.user_id, session_date;

-- Above query will make Cartesian Multiplication Due to JOIN
-------If a user has multiple session entries and multiple orders on the same day, each order gets duplicated per session, leading to overcounting.

--To fix this, we should remove duplicate session entries per user per date before performing the aggregation.

WITH unique_sessions AS (
    SELECT DISTINCT user_id, CAST(session_date AS DATE) AS session_date
    FROM sessions
)
SELECT 
    s.user_id, 
    s.session_date, 
    COUNT(o.order_id) AS total_orders, 
    SUM(o.order_value) AS total_order_value
FROM unique_sessions s
JOIN order_summary o 
    ON s.user_id = o.user_id 
    AND s.session_date = CAST(o.order_date AS DATE)
GROUP BY s.user_id, s.session_date
ORDER BY s.user_id, s.session_date;

-----------------------------------------------------------------------------------------------------------------
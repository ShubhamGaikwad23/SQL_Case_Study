
/* ✅ 1. video_calls — Main call metadata*/
CREATE TABLE video_calls (
    call_id INT PRIMARY KEY,
    user_id INT,
    start_time DATETIME,
    end_time DATETIME,
    call_type VARCHAR(10),        -- 'group' or '1on1'
    call_status VARCHAR(20)       -- 'completed', 'dropped', 'no_answer'
);

INSERT INTO video_calls (call_id, user_id, start_time, end_time, call_type, call_status)
VALUES
(1, 101, '2025-04-28 10:00:00', '2025-04-28 10:25:00', 'group', 'completed'),
(2, 102, '2025-04-28 11:00:00', '2025-04-28 11:03:00', 'group', 'dropped'),
(3, 103, '2025-04-29 09:00:00', '2025-04-29 09:45:00', '1on1', 'completed'),
(4, 104, '2025-04-30 12:00:00', '2025-04-30 12:00:30', 'group', 'dropped'),
(5, 101, '2025-04-30 14:00:00', '2025-04-30 14:10:00', 'group', 'completed');

/* ✅ 2. call_participants — Users in each call */
CREATE TABLE call_participants (
    call_id INT,
    participant_id INT,
    join_time DATETIME,
    leave_time DATETIME
);

INSERT INTO call_participants (call_id, participant_id, join_time, leave_time)
VALUES
(1, 101, '2025-04-28 10:00:00', '2025-04-28 10:25:00'),
(1, 201, '2025-04-28 10:01:00', '2025-04-28 10:24:00'),
(1, 202, '2025-04-28 10:02:00', '2025-04-28 10:20:00'),
(2, 102, '2025-04-28 11:00:00', '2025-04-28 11:03:00'),
(4, 104, '2025-04-30 12:00:00', '2025-04-30 12:00:30'),
(5, 101, '2025-04-30 14:00:00', '2025-04-30 14:10:00'),
(5, 203, '2025-04-30 14:01:00', '2025-04-30 14:08:00');

/* ✅ 3. users — User profile metadata */
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    signup_date DATE,
    country VARCHAR(50)
);

INSERT INTO users (user_id, signup_date, country)
VALUES
(101, '2024-01-10', 'USA'),
(102, '2024-03-05', 'Canada'),
(103, '2023-12-25', 'India'),
(104, '2024-02-20', 'USA'),
(201, '2024-04-01', 'UK'),
(202, '2023-11-11', 'USA'),
(203, '2024-05-01', 'Germany');

SELECT * FROM video_calls;

SELECT * FROM call_participants;

SELECT * FROM users;

/* ✅ 1. Average Duration of Completed Group Calls in Last 7 Days */

SELECT 
  ROUND(AVG(DATEDIFF(SECOND, start_time, end_time)) / 60.0, 2) AS avg_duration_minutes
FROM video_calls
WHERE call_type = 'group'
  AND call_status = 'completed'
  AND start_time >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE));

/* ✅ 2. User Who Hosted the Most Group Calls Last Month */

SELECT TOP 1 user_id, COUNT(*) AS call_count
FROM video_calls
WHERE call_type = 'group'
  AND start_time >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
  AND start_time < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
GROUP BY user_id
ORDER BY call_count DESC;

/* ✅ 3. Dropout Rate (Call Duration < 1 Minute) */

SELECT 
  CAST(SUM(CASE WHEN DATEDIFF(SECOND, start_time, end_time) < 60 THEN 1 ELSE 0 END) AS FLOAT) / 
  COUNT(*) AS dropout_rate
FROM video_calls
WHERE call_type = 'group'
  AND call_status = 'dropped';

--------------------------------------------------------------------------------------------------
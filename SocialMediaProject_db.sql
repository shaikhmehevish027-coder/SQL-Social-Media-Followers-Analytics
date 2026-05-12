CREATE DATABASE SocialMediaAnalytics;
USE SocialMediaAnalytics;

CREATE TABLE Users(user_id INT PRIMARY KEY, username VARCHAR(50), join_date DATE);

CREATE TABLE Followers(follower_id INT, user_id INT, follow_date DATE, PRIMARY KEY (follower_id, user_id), FOREIGN KEY (user_id) REFERENCES Users(user_id));

CREATE TABLE Posts(post_id INT PRIMARY KEY, user_id INT, post_date DATE, FOREIGN KEY (user_id) REFERENCES Users(user_id));

CREATE TABLE Engagement(engagement_id INT PRIMARY KEY, post_id INT, likes INT, comments INT, shares INT, FOREIGN KEY (post_id) REFERENCES Posts(post_id));

INSERT INTO Users VALUES
(1, 'Ayesha', '2024-01-01'),
(2, 'Rahul', '2024-02-15'),
(3, 'Zara', '2024-03-10'),
(4, 'Ali', '2024-06-01');  -- Inactive user
SELECT * FROM Users;

INSERT INTO Followers VALUES
(101, 1, '2024-04-01'),
(102, 1, '2024-04-05'),
(103, 2, '2024-04-07'),
(104, 3, '2024-04-10'),
(105, 1, '2024-04-12');
SELECT * FROM Followers;

INSERT INTO Posts VALUES
(1, 1, '2024-05-01'),
(2, 1, '2024-05-05'),
(3, 2, '2024-05-07'),
(4, 3, '2024-05-08');
SELECT * FROM Posts;
-- Note: Ali has NO posts → inactive

INSERT INTO Engagement VALUES
(1, 1, 100, 20, 10),
(2, 2, 150, 30, 20),
(3, 3, 80, 10, 5),
(4, 4, 200, 40, 25);
SELECT * FROM Engagement;

-- 1. Total Followers per User.
SELECT user.username, COUNT(follower.follower_id) AS total_followers
FROM Users user
LEFT JOIN Followers follower ON user.user_id = follower.user_id
GROUP BY user.username;

-- 2. Monthly Followers Growth.
SELECT DATE_FORMAT(follow_date, '%Y-%m') AS month,
COUNT(*) AS new_followers FROM Followers
GROUP BY month ORDER BY month;

-- 3. Top Performing Posts.
SELECT post.post_id, user.username,(engagement.likes + engagement.comments + engagement.shares) AS total_engagement
FROM Posts post
JOIN Engagement engagement ON post.post_id = engagement.post_id
JOIN Users user ON post.user_id = user.user_id
ORDER BY total_engagement DESC;

-- 4. Most Active User.
SELECT user.username, COUNT(post.post_id) AS total_posts
FROM Users user
JOIN Posts post ON user.user_id = post.user_id
GROUP BY user.username
ORDER BY total_posts DESC;

-- 5. Average Engagement per User.
SELECT user.username, AVG(engagement.likes + engagement.comments + engagement.shares) AS avg_engagement
FROM Users user
JOIN Posts post ON user.user_id = post.user_id
JOIN Engagement engagement ON post.post_id = engagement.post_id
GROUP BY user.username;

-- 6. User with Highest Followers.
SELECT user.username, COUNT(follower.follower_id) AS followers
FROM Users user
JOIN Followers follower ON user.user_id = follower.user_id
GROUP BY user.username
ORDER BY followers DESC
LIMIT 1;

-- 7. Active vs Inactive Users.
SELECT user.username,
IF(COUNT(post.post_id) > 0, 'Active', 'Inactive') AS status
FROM Users user
LEFT JOIN Posts post ON user.user_id = post.user_id
GROUP BY user.username;


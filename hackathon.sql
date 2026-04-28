CREATE DATABASE Test;
USE Test;

CREATE TABLE Users (
	user_id VARCHAR(5) PRIMARY KEY NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    join_date DATE NOT NULL
);
CREATE TABLE Auction_Items (
	item_id VARCHAR(5) PRIMARY KEY NOT NULL,
    item_name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50) NOT NULL UNIQUE,
    start_price DECIMAL(15,2) NOT NULL,
    end_time DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL
);
CREATE TABLE Bids (
	bid_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    item_id VARCHAR(5) NOT NULL,
    user_id VARCHAR(5) NOT NULL,
    bid_amount DECIMAL(15,2) NOT NULL,
    bid_time DATETIME NOT NULL,
    FOREIGN KEY (item_id) REFERENCES Auction_Items(item_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
CREATE TABLE Winners (
	winner_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    item_id VARCHAR(5) NOT NULL UNIQUE,
    user_id VARCHAR(5) NOT NULL,
    final_price DECIMAL(15,2) NOT NULL,
    win_date DATE NOT NULL,
    FOREIGN KEY (item_id) REFERENCES Auction_Items(item_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Users(user_id,full_name,email,phone,account_type,join_date)
VALUES 
('U01', 'Nguyễn Anh Quân', 'quan.na@gmail.com', '0912345678', 'Premium', '2025-01-10'),
('U02', 'Trần Minh Tú', 'tu.tm@gmail.com', '0987654321', 'Standard', '2025-02-15'),
('U03', 'Lê Thu Thủy', 'thuy.lt@gmail.com', '0978123456', 'Premium', '2025-03-20'),
('U04', 'Phạm Gia Bảo', 'bao.pg@gmail.com', '0909876543', 'Standard', '2025-04-12');

INSERT INTO Auction_Items(item_id,item_name,category,start_price,end_time,status)
VALUES 
('I01', 'Rolex Datejust 1970', 'Jewelry', 50000000, '2025-11-20 20:00:00', 'Active'),
('I02', 'Tranh sơn dầu Phố Cổ', 'Art', 15000000, '2025-11-21 18:00:00', 'Active'),
('I03', 'Macbook Pro M3 Max', 'Tech', 35000000, '2025-11-15 10:00:00', 'Closed'),
('I04', 'Rượu vang đỏ 1990', 'Collectible', 10000000, '2025-12-05 21:00:00', 'Active');

INSERT INTO Bids(bid_id,item_id,user_id,bid_amount,bid_time)
VALUES 
(1, 'I01', 'U01', 55000000, '2025-11-10 09:00:00'),
(2, 'I02', 'U02', 16000000, '2025-11-10 10:30:00'),
(3, 'I01', 'U03', 60000000, '2025-11-11 14:00:00'),
(4, 'I03', 'U04', 36000000, '2025-11-12 08:00:00'),
(5, 'I02', 'U01', 17500000, '2025-11-12 15:20:00');

UPDATE Auction_Items
SET start_price = start_price * 1.15
WHERE item_id = 'I01';

UPDATE Users
SET account_type = 'VIP'
WHERE user_id = 'U02';

DELETE FROM Bids
WHERE bid_amount < 15000000;

ALTER TABLE Bids
ADD CONSTRAINT bid_amount CHECK(bid_amount > 0);

ALTER TABLE Auction_Items
MODIFY status VARCHAR(20) DEFAULT 'Active';

ALTER TABLE Users
ADD location VARCHAR(100);


SELECT item_id,item_name,category,start_price,end_time,status
FROM Auction_Items
WHERE category IN ('Tech','Jewelry');

SELECT full_name,email
FROM Users
WHERE full_name LIKE '%a%';

SELECT item_id,item_name,end_time
FROM Auction_Items
ORDER BY end_time ASC;

SELECT item_id,item_name,category,start_price,end_time,status
FROM Auction_Items
ORDER BY end_time DESC
LIMIT 3;

SELECT item_name,category
FROM Auction_Items
LIMIT 2 OFFSET 1;

UPDATE Auction_Items
SET start_price = start_price * 0.9
WHERE hour(end_time) < 12;


SELECT lower(full_name) AS low_full_name
FROM Users;

DELETE FROM Auction_Items
WHERE status = 'Canceled';

SELECT b.bid_id,u.full_name,a.item_name,b.bid_amount 
FROM Bids b
JOIN Users u
ON b.user_id = u.user_id
JOIN Auction_Items a
ON b.item_id = a.item_id
WHERE a.status = 'Active';

SELECT a.item_name,b.user_id
FROM Auction_Items a
LEFT JOIN Bids b
ON b.item_id = a.item_id ;

SELECT item_id,sum(bid_amount) AS Total_bid_amount
FROM Bids
GROUP BY item_id;

SELECT u.user_id,u.full_name, count(b.item_id) AS item_count
FROM Users u
JOIN Bids b
ON b.user_id = u.user_id
GROUP BY u.user_id
HAVING item_count >= 2;

SELECT bid_id,item_id,user_id,bid_amount,bid_time
FROM Bids
WHERE bid_amount < (SELECT avg(bid_amount)
					FROM Bids            );

SELECT u.full_name,u.account_type 
FROM Users u
JOIN Bids b
ON b.user_id = u.user_id
JOIN Auction_Items a
ON b.item_id = a.item_id
WHERE a.item_name = '%Rolex Datejust 1970%';


SELECT item_id,item_name,category,start_price,end_time,status
FROM Auction_Items
WHERE month(end_time) = 11 AND year(end_time) = 2025;
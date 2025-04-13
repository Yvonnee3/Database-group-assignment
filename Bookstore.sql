-- Initialize the bookstore database
CREATE DATABASE Bookstore;

-- bookstore tables
CREATE TABLE book (
    book_id INT PRIMARY KEY,
    title VARCHAR(250),
    language_id INT,
    price DECIMAL(10 , 2 ),
    publisher_id INT,
    FOREIGN KEY (language_id)
        REFERENCES book_language (language_id),
    CONSTRAINT publisher_id FOREIGN KEY (publisher_id)
        REFERENCES publisher (publisher_id)
);

-- Inser into book table
INSERT INTO book (book_id, title, publisher_id, language_id, price)
VALUES
(1, 'Things Fall Apart', 1, 1, 1500.00),
(2, 'The River Between', 3, 2, 1300.00),
(3, 'The River and  The Source', 3, 1, 1000.00),
(4, 'The Voice of Africa', 2, 2, 1300.00),
(5, 'Angels Never Die', 1, 2, 1380.00),
(6, 'The Fallen Kingdom', 2, 1, 1200.00),
(7, 'The Pearl', 1, 2, 1350.00),
(8, 'Harry Potter', 2, 1, 2000.00);

CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(100)
);

-- Insert into book language table
INSERT INTO book_language (language_id, language_name)
VALUES
(1, 'English'),
(2, 'Swahili');

CREATE TABLE publisher(
publisher_id INT AUTO_INCREMENT PRIMARY KEY,
publisher_name VARCHAR(100)
);

-- Insert data into publisher table
INSERT INTO publisher (publisher_id, publisher_name)
VALUES
(1, 'Oxford'),
(2, 'MaccMillan'),
(3, 'Longhorn');

CREATE TABLE author(
author_id INT AUTO_INCREMENT PRIMARY KEY,
book_id INT,
first_name VARCHAR(50),
last_name VARCHAR(50),
FOREIGN KEY (book_id) REFERENCES book(book_id)
);

INSERT INTO author (book_id, first_name, last_name)
VALUES
(1, 'Chinua', 'Achebe'),
(2, 'Ngugi', 'wa Thiong\'o'),
(3, 'J.K.', 'Rowling'),
(4, 'George', 'Orwell'),
(5, 'Harper', 'Lee'),
(6, 'F. Scott', 'Fitzgerald');


CREATE TABLE address(
address_id INT AUTO_INCREMENT PRIMARY KEY,
street VARCHAR(50),
city VARCHAR(50),
postal_code INT,
country_id INT,
FOREIGN KEY (country_id) REFERENCES country(country_id)
);

INSERT INTO address (address_id, street, city, postal_code, country_id)
VALUES
(1, '123 Moi Ave', 'Nairobi', '00100', 1),
(2, '45 Kimathi St', 'Kisumu', '40100', 1),
(3, '742 Evergreen Terrace', 'Springfield', '62704', 2);


CREATE TABLE country(
country_id INT AUTO_INCREMENT PRIMARY KEY,
country_name VARCHAR(50)
);

INSERT INTO country (country_id, country_name)
VALUES
(1, 'Kenya'),
(2, 'Tanzania'),
(3, 'South Africa');

CREATE TABLE customer(
customer_id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email_address VARCHAR(55)
);
INSERT INTO customer (customer_id, first_name, last_name, email_address)
VALUES
(1, 'Alice', 'Otieno', 'alice@gmail.com'),
(2, 'John', 'Omondi', 'jo@gmail.com'),
(3, 'Jane', 'Beth', 'beth@gmail.com'),
(4, 'Mark', 'joe', 'joe@gmail.com'),
(5, 'Brian', 'Smith', 'brian@gmail.com'),
(6, 'Ann', 'jane', 'ann@gmail.com');

CREATE TABLE customer_address(
customer_id INT,
address_id INT,
address_status_id INT,
FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
FOREIGN KEY (address_id) REFERENCES address(address_id),
FOREIGN KEY (address_status_id) REFERENCES address_status(address_status_id)
);

INSERT INTO customer_address (customer_id, address_id, address_status_id)
VALUES
(1, 1, 1),
(2, 3, 2),
(3, 2, 2),
(4, 1, 2),
(5, 2, 2),
(6, 3, 1);


CREATE TABLE address_status(
address_status_id INT AUTO_INCREMENT PRIMARY KEY,
status_name VARCHAR(50)
);

INSERT INTO address_status (address_status_id, status_name)
VALUES
(1, 'Current'),
(2, 'Old');

CREATE TABLE customer_order(
order_id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT,
order_date DATE,
shipping_method_id INT,
order_status_id INT,
FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id)
);

INSERT INTO customer_order (order_id, customer_id, shipping_method_id, order_status_id, order_date)
VALUES
(1, 1, 1, 1, '2024-04-01'),
(2, 2, 2, 3, '2024-04-05'),
(3, 2, 2, 2, '2025-04-15');

CREATE TABLE order_status(
order_status_id INT AUTO_INCREMENT PRIMARY KEY,
status_name VARCHAR(50)
);

INSERT INTO order_status (order_status_id, status_name)
VALUES
(1, 'Pending'),
(2, 'Shipped'),
(3, 'Delivered');

CREATE TABLE order_history(
history_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT,
order_status_id INT,
order_date DATE,
FOREIGN KEY (order_id) REFERENCES customer_order(order_id),
FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id)
);
-- INSERT INTO order_history
INSERT INTO order_history (history_id, order_id, order_status_id, order_date)
VALUES
(1, 1, 1, '2024-04-01'),
(2, 1, 2, '2024-04-02'),
(3, 2, 1, '2024-04-05');

CREATE TABLE order_line(
order_id INT,
book_id INT,
quantity INT,
FOREIGN KEY (order_id) REFERENCES customer_order(order_id),
FOREIGN KEY (book_id) REFERENCES book(book_id)
);

INSERT INTO order_line (order_id, book_id, quantity)
VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 3);


CREATE TABLE shipping_method (
    shipping_method_id INT PRIMARY KEY AUTO_INCREMENT,
    shipping_method_name VARCHAR(50)
);

INSERT INTO shipping_method(shipping_method_id, shipping_method_name)
VALUES
(1, 'Road'),
(2, 'Railway'),
(3, 'online');

-- Create a user for staff with limited privileges
CREATE USER 'staff_user'@'localhost' IDENTIFIED BY 'Password123!';
GRANT SELECT, INSERT, UPDATE ON bookstore.* TO 'staff_user'@'localhost';

-- Create a read-only user for reporting
CREATE USER 'readonly_user'@'localhost' IDENTIFIED BY 'Password456!';
GRANT SELECT ON bookstore.* TO 'readonly_user'@'localhost';

-- Orders placed by a specific customer
SELECT co.order_id, co.order_date, os.status_name
FROM cust_order co
JOIN order_status os ON co.status_id = os.status_id
WHERE co.customer_id = 1;

-- Top 5 best-selling books
SELECT b.title, SUM(ol.quantity) AS total_sold
FROM book b
JOIN order_line ol ON b.book_id = ol.book_id
GROUP BY b.book_id
ORDER BY total_sold DESC
LIMIT 5;


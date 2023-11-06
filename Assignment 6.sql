
------------------------------------------------------
CREATE TABLE customers 
( 
customer_ID INT NOT NULL, 
customer_name VARCHAR(250), 
customer_email VARCHAR(250),
customer_location VARCHAR(250),
insert_date DATETIME DEFAULT CURRENT_DATE(),
PRIMARY KEY(customer_ID)
)

INSERT INTO customers ( customer_ID,customer_name,customer_email,customer_location) VALUES(1,'GAP','gap@gmail.com','USA');
INSERT INTO customers ( customer_ID,customer_name,customer_email,customer_location) VALUES(2,'AEO','aeo@gmail.com','USA');
INSERT INTO customers ( customer_ID,customer_name,customer_email,customer_location) VALUES(3,'M&S','m&s@gmail.com','USA');
INSERT INTO customers ( customer_ID,customer_name,customer_email,customer_location) VALUES(4,'ASDA','asda@gmail.com','USA');
INSERT INTO customers ( customer_ID,customer_name,customer_email,customer_location) VALUES(5,'WALMART','walmart@gmail.com','USA');



------------------------------------------------------
CREATE TABLE Categories 
(
category_ID INT NOT NULL,
category_name VARCHAR(250) NOT NULL, 
PRIMARY KEY(category_ID)
)

insert into Categories (category_ID,category_name) VALUES(1,'IT');
insert into Categories (category_ID,category_name) VALUES(2,'MFC');
insert into Categories (category_ID,category_name) VALUES(3,'ELECTRONICS');
insert into Categories (category_ID,category_name) VALUES(4,'OFFICE EQUIPMENT');



------------------------------------------------------
CREATE TABLE Products 
(
product_ID INT NOT NULL,
product_name VARCHAR(250) NOT NULL, 
product_description VARCHAR(500) NOT NULL, 
product_price DECIMAL NOT NULL,
category_ID INT NOT NULL,
PRIMARY KEY(product_ID),
FOREIGN KEY(category_ID) REFERENCES Categories (category_ID) 
)

insert into Products (product_ID,product_name, product_description, product_price,category_ID) VALUES(1,'HP LAPTOP','-',10,1);
insert into Products (product_ID,product_name, product_description, product_price,category_ID) VALUES(2,'DELL LAPTOP','-',20,1);
insert into Products (product_ID,product_name, product_description, product_price,category_ID) VALUES(3,'HP MONITOR','-',30,2);
insert into Products (product_ID,product_name, product_description, product_price,category_ID) VALUES(4,'DELL MONITOR','-',40,2);
insert into Products (product_ID,product_name, product_description, product_price,category_ID) VALUES(5,'HP TABLET','-',50,3);
insert into Products (product_ID,product_name, product_description, product_price,category_ID) VALUES(6,'DELL TABLET','-',60,3);
insert into Products (product_ID,product_name, product_description, product_price,category_ID) VALUES(7,'HP PRINTER','-',70,4);
insert into Products (product_ID,product_name, product_description, product_price,category_ID) VALUES(8,'DELL PRINTER','-',80,4);

-------------------------------------------------------------------
CREATE TABLE Orders 
(
order_ID INT NOT NULL,
customer_ID INT NOT NULL, 
order_date DATETIME NOT NULL DEFAULT CURRENT_DATE(), 
total_amount DECIMAL NOT NULL,
PRIMARY KEY(order_ID),
FOREIGN KEY(customer_ID) REFERENCES customers(customer_ID)
)

INSERT INTO Orders ( order_ID,customer_ID,order_date,total_amount) VALUES(1,1,CURRENT_DATE(),3000);
INSERT INTO Orders ( order_ID,customer_ID,order_date,total_amount) VALUES(2,1,CURRENT_DATE(),8000);
INSERT INTO Orders ( order_ID,customer_ID,order_date,total_amount) VALUES(3,2,CURRENT_DATE(),30000);
INSERT INTO Orders ( order_ID,customer_ID,order_date,total_amount) VALUES(4,2,CURRENT_DATE(),70);
INSERT INTO Orders ( order_ID,customer_ID,order_date,total_amount) VALUES(5,2,CURRENT_DATE(),80);


----------------------------------------
CREATE TABLE Order_Items 
(
order_item_ID INT NOT NULL,
order_ID INT NOT NULL,
product_ID INT NOT NULL, 
order_quantity INT NOT NULL, 
unit_price DECIMAL NOT NULL,
PRIMARY KEY(order_item_ID),
FOREIGN KEY(order_ID) REFERENCES Orders(order_ID), 
FOREIGN KEY(product_ID) REFERENCES Products(product_ID)
)

INSERT INTO order_items (order_item_ID,order_ID,product_ID, order_quantity, unit_price) VALUES(1001,1,1,100,10);
INSERT INTO order_items (order_item_ID,order_ID,product_ID, order_quantity, unit_price) VALUES(1002,1,2,100,20);

INSERT INTO order_items (order_item_ID,order_ID,product_ID, order_quantity, unit_price) VALUES(1003,2,1,200,10);
INSERT INTO order_items (order_item_ID,order_ID,product_ID, order_quantity, unit_price) VALUES(1004,2,2,300,20);

INSERT INTO order_items (order_item_ID,order_ID,product_ID, order_quantity, unit_price) VALUES(1005,3,1,1000,10);
INSERT INTO order_items (order_item_ID,order_ID,product_ID, order_quantity, unit_price) VALUES(1006,3,2,1000,20);


INSERT INTO order_items (order_item_ID,order_ID,product_ID, order_quantity, unit_price) VALUES(1007,4,7,1,70);

INSERT INTO order_items (order_item_ID,order_ID,product_ID, order_quantity, unit_price) VALUES(1008,5,8,1,80);



/* 
1.
Write a SQL query to retrieve all the customer information along with the total number of orders placed by each customer.  
Display the result in descending order of the number of orders.
*/

SELECT 
CUS.customer_ID,CUS.customer_name,CUS.customer_email,CUS.customer_location,
( SELECT COUNT(*) FROM orders ORD WHERE ORD.customer_ID=CUS.customer_ID  ) number_of_orders
FROM 
customers CUS
ORDER BY ( SELECT COUNT(*) FROM orders ORD WHERE ORD.customer_ID=CUS.customer_ID  ) DESC


/*
2.	Write a SQL query to retrieve the product name, quantity, and total amount for each order item. 
Display the result in ascending order of the order ID.
*/

SELECT 
P.product_name,
OI.order_quantity,
OI.order_quantity * OI.unit_price TOTAL_AMOUNT
FROM 
orders O,
order_items OI,
products P
WHERE
O.order_ID=OI.order_ID
AND OI.product_ID=P.product_ID
ORDER BY O.order_ID



/*
3.	Write a SQL query to retrieve the total revenue generated by each product category. 
Display the category name along with the total revenue in descending order of the revenue.
*/


SELECT 
CAT.category_name,
SUM(OI.order_quantity * OI.unit_price) TOTAL_REVENUE
FROM 
orders O,
order_items OI,
PRODUCTS P,
categories CAT
WHERE
O.order_ID=OI.order_ID
AND OI.product_ID=P.product_ID
AND P.category_ID=CAT.category_ID
GROUP BY CAT.category_name
ORDER BY SUM(OI.order_quantity * OI.unit_price) DESC




/*
4.	Write a SQL query to retrieve the top 5 customers who have made the highest total purchase amount. 
Display the customer name along with the total purchase amount in descending order of the purchase amount.
*/


/* OPTION -1 */

SELECT 
CUS.customer_name,
SUM(O.total_amount) total_purchase_amount
FROM 
orders O,
customers CUS
WHERE
O.customer_ID=CUS.customer_ID
GROUP BY CUS.customer_ID, CUS.customer_name
ORDER BY SUM(O.total_amount) DESC LIMIT 5


/* OPTION -2 */

SELECT 
CUS.customer_name,
SUM(OI.order_quantity * OI.unit_price) total_purchase_amount
FROM 
orders O,
order_items OI,
customers CUS
WHERE
O.order_ID=OI.order_ID
AND O.customer_ID=CUS.customer_ID
GROUP BY CUS.customer_ID, CUS.customer_name
ORDER BY SUM(OI.order_quantity * OI.unit_price) DESC  LIMIT 5




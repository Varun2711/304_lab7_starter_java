CREATE DATABASE orders;
go

USE orders;
go

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO category(categoryName) VALUES ('Motherboard');
INSERT INTO category(categoryName) VALUES ('Graphics Card');
INSERT INTO category(categoryName) VALUES ('Memory');
INSERT INTO category(categoryName) VALUES ('Power Supply');
INSERT INTO category(categoryName) VALUES ('CPU');
INSERT INTO category(categoryName) VALUES ('Tower CPU Cooler');

INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES 
('RTX 2060', 2, 'NVIDIA GeForce RTX 2060 GPU', 399.99),
('RTX 3060', 2, 'NVIDIA GeForce RTX 3060 GPU', 499.99),
('RTX 3060 Ti', 2, 'NVIDIA GeForce RTX 3060 Ti GPU', 549.99),
('RTX 4060', 2, 'NVIDIA GeForce RTX 4060 GPU', 599.99),
('RTX 4060 Ti', 2, 'NVIDIA GeForce RTX 4060 Ti GPU', 649.99),
('RTX 2070', 2, 'NVIDIA GeForce RTX 2070 GPU', 699.99),
('RTX 2070 S', 2, 'NVIDIA GeForce RTX 2070 Super GPU', 499.99),
('RTX 3070', 2, 'NVIDIA GeForce RTX 3070 GPU', 799.99),
('RTX 3070 Ti', 2, 'NVIDIA GeForce RTX 3070 Ti GPU', 849.99),
('i5 12400F', 5, 'Intel i5 12400F', 220),
('i7 7700', 5, 'Intel i7 7700', 550),
('i9 14900K', 5, 'Intel i9 14900K', 1000),
('i7 14700K', 5, 'Intel i7 14700K', 910),
('H610M', 1, 'H610M Motherboard', 99.99),
('B760M', 1, 'B760M Motherboard', 129.99),
('Z790', 1, 'Z790 Motherboard', 199.99),
('B660M', 1, 'B660M Motherboard', 149.99),
('8GB DDR4', 3, '8GB DDR4 Memory', 79.99),
('16GB DDR5', 3, '16GB DDR5 Memory', 129.99),
('32GB DDR6', 3, '32GB DDR6 Memory', 199.99),
('500W', 4, '500W Power Supply', 49.99),
('600W', 4, '600W Power Supply', 69.99),
('750W', 4, '750W Power Supply', 89.99),
('1000W', 4, '1000W Power Supply', 129.99),
('CR-1400', 6, 'Tower CPU Cooler CR-1400', 59.99),
('Hyper 212', 6, 'Tower CPU Cooler Hyper 212', 69.99),
('Noctua NH-D15', 6, 'Tower CPU Cooler Noctua NH-D15', 89.99),
('DeepCool AK620', 6, 'Tower CPU Cooler DeepCool AK620', 79.99);

UPDATE product SET productImageURL = 'img/2060.jpg' WHERE productId = 1;
UPDATE product SET productImageURL = 'img/3060.jpg' WHERE productId = 2;
UPDATE product SET productImageURL = 'img/3060ti.jpg' WHERE productId = 3;
UPDATE product SET productImageURL = 'img/4060.jpg' WHERE productId = 4;
UPDATE product SET productImageURL = 'img/4060ti.jpg' WHERE productId = 5;
UPDATE product SET productImageURL = 'img/2070.jpg' WHERE productId = 6;
UPDATE product SET productImageURL = 'img/2070S.jpg' WHERE productId = 7;
UPDATE product SET productImageURL = 'img/3070.jpg' WHERE productId = 8;
UPDATE product SET productImageURL = 'img/3070ti.jpg' WHERE productId = 9;

UPDATE product SET productImageURL = 'img/i5_12400F.jpg' WHERE productId = 10;
UPDATE product SET productImageURL = 'img/i7_7700.jpg' WHERE productId = 11;
UPDATE product SET productImageURL = 'img/i9_14900K.jpg' WHERE productId = 12;
UPDATE product SET productImageURL = 'img/i7_14700K.jpg' WHERE productId = 13;

UPDATE product SET productImageURL = 'img/H610M.jpg' WHERE productId = 14;
UPDATE product SET productImageURL = 'img/B760M.jpg' WHERE productId = 15;
UPDATE product SET productImageURL = 'img/Z790.jpg' WHERE productId = 16;
UPDATE product SET productImageURL = 'img/B660M.jpg' WHERE productId = 17;

UPDATE product SET productImageURL = 'img/8GB_DDR4.jpg' WHERE productId = 18;
UPDATE product SET productImageURL = 'img/16GB_DDR5.jpg' WHERE productId = 19;
UPDATE product SET productImageURL = 'img/32GB_DDR6.jpg' WHERE productId = 20;

UPDATE product SET productImageURL = 'img/500w_power_supply.jpg' WHERE productId = 21;
UPDATE product SET productImageURL = 'img/600w_power_supply.jpg' WHERE productId = 22;
UPDATE product SET productImageURL = 'img/750W_power_supply.jpg' WHERE productId = 23;
UPDATE product SET productImageURL = 'img/1000w_power_supply.jpg' WHERE productId = 24;

UPDATE product SET productImageURL = 'img/CR-1400_tower_cooler.jpg' WHERE productId = 25;
UPDATE product SET productImageURL = 'img/Hyper_212_tower_cooler.jpg' WHERE productId = 26;
UPDATE product SET productImageURL = 'img/Noctua_NH-D15_tower_cooler.jpg' WHERE productId = 27;
UPDATE product SET productImageURL = 'img/DeepCool_AK620_tower_cooler.jpg' WHERE productId = 28;



INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 399.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 499.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 549.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 599.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 649.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 699.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 499.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 0, 799.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 849.99);

INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 3, 220);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (11, 1, 5, 550);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (12, 1, 12, 1000);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (13, 1, 4, 910);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (14, 1, 7, 99.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (15, 1, 8, 129.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (16, 1, 2, 199.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (17, 1, 4, 149.99);

INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (18, 1, 7, 79.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (19, 1, 10, 129.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (20, 1, 14, 199.99);

INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (21, 1, 1, 49.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (22, 1, 4, 69.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (23, 1, 12, 89.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (24, 1, 14, 129.99);

INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (25, 1, 2, 59.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (26, 1, 8, 69.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (27, 1, 12, 89.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (28, 1, 14, 79.99);


INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , '304Arnold!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , '304Bobby!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , '304Candace!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , '304Darren!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , '304Beth!');

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);

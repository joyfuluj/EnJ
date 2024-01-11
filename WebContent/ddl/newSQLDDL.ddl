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
    AdminStatus         INT,
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
    productImageURL     VARCHAR(100) DEFAULT 'img/placeholder.jpg', 
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

INSERT INTO category(categoryName) VALUES ('ART');
INSERT INTO category(categoryName) VALUES ('Business');
INSERT INTO category(categoryName) VALUES ('Communication');
INSERT INTO category(categoryName) VALUES ('Education');
INSERT INTO category(categoryName) VALUES ('Health Care');
INSERT INTO category(categoryName) VALUES ('Hospitality');
INSERT INTO category(categoryName) VALUES ('Information technology');
INSERT INTO category(categoryName) VALUES ('Science');
INSERT INTO category(categoryName) VALUES ('Transportation');

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Actor', 1, 'a person whose profession is acting on the stage, in movies, or on television.',67.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Musician',1,'a person who plays a musical instrument, especially as a profession, or is musically talented.',77.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Graphic Designer',1,'a person create visual concepts to communicate information',46.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Finance Specialist', 2, 'an person who is responsible for the management of an organizations assets and liabilities, or on television.',104.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Accountant',2,'a professional who performs accounting functions such as account analysis, auditing, or financial statement analysis, or is musically talented.',112.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Lawyer',2,'a person who advises clients on legal matters in negotiations and mediations',82.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Journalist', 3, 'a person whose job is to collect news and write about it for newspapers, magazines, television, or radio',162.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Publisher',3,'a person or company that produces and sells books, magazines, newspapers, software, etc',177.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Broadcaster',3,'a person or thing that broadcasts',80.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Teacher', 4, 'a person who instructs or trains others, esp. in a school',35.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Librarian',4,'a person who focuses on user services, technical services, and administrative services',148.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('School Psychologist',4,'a person who uniquely qualified members of school teams that support students ability to learn and teachers ability to teach',70.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Physician', 5, 'a person who maintains, promotes, and restores health by studying, diagnosing, and treating injuries and diseases',190.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nurse',5,'a person who cares for the sick or infirm',109.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Barista', 6, 'a person, usually a coffeehouse employee, who prepares and serves espresso-based coffee drinks, and often teas as well.',23.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Server',6,'a person who takes orders, answers questions about the menu and food, sells the restaurants food and drinks, takes payment, communicates orders with customers',32.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Chef',6,'ta professional cook and tradesman who is proficient in all aspects of food preparation, often focusing on a particular cuisine',25.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Hotel Manager',6,'a person who is an experienced professional responsible for overseeing the daily operations of a hotel, ensuring efficient management, and providing strategic direction',32.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Data Analyst', 7, 'a person who gathers, cleans, and studies data sets to help solve problems',103.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Software Engineer',7,'a person who applies the engineering design process to design, develop, test, maintain, and evaluate computer software',198.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Chemist', 8, 'an expert in chemistry. A person engaged in chemical research or experiments.',56.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Biologist',8,'an expert in or student of the branch of science concerning living organisms.',133.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Data Scientist',8,'a person employed to analyze and interpret complex digital data, such as the usage statistics of a website, especially in order to assist a business in its decision-making.',45.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Bus Driver', 9, 'a person whose job is to drive a bus.',71.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Pilot',9,'a person who flies or is qualified to fly an aircraft or spacecraft.',135.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Transportation Engineer',9,'a person who involves the planning, design, operation, and maintenance of transportation systems',178.00);

INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 67);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 77);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 46);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 104);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 21.112);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 82);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 162);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 0, 80);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 177);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 3, 35);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (12, 1, 5, 70);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (14, 1, 10, 109);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (15, 1, 3, 23);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (17, 1, 2, 25);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (19, 1, 6, 21.103);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (21, 1, 3, 56);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password,AdminStatus) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , '304Arnold!', 1);
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , '304Bobby!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , '304Candace!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , '304Darren!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , '304Beth!');


UPDATE Product SET productImageURL = 'img/1.jpg' WHERE productId = 1;
UPDATE Product SET productImageURL = 'img/2.jpg' WHERE productId = 2;
UPDATE Product SET productImageURL = 'img/3.jpg' WHERE productId = 3;
UPDATE Product SET productImageURL = 'img/4.jpg' WHERE productId = 4;
UPDATE Product SET productImageURL = 'img/5.jpg' WHERE productId = 5;
UPDATE Product SET productImageURL = 'img/6.jpg' WHERE productId = 6;
UPDATE Product SET productImageURL = 'img/7.jpg' WHERE productId = 7;
UPDATE Product SET productImageURL = 'img/8.jpg' WHERE productId = 8;
UPDATE Product SET productImageURL = 'img/9.jpg' WHERE productId = 9;
UPDATE Product SET productImageURL = 'img/10.jpg' WHERE productId = 10;
UPDATE Product SET productImageURL = 'img/11.jpg' WHERE productId = 11;
UPDATE Product SET productImageURL = 'img/12.jpg' WHERE productId = 12;
UPDATE Product SET productImageURL = 'img/13.jpg' WHERE productId = 13;
UPDATE Product SET productImageURL = 'img/14.jpg' WHERE productId = 14;
UPDATE Product SET productImageURL = 'img/15.jpg' WHERE productId = 15;
UPDATE Product SET productImageURL = 'img/16.jpg' WHERE productId = 16;
UPDATE Product SET productImageURL = 'img/17.jpg' WHERE productId = 17;
UPDATE Product SET productImageURL = 'img/18.jpg' WHERE productId = 18;
UPDATE Product SET productImageURL = 'img/19.jpg' WHERE productId = 19;
UPDATE Product SET productImageURL = 'img/20.jpg' WHERE productId = 20;
UPDATE Product SET productImageURL = 'img/21.jpg' WHERE productId = 21;
UPDATE Product SET productImageURL = 'img/22.jpg' WHERE productId = 22;
UPDATE Product SET productImageURL = 'img/23.jpg' WHERE productId = 23;
UPDATE Product SET productImageURL = 'img/24.jpg' WHERE productId = 24;
UPDATE Product SET productImageURL = 'img/25.jpg' WHERE productId = 25;
UPDATE Product SET productImageURL = 'img/26.jpg' WHERE productId = 26;

ALTER TABLE customer
    ADD  AdminStatus Bit NOT NULL 
    CONSTRAINT Def_Customer_AdminStatus
    DEFAULT (0);  		

UPDATE customer SET AdminStatus = 1 WHERE customerId=1;


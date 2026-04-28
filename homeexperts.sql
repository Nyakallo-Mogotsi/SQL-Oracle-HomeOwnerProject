-- =========================
-- TABLE CREATION
-- =========================

CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    client_number INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    address VARCHAR(200)
);

CREATE TABLE Service_Requests (
    request_id INT PRIMARY KEY,
    job_scale VARCHAR(20),
    service_description VARCHAR(300),
    request_date DATE
);

CREATE TABLE Contractors (
    contractor_id INT PRIMARY KEY,
    client_id INT,
    request_id INT,
    business_name VARCHAR(100),
    contact_info VARCHAR(100),
    bill_amount DECIMAL(10,2),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (request_id) REFERENCES Service_Requests(request_id)
);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    client_id INT,
    review_score INT CHECK (review_score BETWEEN 1 AND 5),
    review_comment VARCHAR(300),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

CREATE TABLE Discount (
    discount_id INT PRIMARY KEY,
    first_purchase_yn CHAR(1) CHECK (first_purchase_yn IN ('Y', 'N'))
);

CREATE TABLE Business_Unit (
    business_id INT PRIMARY KEY,
    payment_id INT,
    total_revenue DECIMAL(12,2),
    margin_percentage DECIMAL(5,2)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    job_scale VARCHAR(20),
    contractor_id INT,
    discount_id INT,
    business_id INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (contractor_id) REFERENCES Contractors(contractor_id),
    FOREIGN KEY (discount_id) REFERENCES Discount(discount_id),
    FOREIGN KEY (business_id) REFERENCES Business_Unit(business_id)
);

ALTER TABLE Business_Unit
ADD CONSTRAINT fk_payment FOREIGN KEY (payment_id) REFERENCES Payments(payment_id);

CREATE TABLE Location (
    location_id INT PRIMARY KEY,
    address VARCHAR(100)
);

CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY,
    location_id INT,
    contractor_id INT,
    purchase_date DATE,
    inventory_type VARCHAR(100),
    FOREIGN KEY (location_id) REFERENCES Location(location_id),
    FOREIGN KEY (contractor_id) REFERENCES Contractors(contractor_id)
);

CREATE TABLE Job_Scale (
    jobscale_id INT PRIMARY KEY,
    inventory_id INT,
    contractor_id INT,
    square_meters INT,
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id),
    FOREIGN KEY (contractor_id) REFERENCES Contractors(contractor_id)
);

CREATE TABLE Schedules (
    schedule_id INT PRIMARY KEY,
    contractor_id INT,
    schedule_date DATE,
    FOREIGN KEY (contractor_id) REFERENCES Contractors(contractor_id)
);

-- =========================
-- INDEXES
-- =========================

CREATE INDEX idx_client_name ON Clients(last_name);
CREATE INDEX idx_review_score ON Reviews(review_score);

-- =========================
-- VIEWS
-- =========================

DROP VIEW IF EXISTS ClientReviews;
CREATE VIEW ClientReviews AS
SELECT c.first_name, c.last_name, r.review_score, r.review_comment
FROM Clients c
JOIN Reviews r ON c.client_id = r.client_id;

DROP VIEW IF EXISTS ContractorPayments;
CREATE VIEW ContractorPayments AS
SELECT ct.business_name, p.total_amount
FROM Contractors ct
JOIN Payments p ON ct.contractor_id = p.contractor_id;

DROP VIEW IF EXISTS DiscountedPayments;
CREATE VIEW DiscountedPayments AS
SELECT * FROM Payments
WHERE discount_id IS NOT NULL;

DROP VIEW IF EXISTS ServiceRequestDetails;
CREATE VIEW ServiceRequestDetails AS
SELECT sr.request_id, sr.service_description, cl.first_name, cl.last_name
FROM Service_Requests sr
JOIN Clients cl ON cl.client_id = sr.request_id;

-- =========================
-- DATA INSERTS
-- =========================

-- Clients
INSERT INTO Clients VALUES (1, 101, 'Johanna', 'Mokoena', '0831234567', '12 Maple St, Johannesburg');
INSERT INTO Clients VALUES (2, 102, 'Sibongile', 'Cele', '0845807760', '88 Sunset Blvd, Durban');
INSERT INTO Clients VALUES (3, 103, 'Maria', 'Dlamini', '0827801084', '17 Bluebell Rd, Cape Town');
INSERT INTO Clients VALUES (4, 104, 'Zandile', 'Tshabalala', '0850121571', '41 Cedar Crescent, Pretoria');
INSERT INTO Clients VALUES (5, 105, 'Fikile', 'Gumede', '0834592797', '59 Rosewood Dr, Bloemfontein');
INSERT INTO Clients VALUES (6, 106, 'Phumzile', 'Khoza', '0845178236', '23 Daisy Lane, Port Elizabeth');
INSERT INTO Clients VALUES (7, 107, 'Johanna', 'Mthethwa', '0837280364', '35 Magnolia Ave, Kimberley');
INSERT INTO Clients VALUES (8, 108, 'Nonhlanhla', 'Sibiya', '0834594742', '16 Pelican Way, Johannesburg');
INSERT INTO Clients VALUES (9, 109, 'Mpho', 'Van Wyk', '0827190087', '92 Lavender Rd, Durban');
INSERT INTO Clients VALUES (10, 110, 'Christina', 'Radebe', '0834925910', '28 Garden Grove, East London');
INSERT INTO Clients VALUES (11, 111, 'Andile', 'Sithole', '0834594721', '10 Hibiscus St, Cape Town');
INSERT INTO Clients VALUES (12, 112, 'Robert', 'Zungu', '0840579741', '73 Marula Rd, Pretoria');
INSERT INTO Clients VALUES (13, 113, 'Thabo', 'Van der Merwe', '0834597421', '6 Olive Tree Ave, Polokwane');
INSERT INTO Clients VALUES (14, 114, 'Tshepo', 'Mangu', '0834214761', '52 Orchid Blvd, Nelspruit');
INSERT INTO Clients VALUES (15, 115, 'Lungi', 'Kuhl', '0838962464', '9 Coral Close, George');
INSERT INTO Clients VALUES (16, 116, 'Shashi', 'Govender', '0834561466', '83 Aloe Way, Pietermaritzburg');
INSERT INTO Clients VALUES (17, 117, 'George', 'Smith', '0834594721', '19 Ebony St, Richard’s Bay');
INSERT INTO Clients VALUES (18, 118, 'Thomas', 'Naidoo', '0834594721', '64 Jasmine Dr, Rustenburg');
INSERT INTO Clients VALUES (19, 119, 'Thembi', 'Mahlangu', '0834594721', '45 Tulip Rd, Tzaneen');
INSERT INTO Clients VALUES (20, 120, 'Mark', 'Sibiya', '0858592262', '37 Fern Lane, Mahikeng');
INSERT INTO Clients VALUES (38, 138, 'Sibusiso', 'Mlongoo', '0835899000', '66 Heather Rd, Uitenhage');
INSERT INTO Clients VALUES (39, 139, 'Nomsa', 'Hlongwane', '0840909012', '99 Dolphin Ave, Ballito');
INSERT INTO Clients VALUES (40, 140, 'Precious', 'Ntshangase', '0851011123', '10 Kingsview St, Queenstown');


-- Contractors
INSERT INTO Contractors VALUES (1, 1, 'FixItNow', 'fixit@example.com', 1500.00);
INSERT INTO Contractors VALUES (2, 2, 'BuildPro', 'buildpro@example.com', 2000.00);
INSERT INTO Contractors VALUES (3, 2, 'ConstructWell', 'constructwell@example.com', 2150.50);
INSERT INTO Contractors VALUES (4, 2, 'SolidBase', 'solidbase@example.com', 1800.75);
INSERT INTO Contractors VALUES (5, 2, 'SteelCore', 'steelcore@example.com', 2200.00);
INSERT INTO Contractors VALUES (6, 2, 'PrimeConstruct', 'primeconstruct@example.com', 2400.90);
INSERT INTO Contractors VALUES (7, 2, 'UrbanEdge', 'urbanedge@example.com', 1950.25);
INSERT INTO Contractors VALUES (8, 2, 'BuildRight', 'buildright@example.com', 2300.00);
INSERT INTO Contractors VALUES (9, 2, 'MegaWorks', 'megaworks@example.com', 2100.30);
INSERT INTO Contractors VALUES (10, 2, 'NextGenBuilders', 'nextgen@example.com', 2250.60);
INSERT INTO Contractors VALUES (11, 2, 'CoreBuild', 'corebuild@example.com', 1900.00);
INSERT INTO Contractors VALUES (12, 2, 'SkylineGroup', 'skyline@example.com', 2050.45);
INSERT INTO Contractors VALUES (13, 2, 'TopHammer', 'tophammer@example.com', 1850.80);
INSERT INTO Contractors VALUES (14, 2, 'StoneBuild', 'stonebuild@example.com', 2050.45);
INSERT INTO Contractors VALUES (15, 2, 'QuickConstruct', 'quickconstruct@example.com', 2350.70);
INSERT INTO Contractors VALUES (16, 2, 'EagleBuild', 'eaglebuild@example.com', 2120.00);
INSERT INTO Contractors VALUES (17, 2, 'Structura', 'structura@example.com', 2195.95);
INSERT INTO Contractors VALUES (18, 2, 'ReliableBlocks', 'reliable@example.com', 2500.00);
INSERT INTO Contractors VALUES (19, 2, 'AnchorBuilders', 'anchor@example.com', 1750.00);
INSERT INTO Contractors VALUES (20, 2, 'PillarPoint', 'pillarpoint@example.com', 2600.00);
INSERT INTO Contractors VALUES (21, 2, 'IronClad', 'ironclad@example.com', 2400.00);


-- Payments
INSERT INTO Payments VALUES (101, 'Small', 1, 1, 1450.00);
INSERT INTO Payments VALUES (102, 'Medium', 2, 1, 2300.00);
INSERT INTO Payments VALUES (103, 'Large', 3, 1, 3750.50);
INSERT INTO Payments VALUES (104, 'Medium', 4, 1, 1970.00);
INSERT INTO Payments VALUES (105, 'Large', 5, 1, 2113.75);
INSERT INTO Payments VALUES (106, 'Small', 6, 1, 760.80);
INSERT INTO Payments VALUES (107, 'Medium', 7, 1, 2670.00);
INSERT INTO Payments VALUES (108, 'Large', 8, 1, 3120.45);
INSERT INTO Payments VALUES (109, 'Small', 9, 1, 1230.45);
INSERT INTO Payments VALUES (110, 'Medium', 10, 1, 1730.00);
INSERT INTO Payments VALUES (111, 'Small', 11, 1, 970.15);
INSERT INTO Payments VALUES (112, 'Large', 12, 1, 2470.90);
INSERT INTO Payments VALUES (113, 'Medium', 13, 1, 2645.00);
INSERT INTO Payments VALUES (114, 'Small', 14, 1, 1350.00);
INSERT INTO Payments VALUES (115, 'Large', 15, 1, 1770.70);
INSERT INTO Payments VALUES (116, 'Small', 16, 1, 850.30);
INSERT INTO Payments VALUES (117, 'Medium', 17, 1, 993.57);
INSERT INTO Payments VALUES (118, 'Large', 18, 1, 1970.33);
INSERT INTO Payments VALUES (119, 'Medium', 19, 1, 2000.00);
INSERT INTO Payments VALUES (120, 'Large', 20, 1, 3333.30);


-- Business Units
INSERT INTO Business_Unit VALUES (1, 1, 1450.00, 0.08);
INSERT INTO Business_Unit VALUES (2, 2, 2300.00, 0.08);
INSERT INTO Business_Unit VALUES (3, 4, 3750.00, 0.08);
INSERT INTO Business_Unit VALUES (4, 4, 1710.75, 0.08);
INSERT INTO Business_Unit VALUES (5, 6, 2670.00, 0.08);
INSERT INTO Business_Unit VALUES (6, 7, 3750.00, 0.08);
INSERT INTO Business_Unit VALUES (7, 8, 1710.75, 0.08);
INSERT INTO Business_Unit VALUES (8, 9, 1730.00, 0.08);
INSERT INTO Business_Unit VALUES (9, 9, 1730.00,


-- Locations
INSERT INTO Location VALUES (1, '12 Maple St, Johannesburg');
INSERT INTO Location VALUES (2, '88 Sunset Blvd, Durban');
INSERT INTO Location VALUES (3, '7 Bluebell Rd, Cape Town');
INSERT INTO Location VALUES (4, '41 Cedar Crescent, Pretoria');
INSERT INTO Location VALUES (5, '59 Rosewood Dr, Bloemfontein');
INSERT INTO Location VALUES (6, '23 Daisy Lane, Port Elizabeth');
INSERT INTO Location VALUES (7, '15 Magnolia Ave, Kimberley');
INSERT INTO Location VALUES (8, '19 Pelican Way, Johannesburg');
INSERT INTO Location VALUES (9, '8 Lavender Rd, Durban');
INSERT INTO Location VALUES (10, '10 Garden Grove, East London');
INSERT INTO Location VALUES (11, '20 Hibiscus St, Cape Town');
INSERT INTO Location VALUES (12, '33 Marula Rd, Polokwane');
INSERT INTO Location VALUES (13, '9 Olive Tree Ave, Polokwane');
INSERT INTO Location VALUES (14, '30 Orchid Blvd, Nelspruit');
INSERT INTO Location VALUES (15, '62 Coral Close, George');
INSERT INTO Location VALUES (16, '34 Jade Way, Pietermaritzburg');
INSERT INTO Location VALUES (17, '35 Ebony St, Richards Bay');
INSERT INTO Location VALUES (18, '44 Jasmine Dr, Rustenburg');
INSERT INTO Location VALUES (19, '9 Tulip Rd, Tzaneen');
INSERT INTO Location VALUES (20, '37 Fern Lane, Mahikeng');

-- Inventory
INSERT INTO Inventory VALUES (1, 1, 1, TO_DATE('2025-01-18','YYYY-MM-DD'),'Exterior paint');
INSERT INTO Inventory VALUES (2, 2, 2, TO_DATE('2025-02-12','YYYY-MM-DD'),'Exterior paint');
INSERT INTO Inventory VALUES (3, 3, 3, TO_DATE('2025-05-06','YYYY-MM-DD'),'Exterior paint');
INSERT INTO Inventory VALUES (4, 4, 4, TO_DATE('2025-05-06','YYYY-MM-DD'),'Sliding door parts');
INSERT INTO Inventory VALUES (5, 5, 5, TO_DATE('2025-04-15','YYYY-MM-DD'),'Driveway filler');
INSERT INTO Inventory VALUES (6, 6, 6, TO_DATE('2025-04-15','YYYY-MM-DD'),'Driveway filler');
INSERT INTO Inventory VALUES (7, 7, 7, TO_DATE('2025-04-19','YYYY-MM-DD'),'Plumbing supplies');
INSERT INTO Inventory VALUES (8, 8, 8, TO_DATE('2025-03-17','YYYY-MM-DD'),'Gate motor parts');
INSERT INTO Inventory VALUES (9, 9, 9, TO_DATE('2025-03-21','YYYY-MM-DD'),'Fence panels');
INSERT INTO Inventory VALUES (10, 10, 10, TO_DATE('2025-03-19','YYYY-MM-DD'),'Kitchen cabinets');
INSERT INTO Inventory VALUES (11, 11, 11, TO_DATE('2025-03-01','YYYY-MM-DD'),'Electrical outlets');
INSERT INTO Inventory VALUES (12, 12, 12, TO_DATE('2025-03-04','YYYY-MM-DD'),'Roofing material');
INSERT INTO Inventory VALUES (13, 13, 13, TO_DATE('2025-03-24','YYYY-MM-DD'),'Sliding door parts');
INSERT INTO Inventory VALUES (14, 14, 14, TO_DATE('2025-03-09','YYYY-MM-DD'),'Roofing material');
INSERT INTO Inventory VALUES (15, 15, 15, TO_DATE('2025-03-11','YYYY-MM-DD'),'Electrical outlets');
INSERT INTO Inventory VALUES (16, 16, 16, TO_DATE('2025-03-09','YYYY-MM-DD'),'Fence panels');
INSERT INTO Inventory VALUES (17, 17, 17, TO_DATE('2025-03-07','YYYY-MM-DD'),'Roofing material');
INSERT INTO Inventory VALUES (18, 18, 18, TO_DATE('2025-03-19','YYYY-MM-DD'),'Plumbing supplies');
INSERT INTO Inventory VALUES (19, 19, 19, TO_DATE('2025-03-07','YYYY-MM-DD'),'Driveway filler');
INSERT INTO Inventory VALUES (20, 20, 20, TO_DATE('2025-03-17','YYYY-MM-DD'),'Exterior paint');
INSERT INTO Inventory VALUES (21, 21, 21, TO_DATE('2025-01-17','YYYY-MM-DD'),'Exterior paint');
INSERT INTO Inventory VALUES (39, 39, 39, TO_DATE('2025-02-09','YYYY-MM-DD'), 'Sliding door parts');
INSERT INTO Inventory VALUES (40, 40, 40, TO_DATE('2025-01-23','YYYY-MM-DD'), 'Plumbing supplies');

-- Job Scale
INSERT INTO Job_Scale VALUES (1, 1, 1, 1470);
INSERT INTO Job_Scale VALUES (2, 2, 2, 944);
INSERT INTO Job_Scale VALUES (3, 3, 3, 1241);
INSERT INTO Job_Scale VALUES (4, 4, 4, 1370);
INSERT INTO Job_Scale VALUES (5, 5, 5, 770);
INSERT INTO Job_Scale VALUES (6, 6, 6, 730);
INSERT INTO Job_Scale VALUES (7, 7, 7, 799);
INSERT INTO Job_Scale VALUES (8, 8, 8, 1070);
INSERT INTO Job_Scale VALUES (9, 9, 9, 1108);
INSERT INTO Job_Scale VALUES (10, 10, 10, 1039);
INSERT INTO Job_Scale VALUES (11, 11, 11, 1139);
INSERT INTO Job_Scale VALUES (12, 12, 12, 1470);
INSERT INTO Job_Scale VALUES (13, 13, 13, 2458);
INSERT INTO Job_Scale VALUES (14, 14, 14, 2458);
INSERT INTO Job_Scale VALUES (15, 15, 15, 2458);
INSERT INTO Job_Scale VALUES (16, 16, 16, 2458);
INSERT INTO Job_Scale VALUES (17, 17, 17, 2458);
INSERT INTO Job_Scale VALUES (18, 18, 18, 2458);
INSERT INTO Job_Scale VALUES (19, 19, 19, 716);


-- Schedules
INSERT INTO Schedules VALUES (1, 1, TO_DATE('2025-05-10','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (2, 2, TO_DATE('2025-04-17','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (3, 3, TO_DATE('2025-04-22','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (4, 4, TO_DATE('2025-04-19','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (5, 5, TO_DATE('2025-04-20','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (6, 6, TO_DATE('2025-04-23','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (7, 7, TO_DATE('2025-04-25','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (8, 8, TO_DATE('2025-04-30','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (9, 10, TO_DATE('2025-05-03','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (10, 11, TO_DATE('2025-05-13','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (11, 12, TO_DATE('2025-04-26','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (12, 13, TO_DATE('2025-04-27','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (13, 14, TO_DATE('2025-04-23','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (14, 15, TO_DATE('2025-05-17','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (15, 16, TO_DATE('2025-05-23','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (16, 17, TO_DATE('2025-05-23','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (17, 18, TO_DATE('2025-05-23','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (18, 19, TO_DATE('2025-05-15','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (19, 20, TO_DATE('2025-05-15','YYYY-MM-DD'));
INSERT INTO Schedules VALUES (20, 21, TO_DATE('2025-05-15','YYYY-MM-DD'));


-- Reviews (1–40)
INSERT INTO Reviews VALUES (1, 1, 5, 'Great service!');
INSERT INTO Reviews VALUES (2, 2, 4, 'Very good.');
INSERT INTO Reviews VALUES (3, 3, 2, 'Service was below expectations.');
INSERT INTO Reviews VALUES (4, 4, 5, 'Absolutely fantastic experience!');
INSERT INTO Reviews VALUES (5, 5, 3, 'It was okay, nothing special.');
INSERT INTO Reviews VALUES (6, 6, 1, 'Very disappointed with the service.');
INSERT INTO Reviews VALUES (7, 7, 4, 'Good job, I am satisfied.');
INSERT INTO Reviews VALUES (8, 8, 5, 'Exceptional service, highly recommend!');
INSERT INTO Reviews VALUES (9, 9, 2, 'Not very happy with the outcome.');
INSERT INTO Reviews VALUES (10, 10, 3, 'Average experience.');
INSERT INTO Reviews VALUES (11, 11, 4, 'Very good, would use again.');
INSERT INTO Reviews VALUES (12, 12, 1, 'Terribly, will not return.');
INSERT INTO Reviews VALUES (13, 13, 5, 'Outstanding work!');
INSERT INTO Reviews VALUES (14, 14, 3, 'Could have been better.');
INSERT INTO Reviews VALUES (15, 15, 4, 'Service was acceptable.');
INSERT INTO Reviews VALUES (16, 16, 5, 'Nice and professional.');
INSERT INTO Reviews VALUES (17, 17, 4, 'Perfect, exceeded my expectations!');
INSERT INTO Reviews VALUES (18, 18, 2, 'Not satisfied with the service.');
INSERT INTO Reviews VALUES (19, 19, 3, 'It was fine, nothing more.');
INSERT INTO Reviews VALUES (20, 20, 5, 'Very good, thank you!');
INSERT INTO Reviews VALUES (21, 21, 4, 'Very good, thank you!');
INSERT INTO Reviews VALUES (39, 39, 2, 'Needs significant improvement.');
INSERT INTO Reviews VALUES (40, 40, 3, 'It was decent.');


-- Discounts
INSERT INTO Discount VALUES (1, 'N');
INSERT INTO Discount VALUES (2, 'Y');
INSERT INTO Discount VALUES (3, 'Y');
INSERT INTO Discount VALUES (4, 'Y');
INSERT INTO Discount VALUES (5, 'Y');
INSERT INTO Discount VALUES (6, 'Y');
INSERT INTO Discount VALUES (7, 'Y');
INSERT INTO Discount VALUES (8, 'Y');
INSERT INTO Discount VALUES (9, 'Y');
INSERT INTO Discount VALUES (10, 'Y');
INSERT INTO Discount VALUES (11, 'Y');
INSERT INTO Discount VALUES (12, 'Y');
INSERT INTO Discount VALUES (13, 'Y');
INSERT INTO Discount VALUES (14, 'Y');
INSERT INTO Discount VALUES (15, 'Y');
INSERT INTO Discount VALUES (16, 'Y');
INSERT INTO Discount VALUES (17, 'Y');
INSERT INTO Discount VALUES (18, 'Y');
INSERT INTO Discount VALUES (19, 'N');
INSERT INTO Discount VALUES (40, 'N');


-- Service Requests
INSERT INTO Service_Requests VALUES (101, 'Medium', 'Painting the garage door', TO_DATE('2025-03-18','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (102, 'Medium', 'Fixing a jammed sliding door', TO_DATE('2025-04-30','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (103, 'Large', 'Patching cracked driveway', TO_DATE('2025-04-22','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (104, 'Small', 'Painting exterior walls', TO_DATE('2025-02-04','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (105, 'Large', 'Replacing faulty electrical outlets', TO_DATE('2025-05-09','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (106, 'Medium', 'Fixing a leaking tap', TO_DATE('2025-03-06','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (107, 'Small', 'Fixing a broken gate motor', TO_DATE('2025-03-16','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (108, 'Medium', 'Repairing fence panels', TO_DATE('2025-03-17','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (109, 'Small', 'Installing new kitchen cabinets', TO_DATE('2025-03-20','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (110, 'Large', 'Fixing garage roof leaks', TO_DATE('2025-03-26','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (111, 'Small', 'Clearing blocked drains', TO_DATE('2025-03-14','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (112, 'Medium', 'Fixing jammed gutters', TO_DATE('2025-03-10','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (113, 'Small', 'Repairing roof tiles', TO_DATE('2025-03-14','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (114, 'Small', 'Cleaning gutters', TO_DATE('2025-03-14','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (115, 'Large', 'Repairing roof tiles', TO_DATE('2025-03-14','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (116, 'Large', 'Installing a security camera system', TO_DATE('2025-05-02','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (117, 'Large', 'Installing a security camera system', TO_DATE('2025-05-02','YYYY-MM-DD'));
INSERT INTO Service_Requests VALUES (118, 'Medium', 'Rewiring outdoor lighting', TO_DATE('2025-04-10','YYYY-MM-DD'));

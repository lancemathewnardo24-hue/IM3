/* ============================================================
   STAR SCHEMA SALES DEMO DATASET
   Purpose: Differentiate fact table, dimension tables, grain of data,
            star schema, measures, and KPI preparation 

   Grain of fact_sales:
   One row per sales order line item.
   This means one order can appear multiple times if it has multiple products.
   ============================================================ */

DROP DATABASE IF EXISTS jim3astarschema;
CREATE DATABASE jim3astarschema;
USE jim3astarschema;

DROP TABLE IF EXISTS fact_sales_target;
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_region;
DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    calendar_date DATE NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month_number INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
  --  year_month VARCHAR(7) NOT NULL,
    week_number INT NOT NULL,
    day_name VARCHAR(20) NOT NULL
);

CREATE TABLE dim_product (
    product_key INT PRIMARY KEY,
    product_id VARCHAR(20) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category_name VARCHAR(50) NOT NULL,
    subcategory_name VARCHAR(50) NOT NULL,
    brand_name VARCHAR(50) NOT NULL,
    list_price DECIMAL(12,2) NOT NULL,
    standard_cost DECIMAL(12,2) NOT NULL
);

CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_segment VARCHAR(50) NOT NULL,
    city_name VARCHAR(50) NOT NULL,
    region_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE dim_region (
    region_key INT PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE fact_sales (
    sales_line_key INT PRIMARY KEY,
    order_number VARCHAR(30) NOT NULL,
    date_key INT NOT NULL,
    customer_key INT NOT NULL,
    product_key INT NOT NULL,
    region_key INT NOT NULL,
    quantity_ordered INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    discount_amount DECIMAL(12,2) NOT NULL,
    gross_sales_amount DECIMAL(12,2) NOT NULL,
    net_sales_amount DECIMAL(12,2) NOT NULL,
    cost_amount DECIMAL(12,2) NOT NULL,
    profit_amount DECIMAL(12,2) NOT NULL,
    return_flag TINYINT NOT NULL,
    return_quantity INT NOT NULL,
    CONSTRAINT fk_star_sales_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    CONSTRAINT fk_star_sales_customer FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    CONSTRAINT fk_star_sales_product FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    CONSTRAINT fk_star_sales_region FOREIGN KEY (region_key) REFERENCES dim_region(region_key)
);

CREATE TABLE fact_sales_target (
    target_key INT PRIMARY KEY,
    month_date_key INT NOT NULL,
    region_key INT NOT NULL,
    revenue_target DECIMAL(12,2) NOT NULL,
    order_target INT NOT NULL,
    return_limit INT NOT NULL,
    CONSTRAINT fk_star_target_date FOREIGN KEY (month_date_key) REFERENCES dim_date(date_key),
    CONSTRAINT fk_star_target_region FOREIGN KEY (region_key) REFERENCES dim_region(region_key)
);

INSERT INTO dim_date (date_key, calendar_date, year, quarter, month_number, month_name, week_number, day_name) VALUES
(20250101, '2025-01-01', 2025, 1, 1, 'January' , 1, 'Wednesday'),
(20250102, '2025-01-02', 2025, 1, 1, 'January' , 1, 'Thursday'),
(20250103, '2025-01-03', 2025, 1, 1, 'January' , 1, 'Friday'),
(20250104, '2025-01-04', 2025, 1, 1, 'January' , 1, 'Saturday'),
(20250105, '2025-01-05', 2025, 1, 1, 'January' , 1, 'Sunday'),
(20250106, '2025-01-06', 2025, 1, 1, 'January' , 2, 'Monday'),
(20250107, '2025-01-07', 2025, 1, 1, 'January' , 2, 'Tuesday'),
(20250108, '2025-01-08', 2025, 1, 1, 'January' , 2, 'Wednesday'),
(20250109, '2025-01-09', 2025, 1, 1, 'January' , 2, 'Thursday'),
(20250110, '2025-01-10', 2025, 1, 1, 'January' , 2, 'Friday'),
(20250111, '2025-01-11', 2025, 1, 1, 'January' , 2, 'Saturday'),
(20250112, '2025-01-12', 2025, 1, 1, 'January' , 2, 'Sunday'),
(20250113, '2025-01-13', 2025, 1, 1, 'January' , 3, 'Monday'),
(20250114, '2025-01-14', 2025, 1, 1, 'January' , 3, 'Tuesday'),
(20250115, '2025-01-15', 2025, 1, 1, 'January' , 3, 'Wednesday'),
(20250116, '2025-01-16', 2025, 1, 1, 'January' , 3, 'Thursday'),
(20250117, '2025-01-17', 2025, 1, 1, 'January' , 3, 'Friday'),
(20250118, '2025-01-18', 2025, 1, 1, 'January' , 3, 'Saturday'),
(20250119, '2025-01-19', 2025, 1, 1, 'January' , 3, 'Sunday'),
(20250120, '2025-01-20', 2025, 1, 1, 'January' , 4, 'Monday'),
(20250121, '2025-01-21', 2025, 1, 1, 'January' , 4, 'Tuesday'),
(20250122, '2025-01-22', 2025, 1, 1, 'January' , 4, 'Wednesday'),
(20250123, '2025-01-23', 2025, 1, 1, 'January' , 4, 'Thursday'),
(20250124, '2025-01-24', 2025, 1, 1, 'January' , 4, 'Friday'),
(20250125, '2025-01-25', 2025, 1, 1, 'January' , 4, 'Saturday'),
(20250126, '2025-01-26', 2025, 1, 1, 'January' , 4, 'Sunday'),
(20250127, '2025-01-27', 2025, 1, 1, 'January' , 5, 'Monday'),
(20250128, '2025-01-28', 2025, 1, 1, 'January' , 5, 'Tuesday'),
(20250129, '2025-01-29', 2025, 1, 1, 'January' , 5, 'Wednesday'),
(20250130, '2025-01-30', 2025, 1, 1, 'January' , 5, 'Thursday'),
(20250131, '2025-01-31', 2025, 1, 1, 'January' , 5, 'Friday'),
(20250201, '2025-02-01', 2025, 1, 2, 'February'  , 5, 'Saturday'),
(20250202, '2025-02-02', 2025, 1, 2, 'February'  , 5, 'Sunday'),
(20250203, '2025-02-03', 2025, 1, 2, 'February'  , 6, 'Monday'),
(20250204, '2025-02-04', 2025, 1, 2, 'February'  , 6, 'Tuesday'),
(20250205, '2025-02-05', 2025, 1, 2, 'February'  , 6, 'Wednesday'),
(20250206, '2025-02-06', 2025, 1, 2, 'February'  , 6, 'Thursday'),
(20250207, '2025-02-07', 2025, 1, 2, 'February'  , 6, 'Friday'),
(20250208, '2025-02-08', 2025, 1, 2, 'February'  , 6, 'Saturday'),
(20250209, '2025-02-09', 2025, 1, 2, 'February'  , 6, 'Sunday'),
(20250210, '2025-02-10', 2025, 1, 2, 'February'  , 7, 'Monday'),
(20250211, '2025-02-11', 2025, 1, 2, 'February'  , 7, 'Tuesday'),
(20250212, '2025-02-12', 2025, 1, 2, 'February'  , 7, 'Wednesday'),
(20250213, '2025-02-13', 2025, 1, 2, 'February'  , 7, 'Thursday'),
(20250214, '2025-02-14', 2025, 1, 2, 'February'  , 7, 'Friday'),
(20250215, '2025-02-15', 2025, 1, 2, 'February'  , 7, 'Saturday'),
(20250216, '2025-02-16', 2025, 1, 2, 'February'  , 7, 'Sunday'),
(20250217, '2025-02-17', 2025, 1, 2, 'February'  , 8, 'Monday'),
(20250218, '2025-02-18', 2025, 1, 2, 'February'  , 8, 'Tuesday'),
(20250219, '2025-02-19', 2025, 1, 2, 'February'  , 8, 'Wednesday');

INSERT INTO dim_date (date_key, calendar_date, year, quarter, month_number, month_name, week_number, day_name) VALUES
(20250220, '2025-02-20', 2025, 1, 2, 'February' , 8, 'Thursday'),
(20250221, '2025-02-21', 2025, 1, 2, 'February' , 8, 'Friday'),
(20250222, '2025-02-22', 2025, 1, 2, 'February' , 8, 'Saturday'),
(20250223, '2025-02-23', 2025, 1, 2, 'February' , 8, 'Sunday'),
(20250224, '2025-02-24', 2025, 1, 2, 'February' , 9, 'Monday'),
(20250225, '2025-02-25', 2025, 1, 2, 'February' , 9, 'Tuesday'),
(20250226, '2025-02-26', 2025, 1, 2, 'February' , 9, 'Wednesday'),
(20250227, '2025-02-27', 2025, 1, 2, 'February' , 9, 'Thursday'),
(20250228, '2025-02-28', 2025, 1, 2, 'February' , 9, 'Friday'),
(20250301, '2025-03-01', 2025, 1, 3, 'March' , 9, 'Saturday'),
(20250302, '2025-03-02', 2025, 1, 3, 'March' , 9, 'Sunday'),
(20250303, '2025-03-03', 2025, 1, 3, 'March' , 10, 'Monday'),
(20250304, '2025-03-04', 2025, 1, 3, 'March' , 10, 'Tuesday'),
(20250305, '2025-03-05', 2025, 1, 3, 'March' , 10, 'Wednesday'),
(20250306, '2025-03-06', 2025, 1, 3, 'March' , 10, 'Thursday'),
(20250307, '2025-03-07', 2025, 1, 3, 'March' , 10, 'Friday'),
(20250308, '2025-03-08', 2025, 1, 3, 'March' , 10, 'Saturday'),
(20250309, '2025-03-09', 2025, 1, 3, 'March' , 10, 'Sunday'),
(20250310, '2025-03-10', 2025, 1, 3, 'March' , 11, 'Monday'),
(20250311, '2025-03-11', 2025, 1, 3, 'March' , 11, 'Tuesday'),
(20250312, '2025-03-12', 2025, 1, 3, 'March' , 11, 'Wednesday'),
(20250313, '2025-03-13', 2025, 1, 3, 'March' , 11, 'Thursday'),
(20250314, '2025-03-14', 2025, 1, 3, 'March' , 11, 'Friday'),
(20250315, '2025-03-15', 2025, 1, 3, 'March' , 11, 'Saturday'),
(20250316, '2025-03-16', 2025, 1, 3, 'March' , 11, 'Sunday'),
(20250317, '2025-03-17', 2025, 1, 3, 'March' , 12, 'Monday'),
(20250318, '2025-03-18', 2025, 1, 3, 'March' , 12, 'Tuesday'),
(20250319, '2025-03-19', 2025, 1, 3, 'March' , 12, 'Wednesday'),
(20250320, '2025-03-20', 2025, 1, 3, 'March' , 12, 'Thursday'),
(20250321, '2025-03-21', 2025, 1, 3, 'March' , 12, 'Friday'),
(20250322, '2025-03-22', 2025, 1, 3, 'March' , 12, 'Saturday'),
(20250323, '2025-03-23', 2025, 1, 3, 'March' , 12, 'Sunday'),
(20250324, '2025-03-24', 2025, 1, 3, 'March' , 13, 'Monday'),
(20250325, '2025-03-25', 2025, 1, 3, 'March' , 13, 'Tuesday'),
(20250326, '2025-03-26', 2025, 1, 3, 'March' , 13, 'Wednesday'),
(20250327, '2025-03-27', 2025, 1, 3, 'March' , 13, 'Thursday'),
(20250328, '2025-03-28', 2025, 1, 3, 'March' , 13, 'Friday'),
(20250329, '2025-03-29', 2025, 1, 3, 'March' , 13, 'Saturday'),
(20250330, '2025-03-30', 2025, 1, 3, 'March' , 13, 'Sunday'),
(20250331, '2025-03-31', 2025, 1, 3, 'March' , 14, 'Monday');

INSERT INTO dim_product (product_key, product_id, product_name, category_name, subcategory_name, brand_name, list_price, standard_cost) VALUES
(1, 'P001', 'Mountain Tire Tube', 'Accessories', 'Tires and Tubes', 'TrailPro', 220.00, 120.00),
(2, 'P002', 'Water Bottle - 30 oz.', 'Accessories', 'Bottles and Cages', 'HydroMax', 180.00, 75.00),
(3, 'P003', 'Road Tire Tube', 'Accessories', 'Tires and Tubes', 'RoadPro', 210.00, 115.00),
(4, 'P004', 'AWC Logo Cap', 'Clothing', 'Caps', 'AWC', 250.00, 110.00),
(5, 'P005', 'Sport-100 Helmet, Red', 'Accessories', 'Helmets', 'SafeRide', 1450.00, 890.00),
(6, 'P006', 'Sport-100 Helmet, Blue', 'Accessories', 'Helmets', 'SafeRide', 1450.00, 890.00),
(7, 'P007', 'Sport-100 Helmet, Black', 'Accessories', 'Helmets', 'SafeRide', 1450.00, 890.00),
(8, 'P008', 'Fender Set - Mountain', 'Accessories', 'Bike Components', 'TrailPro', 950.00, 530.00),
(9, 'P009', 'Mountain Bottle Cage', 'Accessories', 'Bottles and Cages', 'HydroMax', 310.00, 150.00),
(10, 'P010', 'Shorts', 'Clothing', 'Shorts', 'AWC', 850.00, 460.00),
(11, 'P011', 'Road-250 Red Bike', 'Bikes', 'Road Bikes', 'RoadPro', 42000.00, 31000.00),
(12, 'P012', 'Mountain-200 Black Bike', 'Bikes', 'Mountain Bikes', 'TrailPro', 38500.00, 29000.00);
INSERT INTO dim_customer (customer_key, customer_id, customer_name, customer_segment, city_name, region_name, country) VALUES
(1, 'CUST-001', 'Ana Santos', 'Retail', 'Mandaue', 'Cebu', 'Philippines'),
(2, 'CUST-002', 'Ben Reyes', 'Corporate', 'Davao City', 'Davao', 'Philippines'),
(3, 'CUST-003', 'Carlo Cruz', 'Corporate', 'Makati', 'Manila', 'Philippines'),
(4, 'CUST-004', 'Dina Garcia', 'Retail', 'Mandaue', 'Cebu', 'Philippines'),
(5, 'CUST-005', 'Erika Lim', 'Retail', 'Iloilo City', 'Iloilo', 'Philippines'),
(6, 'CUST-006', 'Francis Tan', 'Retail', 'Cebu City', 'Cebu', 'Philippines'),
(7, 'CUST-007', 'Grace Dela Cruz', 'Corporate', 'Makati', 'Manila', 'Philippines'),
(8, 'CUST-008', 'Hector Mendoza', 'Corporate', 'Cebu City', 'Cebu', 'Philippines'),
(9, 'CUST-009', 'Ivy Ramos', 'Corporate', 'Iloilo City', 'Iloilo', 'Philippines'),
(10, 'CUST-010', 'Jonas Bautista', 'Wholesale', 'Passi', 'Iloilo', 'Philippines'),
(11, 'CUST-011', 'Kara Villanueva', 'Corporate', 'Cebu City', 'Cebu', 'Philippines'),
(12, 'CUST-012', 'Leo Torres', 'Wholesale', 'Iloilo City', 'Iloilo', 'Philippines'),
(13, 'CUST-013', 'Mara Flores', 'Corporate', 'Davao City', 'Davao', 'Philippines'),
(14, 'CUST-014', 'Nico Castillo', 'Wholesale', 'Makati', 'Manila', 'Philippines'),
(15, 'CUST-015', 'Olive Aquino', 'Retail', 'Mandaue', 'Cebu', 'Philippines'),
(16, 'CUST-016', 'Paolo Yu', 'Retail', 'Iloilo City', 'Iloilo', 'Philippines'),
(17, 'CUST-017', 'Quinn Sy', 'Wholesale', 'Tagum', 'Davao', 'Philippines'),
(18, 'CUST-018', 'Rina Navarro', 'Retail', 'Davao City', 'Davao', 'Philippines'),
(19, 'CUST-019', 'Sam Chan', 'Retail', 'Passi', 'Iloilo', 'Philippines'),
(20, 'CUST-020', 'Tina Lopez', 'Retail', 'Iloilo City', 'Iloilo', 'Philippines');
INSERT INTO dim_region (region_key, region_name, country) VALUES
(1, 'Cebu', 'Philippines'),
(2, 'Manila', 'Philippines'),
(3, 'Davao', 'Philippines'),
(4, 'Iloilo', 'Philippines');
INSERT INTO fact_sales (sales_line_key, order_number, date_key, customer_key, product_key, region_key, quantity_ordered, unit_price, discount_amount, gross_sales_amount, net_sales_amount, cost_amount, profit_amount, return_flag, return_quantity) VALUES
(1, 'SO-2025-0001', 20250322, 20, 10, 4, 1, 850.00, 0.00, 850.00, 850.00, 460.00, 390.00, 0, 0),
(2, 'SO-2025-0001', 20250322, 20, 1, 4, 1, 220.00, 0.00, 220.00, 220.00, 120.00, 100.00, 0, 0),
(3, 'SO-2025-0002', 20250113, 13, 3, 3, 2, 210.00, 0.00, 420.00, 420.00, 230.00, 190.00, 0, 0),
(4, 'SO-2025-0002', 20250113, 13, 7, 3, 2, 1450.00, 0.00, 2900.00, 2900.00, 1780.00, 1120.00, 0, 0),
(5, 'SO-2025-0002', 20250113, 13, 2, 3, 2, 180.00, 0.00, 360.00, 360.00, 150.00, 210.00, 0, 0),
(6, 'SO-2025-0003', 20250323, 18, 2, 3, 1, 180.00, 0.00, 180.00, 180.00, 75.00, 105.00, 0, 0),
(7, 'SO-2025-0004', 20250210, 13, 3, 3, 1, 210.00, 21.00, 210.00, 189.00, 115.00, 74.00, 0, 0),
(8, 'SO-2025-0005', 20250325, 16, 4, 4, 4, 250.00, 50.00, 1000.00, 950.00, 440.00, 510.00, 0, 0),
(9, 'SO-2025-0006', 20250313, 18, 3, 3, 2, 210.00, 42.00, 420.00, 378.00, 230.00, 148.00, 0, 0),
(10, 'SO-2025-0007', 20250118, 17, 5, 3, 2, 1450.00, 0.00, 2900.00, 2900.00, 1780.00, 1120.00, 0, 0),
(11, 'SO-2025-0008', 20250329, 14, 6, 2, 1, 1450.00, 145.00, 1450.00, 1305.00, 890.00, 415.00, 0, 0),
(12, 'SO-2025-0009', 20250312, 1, 7, 1, 1, 1450.00, 145.00, 1450.00, 1305.00, 890.00, 415.00, 0, 0),
(13, 'SO-2025-0009', 20250312, 1, 9, 1, 1, 310.00, 0.00, 310.00, 310.00, 150.00, 160.00, 0, 0),
(14, 'SO-2025-0010', 20250203, 17, 8, 3, 1, 950.00, 0.00, 950.00, 950.00, 530.00, 420.00, 0, 0),
(15, 'SO-2025-0011', 20250323, 17, 6, 3, 1, 1450.00, 0.00, 1450.00, 1450.00, 890.00, 560.00, 0, 0),
(16, 'SO-2025-0012', 20250309, 1, 6, 1, 1, 1450.00, 0.00, 1450.00, 1450.00, 890.00, 560.00, 0, 0),
(17, 'SO-2025-0012', 20250309, 1, 10, 1, 3, 850.00, 0.00, 2550.00, 2550.00, 1380.00, 1170.00, 0, 0),
(18, 'SO-2025-0013', 20250314, 3, 1, 2, 1, 220.00, 0.00, 220.00, 220.00, 120.00, 100.00, 0, 0),
(19, 'SO-2025-0014', 20250117, 5, 7, 4, 4, 1450.00, 0.00, 5800.00, 5800.00, 3560.00, 2240.00, 0, 0),
(20, 'SO-2025-0014', 20250117, 5, 10, 4, 1, 850.00, 0.00, 850.00, 850.00, 460.00, 390.00, 0, 0),
(21, 'SO-2025-0015', 20250330, 7, 8, 2, 1, 950.00, 0.00, 950.00, 950.00, 530.00, 420.00, 0, 0),
(22, 'SO-2025-0015', 20250330, 7, 5, 2, 1, 1450.00, 0.00, 1450.00, 1450.00, 890.00, 560.00, 1, 1),
(23, 'SO-2025-0016', 20250130, 19, 2, 4, 1, 180.00, 0.00, 180.00, 180.00, 75.00, 105.00, 0, 0),
(24, 'SO-2025-0016', 20250130, 19, 10, 4, 3, 850.00, 0.00, 2550.00, 2550.00, 1380.00, 1170.00, 0, 0),
(25, 'SO-2025-0017', 20250304, 7, 5, 2, 2, 1450.00, 290.00, 2900.00, 2610.00, 1780.00, 830.00, 0, 0),
(26, 'SO-2025-0018', 20250302, 14, 2, 2, 1, 180.00, 9.00, 180.00, 171.00, 75.00, 96.00, 0, 0),
(27, 'SO-2025-0019', 20250107, 4, 1, 1, 2, 220.00, 0.00, 440.00, 440.00, 240.00, 200.00, 0, 0),
(28, 'SO-2025-0020', 20250227, 5, 4, 4, 1, 250.00, 0.00, 250.00, 250.00, 110.00, 140.00, 0, 0),
(29, 'SO-2025-0021', 20250312, 4, 1, 1, 5, 220.00, 0.00, 1100.00, 1100.00, 600.00, 500.00, 0, 0),
(30, 'SO-2025-0022', 20250131, 6, 4, 1, 1, 250.00, 12.50, 250.00, 237.50, 110.00, 127.50, 0, 0),
(31, 'SO-2025-0022', 20250131, 6, 2, 1, 1, 180.00, 9.00, 180.00, 171.00, 75.00, 96.00, 0, 0),
(32, 'SO-2025-0022', 20250131, 6, 9, 1, 1, 310.00, 15.50, 310.00, 294.50, 150.00, 144.50, 0, 0),
(33, 'SO-2025-0023', 20250313, 16, 2, 4, 1, 180.00, 0.00, 180.00, 180.00, 75.00, 105.00, 0, 0),
(34, 'SO-2025-0023', 20250313, 16, 5, 4, 2, 1450.00, 0.00, 2900.00, 2900.00, 1780.00, 1120.00, 1, 2),
(35, 'SO-2025-0024', 20250309, 6, 1, 1, 1, 220.00, 0.00, 220.00, 220.00, 120.00, 100.00, 0, 0),
(36, 'SO-2025-0024', 20250309, 6, 10, 1, 1, 850.00, 85.00, 850.00, 765.00, 460.00, 305.00, 0, 0),
(37, 'SO-2025-0025', 20250321, 3, 4, 2, 2, 250.00, 50.00, 500.00, 450.00, 220.00, 230.00, 0, 0),
(38, 'SO-2025-0025', 20250321, 3, 3, 2, 2, 210.00, 0.00, 420.00, 420.00, 230.00, 190.00, 0, 0),
(39, 'SO-2025-0026', 20250327, 10, 5, 4, 4, 1450.00, 0.00, 5800.00, 5800.00, 3560.00, 2240.00, 1, 1),
(40, 'SO-2025-0027', 20250128, 17, 3, 3, 4, 210.00, 0.00, 840.00, 840.00, 460.00, 380.00, 0, 0),
(41, 'SO-2025-0028', 20250121, 15, 9, 1, 2, 310.00, 62.00, 620.00, 558.00, 300.00, 258.00, 0, 0),
(42, 'SO-2025-0029', 20250309, 1, 7, 1, 2, 1450.00, 0.00, 2900.00, 2900.00, 1780.00, 1120.00, 0, 0),
(43, 'SO-2025-0029', 20250309, 1, 2, 1, 1, 180.00, 0.00, 180.00, 180.00, 75.00, 105.00, 0, 0),
(44, 'SO-2025-0030', 20250206, 20, 2, 4, 1, 180.00, 0.00, 180.00, 180.00, 75.00, 105.00, 0, 0),
(45, 'SO-2025-0031', 20250107, 3, 7, 2, 3, 1450.00, 0.00, 4350.00, 4350.00, 2670.00, 1680.00, 1, 1),
(46, 'SO-2025-0032', 20250203, 6, 8, 1, 2, 950.00, 95.00, 1900.00, 1805.00, 1060.00, 745.00, 0, 0),
(47, 'SO-2025-0032', 20250203, 6, 1, 1, 4, 220.00, 0.00, 880.00, 880.00, 480.00, 400.00, 0, 0),
(48, 'SO-2025-0033', 20250316, 18, 2, 3, 1, 180.00, 0.00, 180.00, 180.00, 75.00, 105.00, 0, 0),
(49, 'SO-2025-0033', 20250316, 18, 10, 3, 5, 850.00, 0.00, 4250.00, 4250.00, 2300.00, 1950.00, 0, 0),
(50, 'SO-2025-0034', 20250201, 4, 3, 1, 2, 210.00, 21.00, 420.00, 399.00, 230.00, 169.00, 0, 0);

INSERT INTO fact_sales (sales_line_key, order_number, date_key, customer_key, product_key, region_key, quantity_ordered, unit_price, discount_amount, gross_sales_amount, net_sales_amount, cost_amount, profit_amount, return_flag, return_quantity) VALUES
(51, 'SO-2025-0035', 20250131, 6, 12, 1, 1, 38500.00, 1925.00, 38500.00, 36575.00, 29000.00, 7575.00, 1, 1),
(52, 'SO-2025-0035', 20250131, 6, 9, 1, 1, 310.00, 0.00, 310.00, 310.00, 150.00, 160.00, 0, 0),
(53, 'SO-2025-0036', 20250114, 13, 10, 3, 3, 850.00, 0.00, 2550.00, 2550.00, 1380.00, 1170.00, 0, 0),
(54, 'SO-2025-0036', 20250114, 13, 3, 3, 3, 210.00, 0.00, 630.00, 630.00, 345.00, 285.00, 0, 0),
(55, 'SO-2025-0037', 20250221, 11, 3, 1, 1, 210.00, 0.00, 210.00, 210.00, 115.00, 95.00, 0, 0),
(56, 'SO-2025-0037', 20250221, 11, 5, 1, 2, 1450.00, 290.00, 2900.00, 2610.00, 1780.00, 830.00, 0, 0),
(57, 'SO-2025-0038', 20250203, 6, 6, 1, 5, 1450.00, 0.00, 7250.00, 7250.00, 4450.00, 2800.00, 1, 4),
(58, 'SO-2025-0039', 20250210, 14, 6, 2, 1, 1450.00, 72.50, 1450.00, 1377.50, 890.00, 487.50, 0, 0),
(59, 'SO-2025-0040', 20250106, 14, 1, 2, 4, 220.00, 88.00, 880.00, 792.00, 480.00, 312.00, 0, 0),
(60, 'SO-2025-0041', 20250327, 7, 4, 2, 1, 250.00, 0.00, 250.00, 250.00, 110.00, 140.00, 0, 0),
(61, 'SO-2025-0041', 20250327, 7, 7, 2, 1, 1450.00, 0.00, 1450.00, 1450.00, 890.00, 560.00, 0, 0),
(62, 'SO-2025-0041', 20250327, 7, 3, 2, 2, 210.00, 42.00, 420.00, 378.00, 230.00, 148.00, 0, 0),
(63, 'SO-2025-0042', 20250218, 6, 6, 1, 1, 1450.00, 145.00, 1450.00, 1305.00, 890.00, 415.00, 0, 0),
(64, 'SO-2025-0043', 20250127, 14, 9, 2, 2, 310.00, 0.00, 620.00, 620.00, 300.00, 320.00, 0, 0),
(65, 'SO-2025-0044', 20250128, 17, 5, 3, 4, 1450.00, 0.00, 5800.00, 5800.00, 3560.00, 2240.00, 0, 0),
(66, 'SO-2025-0045', 20250326, 20, 3, 4, 3, 210.00, 0.00, 630.00, 630.00, 345.00, 285.00, 0, 0),
(67, 'SO-2025-0046', 20250126, 5, 1, 4, 1, 220.00, 11.00, 220.00, 209.00, 120.00, 89.00, 0, 0),
(68, 'SO-2025-0047', 20250228, 14, 10, 2, 2, 850.00, 85.00, 1700.00, 1615.00, 920.00, 695.00, 0, 0),
(69, 'SO-2025-0047', 20250228, 14, 2, 2, 2, 180.00, 0.00, 360.00, 360.00, 150.00, 210.00, 0, 0),
(70, 'SO-2025-0048', 20250114, 14, 2, 2, 3, 180.00, 54.00, 540.00, 486.00, 225.00, 261.00, 0, 0),
(71, 'SO-2025-0048', 20250114, 14, 6, 2, 4, 1450.00, 0.00, 5800.00, 5800.00, 3560.00, 2240.00, 0, 0),
(72, 'SO-2025-0048', 20250114, 14, 9, 2, 2, 310.00, 62.00, 620.00, 558.00, 300.00, 258.00, 0, 0),
(73, 'SO-2025-0049', 20250226, 20, 9, 4, 3, 310.00, 46.50, 930.00, 883.50, 450.00, 433.50, 0, 0),
(74, 'SO-2025-0049', 20250226, 20, 6, 4, 3, 1450.00, 217.50, 4350.00, 4132.50, 2670.00, 1462.50, 0, 0),
(75, 'SO-2025-0049', 20250226, 20, 8, 4, 3, 950.00, 0.00, 2850.00, 2850.00, 1590.00, 1260.00, 0, 0),
(76, 'SO-2025-0050', 20250322, 8, 3, 1, 1, 210.00, 0.00, 210.00, 210.00, 115.00, 95.00, 0, 0),
(77, 'SO-2025-0050', 20250322, 8, 10, 1, 1, 850.00, 0.00, 850.00, 850.00, 460.00, 390.00, 0, 0),
(78, 'SO-2025-0051', 20250128, 3, 4, 2, 1, 250.00, 12.50, 250.00, 237.50, 110.00, 127.50, 0, 0),
(79, 'SO-2025-0051', 20250128, 3, 2, 2, 1, 180.00, 18.00, 180.00, 162.00, 75.00, 87.00, 0, 0),
(80, 'SO-2025-0052', 20250315, 13, 5, 3, 4, 1450.00, 0.00, 5800.00, 5800.00, 3560.00, 2240.00, 0, 0),
(81, 'SO-2025-0053', 20250223, 18, 8, 3, 1, 950.00, 95.00, 950.00, 855.00, 530.00, 325.00, 0, 0),
(82, 'SO-2025-0053', 20250223, 18, 5, 3, 1, 1450.00, 72.50, 1450.00, 1377.50, 890.00, 487.50, 1, 1),
(83, 'SO-2025-0053', 20250223, 18, 7, 3, 2, 1450.00, 0.00, 2900.00, 2900.00, 1780.00, 1120.00, 0, 0),
(84, 'SO-2025-0054', 20250321, 18, 1, 3, 1, 220.00, 22.00, 220.00, 198.00, 120.00, 78.00, 0, 0),
(85, 'SO-2025-0054', 20250321, 18, 4, 3, 3, 250.00, 0.00, 750.00, 750.00, 330.00, 420.00, 1, 2),
(86, 'SO-2025-0054', 20250321, 18, 3, 3, 1, 210.00, 0.00, 210.00, 210.00, 115.00, 95.00, 0, 0),
(87, 'SO-2025-0055', 20250223, 9, 9, 4, 1, 310.00, 31.00, 310.00, 279.00, 150.00, 129.00, 1, 1),
(88, 'SO-2025-0056', 20250109, 2, 8, 3, 4, 950.00, 0.00, 3800.00, 3800.00, 2120.00, 1680.00, 0, 0),
(89, 'SO-2025-0057', 20250131, 5, 5, 4, 1, 1450.00, 0.00, 1450.00, 1450.00, 890.00, 560.00, 0, 0),
(90, 'SO-2025-0057', 20250131, 5, 3, 4, 1, 210.00, 21.00, 210.00, 189.00, 115.00, 74.00, 0, 0),
(91, 'SO-2025-0058', 20250115, 6, 11, 1, 1, 42000.00, 0.00, 42000.00, 42000.00, 31000.00, 11000.00, 0, 0),
(92, 'SO-2025-0058', 20250115, 6, 6, 1, 4, 1450.00, 290.00, 5800.00, 5510.00, 3560.00, 1950.00, 0, 0),
(93, 'SO-2025-0059', 20250110, 19, 7, 4, 2, 1450.00, 0.00, 2900.00, 2900.00, 1780.00, 1120.00, 0, 0),
(94, 'SO-2025-0059', 20250110, 19, 3, 4, 2, 210.00, 0.00, 420.00, 420.00, 230.00, 190.00, 0, 0),
(95, 'SO-2025-0060', 20250106, 12, 5, 4, 2, 1450.00, 0.00, 2900.00, 2900.00, 1780.00, 1120.00, 0, 0),
(96, 'SO-2025-0060', 20250106, 12, 3, 4, 3, 210.00, 31.50, 630.00, 598.50, 345.00, 253.50, 0, 0),
(97, 'SO-2025-0061', 20250323, 15, 8, 1, 1, 950.00, 95.00, 950.00, 855.00, 530.00, 325.00, 0, 0),
(98, 'SO-2025-0061', 20250323, 15, 3, 1, 3, 210.00, 63.00, 630.00, 567.00, 345.00, 222.00, 0, 0),
(99, 'SO-2025-0061', 20250323, 15, 5, 1, 3, 1450.00, 435.00, 4350.00, 3915.00, 2670.00, 1245.00, 0, 0),
(100, 'SO-2025-0062', 20250112, 9, 10, 4, 1, 850.00, 42.50, 850.00, 807.50, 460.00, 347.50, 0, 0);

INSERT INTO fact_sales (sales_line_key, order_number, date_key, customer_key, product_key, region_key, quantity_ordered, unit_price, discount_amount, gross_sales_amount, net_sales_amount, cost_amount, profit_amount, return_flag, return_quantity) VALUES
(101, 'SO-2025-0062', 20250112, 9, 7, 4, 1, 1450.00, 72.50, 1450.00, 1377.50, 890.00, 487.50, 0, 0),
(102, 'SO-2025-0062', 20250112, 9, 2, 4, 1, 180.00, 0.00, 180.00, 180.00, 75.00, 105.00, 0, 0),
(103, 'SO-2025-0063', 20250331, 9, 6, 4, 1, 1450.00, 0.00, 1450.00, 1450.00, 890.00, 560.00, 1, 1),
(104, 'SO-2025-0063', 20250331, 9, 5, 4, 2, 1450.00, 145.00, 2900.00, 2755.00, 1780.00, 975.00, 0, 0),
(105, 'SO-2025-0063', 20250331, 9, 9, 4, 1, 310.00, 0.00, 310.00, 310.00, 150.00, 160.00, 0, 0),
(106, 'SO-2025-0064', 20250326, 19, 4, 4, 2, 250.00, 0.00, 500.00, 500.00, 220.00, 280.00, 0, 0),
(107, 'SO-2025-0065', 20250212, 12, 8, 4, 1, 950.00, 0.00, 950.00, 950.00, 530.00, 420.00, 0, 0),
(108, 'SO-2025-0065', 20250212, 12, 3, 4, 2, 210.00, 0.00, 420.00, 420.00, 230.00, 190.00, 0, 0),
(109, 'SO-2025-0066', 20250205, 19, 12, 4, 1, 38500.00, 0.00, 38500.00, 38500.00, 29000.00, 9500.00, 0, 0),
(110, 'SO-2025-0066', 20250205, 19, 9, 4, 1, 310.00, 0.00, 310.00, 310.00, 150.00, 160.00, 0, 0),
(111, 'SO-2025-0067', 20250310, 5, 3, 4, 5, 210.00, 105.00, 1050.00, 945.00, 575.00, 370.00, 0, 0),
(112, 'SO-2025-0068', 20250323, 16, 1, 4, 1, 220.00, 0.00, 220.00, 220.00, 120.00, 100.00, 0, 0),
(113, 'SO-2025-0068', 20250323, 16, 4, 4, 1, 250.00, 0.00, 250.00, 250.00, 110.00, 140.00, 0, 0),
(114, 'SO-2025-0068', 20250323, 16, 10, 4, 1, 850.00, 0.00, 850.00, 850.00, 460.00, 390.00, 0, 0),
(115, 'SO-2025-0069', 20250322, 2, 2, 3, 3, 180.00, 0.00, 540.00, 540.00, 225.00, 315.00, 0, 0),
(116, 'SO-2025-0070', 20250313, 14, 6, 2, 2, 1450.00, 0.00, 2900.00, 2900.00, 1780.00, 1120.00, 0, 0);
INSERT INTO fact_sales_target (target_key, month_date_key, region_key, revenue_target, order_target, return_limit) VALUES
(1, 20250101, 1, 120000, 20, 2),
(2, 20250101, 2, 110000, 20, 2),
(3, 20250101, 3, 130000, 12, 3),
(4, 20250101, 4, 90000, 15, 3),
(5, 20250201, 1, 100000, 18, 3),
(6, 20250201, 2, 90000, 15, 1),
(7, 20250201, 3, 100000, 12, 1),
(8, 20250201, 4, 90000, 20, 2),
(9, 20250301, 1, 130000, 20, 2),
(10, 20250301, 2, 90000, 15, 2),
(11, 20250301, 3, 110000, 20, 1),
(12, 20250301, 4, 100000, 18, 3);

/* Quick validation */
SELECT 'dim_date' AS table_name, COUNT(*) AS row_count FROM dim_date
UNION ALL SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL SELECT 'dim_region', COUNT(*) FROM dim_region
UNION ALL SELECT 'fact_sales', COUNT(*) FROM fact_sales
UNION ALL SELECT 'fact_sales_target', COUNT(*) FROM fact_sales_target;

SELECT 'fact_sales' AS table_name, COUNT(*) AS rows_count FROM fact_sales
UNION ALL SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL SELECT 'dim_region', COUNT(*) FROM dim_region;

SELECT
    p.category_name,
    COUNT(DISTINCT f.order_number) AS total_orders,
    SUM(f.quantity_ordered) AS total_quantity_sold,
    ROUND(SUM(f.net_sales_amount), 2) AS total_revenue,
    ROUND(SUM(f.profit_amount), 2) AS total_profit,
    ROUND(SUM(f.profit_amount) / NULLIF(SUM(f.net_sales_amount), 0) * 100, 2) AS profit_margin_percent
FROM fact_sales f
JOIN dim_product p ON p.product_key = f.product_key
GROUP BY p.category_name
ORDER BY total_revenue DESC;


-- add the calendar then stack dimensions
SELECT
    DATE_FORMAT(d.calendar_date, '%Y-%m') AS sales_month,
	ROUND(SUM(F.net_sales_amount), 2) AS monthly_revenue
FROM fact_sales f
JOIN dim_date d ON d.date_key = f.date_key
GROUP BY sales_month;

-- actual vs. target revenue
SELECT
    DATE_FORMAT(d.calendar_date, '%Y-%m') AS sales_month,
    r.region_name,

    ROUND(SUM(f.net_sales_amount), 2) AS actual_revenue,
    t.revenue_target,

    ROUND(SUM(f.net_sales_amount) - t.revenue_target, 2) AS revenue_variance,

    ROUND(
        (SUM(f.net_sales_amount) - t.revenue_target)
        / NULLIF(t.revenue_target, 0) * 100,
        2
    ) AS revenue_vs_target_percent

FROM fact_sales f
JOIN dim_date d
    ON d.date_key = f.date_key
JOIN dim_region r
    ON r.region_key = f.region_key
LEFT JOIN fact_sales_target t
    ON t.region_key = f.region_key
   AND t.month_date_key = CAST(CONCAT(DATE_FORMAT(d.calendar_date, '%Y%m'), '01') AS UNSIGNED)

GROUP BY
    DATE_FORMAT(d.calendar_date, '%Y-%m'),
    r.region_name,
    t.revenue_target

ORDER BY
    sales_month,
    r.region_name;

/* write a SQL Query that shows a total revenue per region permonth, along witha running total revenue for each region as the months progress 
(i.e, the running total resets for each region, not all regions). */

with monthly_revenue AS (
SELECT 
	DATE_FORMAT(d.calendar_date, '%Y-%m') AS sales_month,
    ROUND(SUM
    )
FROM fact_sales f
JOIN dim_date d
	ON d.date_key = f.date_key
GROUP

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(d.calendar_date, '%Y-%m') AS sales_month,
        r.region_name,
        SUM(f.net_sales_amount) AS total_revenue
    FROM fact_sales f
    JOIN dim_date d
        ON d.date_key = f.date_key
    JOIN dim_region r
        ON r.region_key = f.region_key
    GROUP BY
        DATE_FORMAT(d.calendar_date, '%Y-%m'),
        r.region_name
)

SELECT
    sales_month,
    region_name,
    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(
        SUM(total_revenue) OVER (
            PARTITION BY region_name
            ORDER BY sales_month
        ),
        2
    ) AS running_total_revenue

FROM monthly_revenue

ORDER BY
    region_name,
    sales_month;

-- Database Creation
CREATE DATABASE RetailChainEDA;
USE RetailChainEDA;

-- Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    CreatedDate DATE DEFAULT CURRENT_DATE
);

-- Product Table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    Stock INT,
    SupplierID INT,
    CreatedDate DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

-- Supplier Table
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactName VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    CreatedDate DATE DEFAULT CURRENT_DATE
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    SaleDate DATE DEFAULT CURRENT_DATE,
    TotalAmount AS (Quantity * Price),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Inventory Table
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY,
    ProductID INT,
    QuantityInStock INT,
    LastUpdated DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Store Table
CREATE TABLE Store (
    StoreID INT PRIMARY KEY,
    StoreName VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    CreatedDate DATE DEFAULT CURRENT_DATE
);



-- Employee Table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Role VARCHAR(50), -- Example roles: 'Manager', 'Cashier', 'Stocker'
    HireDate DATE DEFAULT CURRENT_DATE,
    Salary DECIMAL(10, 2),
    StoreID INT, -- Optional: Default Store Assignment
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);


-- Store Assignment Table (Tracks which store(s) an employee is assigned to)
CREATE TABLE StoreAssignment (
    AssignmentID INT PRIMARY KEY,
    EmployeeID INT,
    StoreID INT,
    AssignmentStartDate DATE DEFAULT CURRENT_DATE,
    AssignmentEndDate DATE, -- Null if currently assigned
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

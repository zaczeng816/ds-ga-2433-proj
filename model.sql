-- TDS: Transactional Sales Table (for live sales data)
CREATE TABLE TDS_Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    SaleDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) GENERATED ALWAYS AS (Quantity * Price),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- TDS: Transactional Customer Interaction Table (for customer service logs)
CREATE TABLE TDS_CustomerInteraction (
    InteractionID INT PRIMARY KEY,
    CustomerID INT,
    InteractionType VARCHAR(50), -- e.g., 'Complaint', 'Inquiry', 'Purchase'
    InteractionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Notes TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);


-- ODS: Sales Snapshot Table (daily snapshots of sales data)
CREATE TABLE ODS_SalesSnapshot (
    SnapshotID INT PRIMARY KEY,
    SaleID INT,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    SaleDate TIMESTAMP,
    TotalAmount DECIMAL(10, 2),
    SnapshotDate DATE DEFAULT CURRENT_DATE, -- Date when snapshot was taken
    FOREIGN KEY (SaleID) REFERENCES TDS_Sales(SaleID)
);

-- ODS: Customer Interaction Snapshot Table
CREATE TABLE ODS_CustomerInteractionSnapshot (
    SnapshotID INT PRIMARY KEY,
    InteractionID INT,
    CustomerID INT,
    InteractionType VARCHAR(50),
    InteractionDate TIMESTAMP,
    SnapshotDate DATE DEFAULT CURRENT_DATE,
    Notes TEXT,
    FOREIGN KEY (InteractionID) REFERENCES TDS_CustomerInteraction(InteractionID)
);


-- DW: Sales History Table (stores historical sales data)
CREATE TABLE DW_SalesHistory (
    HistoryID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    SaleDate TIMESTAMP,
    TotalAmount DECIMAL(10, 2),
    Year INT,
    Month INT,
    Day INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- DW: Customer Interaction History Table (stores historical interactions)
CREATE TABLE DW_CustomerInteractionHistory (
    HistoryID INT PRIMARY KEY,
    CustomerID INT,
    InteractionType VARCHAR(50),
    InteractionDate TIMESTAMP,
    Notes TEXT,
    Year INT,
    Month INT,
    Day INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);



-- DM: Monthly Sales Summary (aggregated for executive reporting)
CREATE TABLE DM_MonthlySales (
    Month INT,
    Year INT,
    StoreID INT,
    TotalSales DECIMAL(15, 2),
    TotalQuantity INT,
    PRIMARY KEY (Month, Year, StoreID),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

-- DM: Customer Interaction Summary (aggregated interaction data)
CREATE TABLE DM_CustomerInteractionSummary (
    Month INT,
    Year INT,
    InteractionType VARCHAR(50),
    TotalInteractions INT,
    PRIMARY KEY (Month, Year, InteractionType)
);

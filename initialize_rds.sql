-- -----------------------------------------------------
-- Core Tables
-- -----------------------------------------------------

-- Customer Table
CREATE TABLE Customer (
    CID VARCHAR(15) PRIMARY KEY,
    CLast VARCHAR(50) NOT NULL,  -- Added NOT NULL for required fields
    CFirst VARCHAR(50) NOT NULL,
    CMiddle VARCHAR(50),         -- Changed from CHAR to VARCHAR for space efficiency
    CSuffix VARCHAR(10),
    CDOB DATE NOT NULL,          -- Birthday should be required
    CSalutation VARCHAR(10),
    CEmailAddress VARCHAR(100),
    Gender CHAR(1) CHECK (Gender IN ('M', 'F', 'U')),
    SSN_TIN VARCHAR(20),
    SSNType VARCHAR(10),
    PreferredLanguage VARCHAR(50),
    StartDate DATE NOT NULL,     -- Should be required for tracking
    EndDate DATE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Added audit fields
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer_name (CLast, CFirst),       -- Added index for name searches
    INDEX idx_customer_email (CEmailAddress)       -- Added index for email lookups
);

-- CustomerAddress Table
CREATE TABLE CustomerAddress (
    AddressID INT AUTO_INCREMENT PRIMARY KEY,  -- Changed PK to auto-increment ID
    CID VARCHAR(15) NOT NULL,
    CAddress VARCHAR(100) NOT NULL,
    CCity VARCHAR(50) NOT NULL,
    CState VARCHAR(20) NOT NULL,
    CZip VARCHAR(10) NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,             -- Added to track active address
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CID) REFERENCES Customer(CID),
    INDEX idx_customer_address (CID)           -- Added index for foreign key
);

-- CustomerImage Table
CREATE TABLE CustomerImage (
    ImageID INT AUTO_INCREMENT PRIMARY KEY,    -- Changed to auto-increment
    CID VARCHAR(15) NOT NULL,
    ImageFileLocation VARCHAR(255) NOT NULL,   -- Cloud Storage URL
    ImageType VARCHAR(50),                     -- Added image type
    UploadDate DATE NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CID) REFERENCES Customer(CID),
    INDEX idx_customer_image (CID)
);

-- -----------------------------------------------------
-- Transaction Tables
-- -----------------------------------------------------

-- Invoice Table (Moved up because Claim references it)
CREATE TABLE Invoice (
    InvoiceNumber VARCHAR(30) PRIMARY KEY,
    CID VARCHAR(15) NOT NULL,
    BillAddress VARCHAR(100) NOT NULL,
    BillCity VARCHAR(50) NOT NULL,
    BillState VARCHAR(20) NOT NULL,
    BillZip VARCHAR(10) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,  -- Added amount field
    PaidDate DATE,
    DueDate DATE NOT NULL,                       -- Added due date
    PaidAheadFlag BOOLEAN DEFAULT FALSE,
    Status VARCHAR(20) DEFAULT 'PENDING',        -- Added status field
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CID) REFERENCES Customer(CID),
    INDEX idx_invoice_customer (CID),
    INDEX idx_invoice_status (Status)
);

-- Claim Table
CREATE TABLE Claim (
    ClaimNumber VARCHAR(30) PRIMARY KEY,
    CID VARCHAR(15) NOT NULL,
    InvoiceNumber VARCHAR(15),
    ClaimDate DATE NOT NULL,
    SettlementDate DATE,
    Status VARCHAR(20) DEFAULT 'PENDING',        -- Added status field
    TotalAmount DECIMAL(10,2) DEFAULT 0.00,      -- Added total amount
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CID) REFERENCES Customer(CID),
    FOREIGN KEY (InvoiceNumber) REFERENCES Invoice(InvoiceNumber),
    INDEX idx_claim_customer (CID),
    INDEX idx_claim_date (ClaimDate)
);

-- ClaimImage Table
CREATE TABLE ClaimImage (
    ImageID INT AUTO_INCREMENT PRIMARY KEY,
    ClaimNumber VARCHAR(30) NOT NULL,
    ImageFileLocation VARCHAR(255) NOT NULL,
    ImageType VARCHAR(50),                      -- Added image type
    UploadDate DATE NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ClaimNumber) REFERENCES Claim(ClaimNumber),
    INDEX idx_claim_image (ClaimNumber)
);

-- ClaimDetail Table
CREATE TABLE ClaimDetail (
    DetailID INT AUTO_INCREMENT PRIMARY KEY,    -- Changed PK to auto-increment ID
    ClaimNumber VARCHAR(30) NOT NULL,
    PlanName VARCHAR(50) NOT NULL,
    ParticipantLastName VARCHAR(50) NOT NULL,
    ParticipantFirstName VARCHAR(50) NOT NULL,
    ParticipantDOB DATE NOT NULL,
    ParticipantMiddleInitial CHAR(1),
    ParticipantSuffix VARCHAR(10),
    ClaimAmount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,  -- Fixed typo in column name
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ClaimNumber) REFERENCES Claim(ClaimNumber),
    INDEX idx_claim_detail (ClaimNumber)
);
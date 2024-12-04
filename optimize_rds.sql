-- 1. INDEXING
-- Add indexes for frequently accessed columns and join conditions

-- Customer table indexes
ALTER TABLE Customer
ADD INDEX idx_customer_search (CLast, CFirst, CDOB),  -- For name-based searches
ADD INDEX idx_customer_ssn (SSN_TIN),                 -- For SSN lookups
ADD INDEX idx_customer_dates (StartDate, EndDate);    -- For date range queries

-- Claim table indexes
ALTER TABLE Claim
ADD INDEX idx_claim_dates (ClaimDate, SettlementDate),  -- For date-based searches
ADD INDEX idx_claim_status_date (Status, ClaimDate),    -- For status monitoring
ADD INDEX idx_claim_amount (TotalAmount);               -- For financial reporting

-- Invoice table indexes
ALTER TABLE Invoice
ADD INDEX idx_invoice_dates (PaidDate, DueDate),        -- For payment tracking
ADD INDEX idx_invoice_status_amount (Status, Amount),   -- For financial analysis
ADD INDEX idx_invoice_paid_flag (PaidAheadFlag);        -- For payment status queries

-- 2. PARTITIONING
-- Partition large tables by date ranges

-- Partition Claims table by year
ALTER TABLE Claim
PARTITION BY RANGE (YEAR(ClaimDate)) (
    PARTITION p_2020 VALUES LESS THAN (2021),
    PARTITION p_2021 VALUES LESS THAN (2022),
    PARTITION p_2022 VALUES LESS THAN (2023),
    PARTITION p_2023 VALUES LESS THAN (2024),
    PARTITION p_2024 VALUES LESS THAN (2025),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Partition Invoice table by year
ALTER TABLE Invoice
PARTITION BY RANGE (YEAR(DueDate)) (
    PARTITION p_2020 VALUES LESS THAN (2021),
    PARTITION p_2021 VALUES LESS THAN (2022),
    PARTITION p_2022 VALUES LESS THAN (2023),
    PARTITION p_2023 VALUES LESS THAN (2024),
    PARTITION p_2024 VALUES LESS THAN (2025),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- 3. MATERIALIZED VIEWS
-- Create materialized views for frequently accessed summary data

-- Customer Claims Summary View
CREATE TABLE mv_customer_claims_summary (
    CID VARCHAR(15),
    TotalClaims INT,
    TotalClaimAmount DECIMAL(10,2),
    LastClaimDate DATE,
    LastSettlementDate DATE,
    UpdatedAt TIMESTAMP,
    PRIMARY KEY (CID),
    INDEX idx_total_amount (TotalClaimAmount)
) AS
SELECT
    c.CID,
    COUNT(cl.ClaimNumber) as TotalClaims,
    SUM(cl.TotalAmount) as TotalClaimAmount,
    MAX(cl.ClaimDate) as LastClaimDate,
    MAX(cl.SettlementDate) as LastSettlementDate,
    NOW() as UpdatedAt
FROM Customer c
LEFT JOIN Claim cl ON c.CID = cl.CID
GROUP BY c.CID;

-- Procedure to refresh materialized view
DELIMITER //
CREATE PROCEDURE refresh_customer_claims_summary()
BEGIN
    TRUNCATE TABLE mv_customer_claims_summary;
    INSERT INTO mv_customer_claims_summary
    SELECT
        c.CID,
        COUNT(cl.ClaimNumber) as TotalClaims,
        SUM(cl.TotalAmount) as TotalClaimAmount,
        MAX(cl.ClaimDate) as LastClaimDate,
        MAX(cl.SettlementDate) as LastSettlementDate,
        NOW() as UpdatedAt
    FROM Customer c
    LEFT JOIN Claim cl ON c.CID = cl.CID
    GROUP BY c.CID;
END //
DELIMITER ;

-- Create event to refresh materialized view daily
CREATE EVENT refresh_claims_summary
ON SCHEDULE EVERY 1 DAY
DO CALL refresh_customer_claims_summary();
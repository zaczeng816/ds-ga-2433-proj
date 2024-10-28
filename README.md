# ds-ga-2433-proj

1. Data Quality
   Data quality is essential to ensure that reports, analytics, and business decisions are based on accurate, complete, and consistent data. Here’s how you can approach data quality in your project:

Data Cleansing:

ETL Process: Implement data cleansing in the ETL (Extract, Transform, Load) processes. Before data is loaded from the TDS (Transactional Data Store) to the ODS (Operational Data Store), perform transformations to:
Remove duplicate entries.
Standardize data formats (e.g., converting all date formats to YYYY-MM-DD).
Ensure that all mandatory fields are populated.
Error Logs: Create logs to track and report cleansing errors. For example, log any data rows that fail validation for manual review.
Data Validation:

Constraint Checks: Add constraints to database tables to enforce data integrity, such as primary and foreign keys, unique constraints, and NOT NULL constraints.
Trigger-Based Validation: Use triggers to automatically validate specific data entries as they are added. For example, ensure that Quantity in a sales transaction is greater than zero.
Automated Data Checks: Schedule daily or weekly automated checks to verify data accuracy, flagging any discrepancies for further review.
Data Consistency:

Master Data Management (MDM): Use MDM principles to keep key data (like Customer and Product information) consistent across TDS, ODS, DW, and DM. Update master records consistently and ensure they propagate to other storage areas.
Periodic Audits: Perform periodic audits to check for data inconsistencies across systems, especially between the ODS and DW. 2. Data Retention
Define how long different types of data are kept, and establish protocols for archiving and deletion:

Retention Periods:

Transactional Data (TDS): Keep transactional data for a short period, like 30–90 days, as this data is primarily for recent, operational purposes.
Operational Data (ODS): Retain ODS snapshots for about 1 year. This allows for historical reporting without accumulating excessive data.
Data Warehouse (DW): Retain historical data in the DW for 5–7 years, which enables long-term trend analysis and meets typical regulatory requirements.
Data Mart (DM): Since the DM contains aggregated reports, it can retain data for 2–3 years to support department-specific reporting needs.
Archiving and Deletion:

Archiving Process: Use scheduled ETL jobs to move data from TDS and ODS to long-term storage (e.g., an archival database or cloud storage) based on retention timelines.
Data Deletion: Implement a periodic deletion process where data exceeding the retention period is permanently removed from active databases.
Backup and Recovery: Before deletion, ensure that archived data is backed up to prevent loss and facilitate data recovery. 3. Security and Compliance
Develop policies to ensure data privacy, security, and compliance with relevant regulations (e.g., GDPR, CCPA):

Data Access Control:

Role-Based Access Control (RBAC): Restrict access based on roles (e.g., Admin, Analyst, Manager). Only authorized personnel should have access to sensitive data (e.g., customer information).
Encryption: Use encryption for sensitive fields (e.g., personally identifiable information like email and phone numbers) both in transit and at rest.
Data Privacy:

Anonymization: For analytics and reporting, anonymize or mask personal information (like customer names and contact details) when identifiable information is not required.
Data Minimization: Only collect and retain necessary information. For example, store only minimal customer details needed for business purposes.
Privacy Compliance: Regularly review data handling practices to ensure compliance with data privacy laws like GDPR or CCPA. Maintain consent logs to show customer consent for data collection.
Audit Trails and Monitoring:

Audit Logs: Maintain logs for any data access, update, or deletion activities, allowing traceability of actions for security audits.
Monitoring: Set up alerts for unusual access patterns or potential breaches, especially for sensitive data. 4. Documentation
Governance Policies:

Document all data quality procedures, retention timelines, archiving protocols, and access control policies.
Include detailed descriptions of how your database tables are set up to enforce constraints, validations, and data cleansing practices.
Data Retention Policies:

Specify retention periods for each data storage type (TDS, ODS, DW, DM) and describe the archiving and deletion workflows.
Include any legal or regulatory compliance requirements that justify the retention periods.
Security and Compliance Documentation:

Document security measures, including encryption methods, anonymization practices, access control roles, and audit trail configurations.
Outline compliance protocols and explain how your system aligns with relevant data privacy laws.

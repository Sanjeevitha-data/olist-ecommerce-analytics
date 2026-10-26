\# Brazilian E-Commerce Analytics | Olist



\## Project Overview

An end-to-end e-commerce analytics project using the Brazilian Olist marketplace dataset. The project transforms raw transactional data into business insights using Python, PostgreSQL, SQL, and Power BI.



The analysis focuses on sales performance, customer behavior, product categories, payments, delivery performance, seller performance, and customer reviews.



\## Business Questions

\- How do delivered item sales change over time?

\- Which product categories generate the highest delivered sales?

\- What are the customer purchasing and repeat-purchase patterns?

\- Which payment methods are most commonly used?

\- How does delivery performance relate to customer satisfaction?

\- How do sellers and product categories perform?



\## Tools and Technologies

\- \*\*Python:\*\* Data loading and ETL

\- \*\*PostgreSQL:\*\* Relational database and data storage

\- \*\*SQL:\*\* Business analysis and KPI calculations

\- \*\*Power BI:\*\* Interactive dashboard and reporting



\## Key Findings

\- \*\*99,441\*\* total orders

\- \*\*96,096\*\* unique customers

\- \*\*R$13.22 million\*\* in delivered item sales

\- \*\*4.09 / 5\*\* average review score

\- \*\*12.56 days\*\* average delivery time

\- \*\*8.11%\*\* late delivery rate among delivered orders



The analysis also identified an association between late deliveries and lower review scores. This is an observed relationship, not proof that delivery delays alone caused lower ratings.



\## Dashboard

The Power BI report contains two pages:



1\. \*\*Executive Overview:\*\* Order volume, delivered item sales, customer count, monthly sales trend, top product categories, and order status.

2\. \*\*Customer \& Operations:\*\* Delivery KPIs and customer review score distribution.
### Executive Overview
![Executive Overview](executive_overview.png)

### Customer & Operations
![Customer & Operations](customer_operations.png)



\## SQL Analysis

The `sql/` directory contains 12 scripts covering:



01\. `01\_business\_overview.sql`

02\. `02\_revenue\_analysis.sql`

03\. `03\_customer\_analytics.sql`

04\. `04\_product\_performance.sql`

05\. `05\_payment\_analysis.sql`

06\. `06\_review\_analysis.sql`

07\. `07\_delivery\_performance.sql`

08\. `08\_monthly\_sales\_trend.sql`

09\. `09\_customer\_segments.sql`

10\. `10\_delivery\_review\_analysis.sql`

11\. `11\_seller\_performance.sql`

12\. `12\_executive\_kpi\_summary.sql`



\## Project Structure

```text

ecommerce\_customer\_analytics/

├── src/

│   └── etl.py

├── raw/

├── processed/

├── sql/

│   └── 12 SQL analysis scripts

├── powerbi/

│   └── Olist\_Ecommerce\_Analytics.pbix

└── README.md

```



\## How to Reproduce

1\. Create a PostgreSQL database named `ecommerce\_analytics`.

2\. Configure the database connection used by `src/etl.py`.

3\. Run the ETL script to load the source CSV files into PostgreSQL.

4\. Execute the SQL scripts in the `sql/` directory.

5\. Open the Power BI report in `powerbi/` and configure the database connection.



\## Data Notes and Limitations

\- The project uses historical Olist marketplace data from 2016–2018; it is not a live-data dashboard.

\- Delivered item sales are based on item prices for delivered orders.

\- Product costs are unavailable, so profit and profit margin are not calculated.

\- Delivery performance compares actual delivery dates with estimated delivery dates.

\- The relationship between delivery timing and review scores should be interpreted as an association, not causation.



\## Author

Created as an analytics portfolio project demonstrating Python ETL, PostgreSQL, SQL analysis, and Power BI reporting.


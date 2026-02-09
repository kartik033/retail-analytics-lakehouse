# Retail Analytics Lakehouse (AWS + Athena + dbt)

Built a production-style analytics lakehouse using **Amazon S3**, **AWS Glue**, **Amazon Athena**, and **dbt**.  
Raw retail order data is ingested into S3, standardized into partitioned Parquet, and modeled into analytics-ready marts (fact/dim + metrics).

---

## Architecture

**Layers**
- **Raw (S3):** immutable source files (CSV)
- **Cleaned (S3 Parquet):** standardized schema + partitioned by `order_date`
- **Analytics (dbt on Athena):** staging → marts (fact, dims, metrics) with automated tests

See: `architecture.md`

---

## Tech Stack
- **Storage:** Amazon S3
- **Catalog:** AWS Glue Data Catalog
- **Query:** Amazon Athena
- **Transformations + Tests:** dbt (athena adapter) + dbt_expectations
- **Version Control:** Git/GitHub

---

## Data Model (Star Schema)
### Fact
- `fact_orders` (incremental)
  - Uses composite key `order_line_key = order_id + '-' + product_id`
  - Supports scalable refresh and prevents duplicates

### Dimensions
- `dim_products`

### Metrics
- `revenue_daily`

---

## Data Quality
Implemented dbt tests:
- `not_null`, `unique`
- Range checks for `discount_percent`
- Business logic handling for returns:
  - `is_return` flag in staging
  - `list_price_clean` and `revenue_clean` computed for sales rows
  - Conditional tests applied only for `is_return = false`

---

## How to Run (Local dbt)
> Assumes AWS credentials configured and Athena/Glue/S3 already set up.

```bash
cd dbt
python -m venv dbt-env
# Windows PowerShell:
.\dbt-env\Scripts\Activate.ps1
pip install dbt-athena-community
dbt deps
dbt debug
dbt run
dbt test

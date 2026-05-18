# Enterprise Workforce Lakehouse

## Project Overview

Enterprise Workforce Lakehouse is a production-style workforce analytics platform designed using modern data engineering and data warehousing principles.

The project simulates enterprise-scale HR, payroll, and workforce event processing using a layered Lakehouse architecture:

```text
Raw → ODS → Data Warehouse → Gold Layer → Analytics
```

The platform focuses on:

- Incremental data processing
- Historical tracking
- Scalable ETL design
- Data quality and observability
- Workforce analytics

---

## Architecture

```text
Raw Layer
    ↓
ODS Layer
    ↓
Data Warehouse (SCD Type 2)
    ↓
Gold Analytics Layer
    ↓
Power BI / Reporting
```

---

## Key Features

### Incremental Data Processing

- Watermark-based incremental loading
- Hash-based change detection
- Snapshot-based ingestion

### Data Warehouse Modeling

- SCD Type 2 dimensions
- Snapshot fact tables
- Historical workforce analytics
- Point-in-time reporting

### Event-Driven Processing

- HR events pipeline
- Append-only event architecture
- Late-arriving event handling

### Gold Analytics Layer

- Business-friendly analytics views
- KPI-ready datasets
- Attrition analytics
- Payroll analytics

### Observability & Data Quality

- Pipeline monitoring
- Data quality checks
- FAIL vs WARN logic
- Operational monitoring views

---

## Technologies Used

| Technology | Purpose |
|---|---|
| SQL Server | Data Warehouse |
| T-SQL | ETL & Data Processing |
| Python | Synthetic Data Generation |
| Power BI | Analytics & Reporting |
| GitHub | Version Control |

---

## Data Volumes

| Dataset | Volume |
|---|---|
| HR Core Snapshots | 1M+ rows/day |
| Snapshot Fact Table | 7M+ rows |
| Payroll Data | 100K+ rows |
| HR Events | 50K+ events |

---

## Enterprise Concepts Implemented

- Incremental ETL Processing
- Watermark Logic
- Hash-Based Change Detection
- Slowly Changing Dimensions (SCD Type 2)
- Snapshot Fact Tables
- Event-Driven Pipelines
- Late Arriving Data Handling
- Gold Layer Modeling
- Data Quality Framework
- Pipeline Observability

---

## Repository Structure

```text
sql/
python/
docs/
screenshots/
```

---

## Future Improvements

- Apache Airflow orchestration
- Cloud deployment (Azure / AWS)
- Delta Lake implementation
- Spark-based distributed processing
- CI/CD pipeline integration

---

## Author

Elham Masoumi

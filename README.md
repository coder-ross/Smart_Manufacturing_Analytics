🚀 Smart Manufacturing Analytics

This project explores a smart manufacturing operations dataset to understand delays, machine performance, energy usage, and overall production efficiency.
The goal is to transform raw production data into meaningful KPIs and insights to support better planning, maintenance, and decision-making.

📌 Project Objectives

Measure job delays and on-time completion rate

Identify machine-level performance differences and bottlenecks

Analyze production throughput trends over time

Study energy consumption patterns and efficiency

Build an interactive Power BI dashboard (in progress)

Document insights for operational improvement

📁 Dataset Summary

Source: Kaggle — Smart Manufacturing Dataset

Cleaned dataset: data/cleaned_manufacturing_data.csv

Total records: ~1000 jobs

📌 Key fields include:

Job_ID, Machine_ID, Operation_Type

Processing_Time, Energy_Consumption

Scheduled_Start, Actual_Start

Job_Status, Optimization_Category

Additional engineered columns:

Delay_Minutes

Actual_Processing_Time

Energy_per_Minute

🧠 What’s Done So Far

✔ Loaded and cleaned dataset using Python
✔ Converted timestamp columns to proper datetime format
✔ Engineered new calculated fields for insights
✔ Uploaded cleaned dataset and notebook to repository
✔ Imported cleaned data into SQL Server
✔ Wrote 12 analytical SQL queries (KPIs + machine comparisons + trends)
✔ Generated insights summary based on real results

📄 Insights document: docs/insights_summary.md
🧾 SQL queries: sql/analysis_queries.sql

📊 Key Findings (Short Version)

Nearly half of all jobs experienced delays

Average delay ≈ 3.9 minutes per job

Machine M05 shows the highest delay and is likely a bottleneck

Machine M01 is the most efficient based on delay + volume

Energy usage correlates strongly with job duration — reducing delays helps control energy waste

More detail available in the insights report.

📈 Power BI Dashboard (In Progress)

Planned dashboard features:

KPI Cards: Total jobs, average delay, on-time %, avg energy

Charts:

Delay by machine (bar chart)

Job status breakdown (donut chart)

Daily throughput trend (line chart)

Filters: Machine ID + operation type

📁 File location :   powerbi/Smart_Manufacturing_Report.pbix

🧰 Tech Stack
Category	Tools
Data Preparation	Python (Pandas, NumPy)
Database & Analytics	SQL Server + T-SQL
Visualization	Power BI (DirectQuery)
Version Control	Git & GitHub
📦 Deliverables (Complete + Planned)
Deliverable	Status
Cleaned dataset	✔ Done
Python Jupyter notebook	✔ Done
SQL query library	✔ Done
Insights summary	✔ Done
Power BI report	⏳ In progress
Final README	🔄 Updating
👤 Author


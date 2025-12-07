\# Smart Manufacturing Analytics



This project analyzes a smart manufacturing job dataset to build operational KPIs and uncover insights about performance, delays, energy usage, and machine efficiency.



---



\## 📌 Project Goals



\- Evaluate job scheduling efficiency (delays vs on-time completion)

\- Analyse machine-level performance and utilization

\- Measure throughput trends across time

\- Study energy consumption patterns to identify efficiency opportunities

\- Build a Power BI dashboard for interactive reporting

\- Document insights for decision-making and optimization



---



\## 📁 Dataset



\- Source: Kaggle - Smart Manufacturing Dataset

\- Cleaned file used in project: `data/cleaned\_manufacturing\_data.csv`

\- Rows: ~1000 jobs  

\- Example fields:  

&nbsp; - `Job\_ID`, `Machine\_ID`, `Operation\_Type`  

&nbsp; - `Processing\_Time`, `Energy\_Consumption`, `Machine\_Availability`  

&nbsp; - `Scheduled\_Start`, `Actual\_Start`, `Job\_Status`



---



\## 🛠 Current Progress



✔ Loaded and inspected the dataset  

✔ Converted timestamp columns to datetime format  

✔ Handled missing values and formatted data  

✔ Created new calculated fields:

\- `Delay\_Minutes`

\- `Actual\_Processing\_Time`

\- `Energy\_per\_Minute`



✔ Computed initial KPIs for delay, efficiency, and throughput  

✔ Uploaded cleaned dataset and notebook to GitHub



---



\## 🚧 Next Steps



\- Add SQL analytical queries (machine bottlenecks, trends, failures)

\- Build Power BI dashboard (Overview | Machine Utilization | Energy | Trends)

\- Document business insights and summary

\- Add visualizations to `images/` folder



---



\## 📦 Tech Stack



| Area | Tools |

|------|-------|

| Data Cleaning | Python (Pandas, NumPy) |

| Analytics | SQL (coming next) |

| Visualization | Power BI |

| Version Control | Git + GitHub |



---



\## 📈 Final Deliverables (Planned)



\- 📊 Power BI report  

\- 📁 SQL query collection  

\- 📓 Final notebook with insights  

\- 🧾 Executive summary with KPIs and recommendations  



---



\## 👤 Author



\*\*Coder Ross (GitHub: coder-ross)\*\*  

Smart Manufacturing | Data Analytics | Continuous Improvement






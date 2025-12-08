-- ============================================================
-- Smart Manufacturing Analytics - SQL Analysis Queries
-- Table: SmartManufacturingDB.dbo.ManufacturingJobs
-- ============================================================

---------------------------------------------------------------
-- 1) Overall delay and throughput KPIs
--    Question: How many jobs are we handling, and how bad are delays overall?
---------------------------------------------------------------
SELECT
    COUNT(*) AS Total_Jobs,
    AVG(Delay_Minutes) AS Avg_Delay_Minutes,
    MAX(Delay_Minutes) AS Max_Delay_Minutes,
    SUM(CASE WHEN Delay_Minutes > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Percent_Jobs_Delayed,
    AVG(Actual_Processing_Time) AS Avg_Actual_Processing_Minutes
FROM dbo.ManufacturingJobs;


---------------------------------------------------------------
-- 2) Daily throughput and average delay
--    Question: How many jobs are completed each day, and how does average delay change over time?
---------------------------------------------------------------
SELECT
    CAST(Actual_End AS DATE) AS Production_Date,
    COUNT(*) AS Jobs_Completed,
    AVG(Delay_Minutes) AS Avg_Delay_Minutes
FROM dbo.ManufacturingJobs
GROUP BY CAST(Actual_End AS DATE)
ORDER BY Production_Date;


---------------------------------------------------------------
-- 3) Machine-level performance summary
--    Question: Which machines are busiest and which suffer the highest average delay?
---------------------------------------------------------------
SELECT
    Machine_ID,
    COUNT(*) AS Job_Count,
    AVG(Delay_Minutes) AS Avg_Delay_Minutes,
    SUM(Delay_Minutes) AS Total_Delay_Minutes,
    AVG(Actual_Processing_Time) AS Avg_Processing_Minutes,
    AVG(Energy_per_Minute) AS Avg_Energy_per_Minute
FROM dbo.ManufacturingJobs
GROUP BY Machine_ID
ORDER BY Avg_Delay_Minutes DESC;  -- most delayed machines first


---------------------------------------------------------------
-- 4) Machine utilization proxy
--    Question: For each machine, roughly what fraction of its calendar window is spent processing jobs?
---------------------------------------------------------------
WITH MachineWindow AS (
    SELECT
        Machine_ID,
        MIN(Scheduled_Start) AS First_Start,
        MAX(Scheduled_End) AS Last_End,
        SUM(Actual_Processing_Time) AS Total_Processing_Minutes
    FROM dbo.ManufacturingJobs
    GROUP BY Machine_ID
)
SELECT
    Machine_ID,
    Total_Processing_Minutes,
    DATEDIFF(MINUTE, First_Start, Last_End) AS Calendar_Window_Minutes,
    CAST(Total_Processing_Minutes AS FLOAT) /
        NULLIF(DATEDIFF(MINUTE, First_Start, Last_End), 0) AS Utilization_Proxy
FROM MachineWindow
ORDER BY Utilization_Proxy DESC;   -- highest utilization at the top


---------------------------------------------------------------
-- 5) Operation-type performance
--    Question: Which operation types are fastest and most energy-efficient?
---------------------------------------------------------------
SELECT
    Operation_Type,
    COUNT(*) AS Job_Count,
    AVG(Actual_Processing_Time) AS Avg_Processing_Minutes,
    AVG(Delay_Minutes) AS Avg_Delay_Minutes,
    AVG(Energy_Consumption) AS Avg_Energy_per_Job,
    AVG(Energy_per_Minute) AS Avg_Energy_per_Minute
FROM dbo.ManufacturingJobs
GROUP BY Operation_Type
ORDER BY Avg_Energy_per_Minute;    -- more efficient (lower) first


---------------------------------------------------------------
-- 6) Job status breakdown (Completed / Delayed / Failed)
--    Question: How do different job outcomes compare in delay, duration, and energy usage?
---------------------------------------------------------------
SELECT
    Job_Status,
    COUNT(*) AS Job_Count,
    AVG(Delay_Minutes) AS Avg_Delay_Minutes,
    AVG(Actual_Processing_Time) AS Avg_Processing_Minutes,
    AVG(Energy_Consumption) AS Avg_Energy_per_Job
FROM dbo.ManufacturingJobs
GROUP BY Job_Status
ORDER BY Job_Count DESC;


---------------------------------------------------------------
-- 7) Optimization category vs real performance
--    Question: Do High / Moderate / Low efficiency categories match actual performance?
---------------------------------------------------------------
SELECT
    Optimization_Category,
    COUNT(*) AS Job_Count,
    AVG(Delay_Minutes) AS Avg_Delay_Minutes,
    AVG(Actual_Processing_Time) AS Avg_Processing_Minutes,
    AVG(Energy_per_Minute) AS Avg_Energy_per_Minute
FROM dbo.ManufacturingJobs
GROUP BY Optimization_Category
ORDER BY Avg_Energy_per_Minute;   -- lower energy per minute = better


---------------------------------------------------------------
-- 8) Delay bucket distribution
--    Question: How many jobs fall into each delay range (on time, 0–5 min, 6–15 min, etc.)?
---------------------------------------------------------------
WITH DelayBuckets AS (
    SELECT
        CASE 
            WHEN Delay_Minutes <= 0 THEN 'On Time or Early'
            WHEN Delay_Minutes <= 5 THEN '0–5 min'
            WHEN Delay_Minutes <= 15 THEN '6–15 min'
            WHEN Delay_Minutes <= 30 THEN '16–30 min'
            ELSE '30+ min'
        END AS Delay_Bucket
    FROM dbo.ManufacturingJobs
)
SELECT
    Delay_Bucket,
    COUNT(*) AS Job_Count,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dbo.ManufacturingJobs) AS Percent_of_Jobs
FROM DelayBuckets
GROUP BY Delay_Bucket
ORDER BY 
    CASE Delay_Bucket
        WHEN 'On Time or Early' THEN 1
        WHEN '0–5 min' THEN 2
        WHEN '6–15 min' THEN 3
        WHEN '16–30 min' THEN 4
        ELSE 5
    END;


---------------------------------------------------------------
-- 9) Machines with worse-than-average delay
--    Question: Which machines have average delay higher than the overall average delay?
---------------------------------------------------------------
WITH Overall AS (
    SELECT AVG(Delay_Minutes) AS Overall_Avg_Delay
    FROM dbo.ManufacturingJobs
)
SELECT
    m.Machine_ID,
    COUNT(*) AS Job_Count,
    AVG(m.Delay_Minutes) AS Machine_Avg_Delay,
    o.Overall_Avg_Delay
FROM dbo.ManufacturingJobs m
CROSS JOIN Overall o
GROUP BY m.Machine_ID, o.Overall_Avg_Delay
HAVING AVG(m.Delay_Minutes) > o.Overall_Avg_Delay
ORDER BY Machine_Avg_Delay DESC;


---------------------------------------------------------------
-- 10) Top 10 worst jobs by delay and energy
--     Question: Which specific jobs look like extreme problem cases?
---------------------------------------------------------------
SELECT TOP 10
    Job_ID,
    Machine_ID,
    Operation_Type,
    Delay_Minutes,
    Actual_Processing_Time,
    Energy_per_Minute,
    Job_Status
FROM dbo.ManufacturingJobs
ORDER BY Delay_Minutes DESC, Energy_per_Minute DESC;


---------------------------------------------------------------
-- 11) Daily throughput with 3-day moving average
--     Question: Is throughput stable, improving, or dropping over time?
---------------------------------------------------------------
WITH Daily AS (
    SELECT
        CAST(Actual_End AS DATE) AS Production_Date,
        COUNT(*) AS Jobs_Completed
    FROM dbo.ManufacturingJobs
    GROUP BY CAST(Actual_End AS DATE)
)
SELECT
    Production_Date,
    Jobs_Completed,
    AVG(Jobs_Completed) OVER (
        ORDER BY Production_Date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Jobs_Completed_3Day_MA
FROM Daily
ORDER BY Production_Date;


---------------------------------------------------------------
-- 12) Machine vs status mix (Completed / Delayed / Failed)
--     Question: For each machine, what is the mix of completed, delayed, and failed jobs?
---------------------------------------------------------------
SELECT
    Machine_ID,
    SUM(CASE WHEN Job_Status = 'Completed' THEN 1 ELSE 0 END) AS Completed_Jobs,
    SUM(CASE WHEN Job_Status = 'Delayed'   THEN 1 ELSE 0 END) AS Delayed_Jobs,
    SUM(CASE WHEN Job_Status = 'Failed'    THEN 1 ELSE 0 END) AS Failed_Jobs,
    SUM(CASE WHEN Job_Status = 'Delayed'   THEN 1 ELSE 0 END) * 1.0 /
        NULLIF(SUM(CASE WHEN Job_Status IN ('Completed','Delayed','Failed') THEN 1 ELSE 0 END), 0)
        AS Delayed_Ratio
FROM dbo.ManufacturingJobs
GROUP BY Machine_ID
ORDER BY Delayed_Ratio DESC;   -- machines with highest delay ratio on top

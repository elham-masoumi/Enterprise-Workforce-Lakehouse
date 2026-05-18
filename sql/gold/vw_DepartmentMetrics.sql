CREATE OR ALTER VIEW gold.vw_DepartmentMetrics
AS
SELECT
    SnapshotDate,
    DepartmentCode,
    COUNT(*) AS Headcount,
    SUM(CAST(IsTerminated AS INT)) AS TerminatedEmployees,
    CAST
    (
        100.0 * SUM(CAST(IsTerminated AS INT))
        / NULLIF(COUNT(*),0)
        AS DECIMAL(5,2)
    ) AS AttritionRate
FROM gold.vw_WorkforceAnalytics
GROUP BY
    SnapshotDate,
    DepartmentCode;
GO
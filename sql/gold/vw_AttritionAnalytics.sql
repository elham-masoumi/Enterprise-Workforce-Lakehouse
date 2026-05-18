CREATE OR ALTER VIEW gold.vw_AttritionAnalytics
AS
SELECT
    SnapshotDate,
    COUNT(*) AS TotalEmployees,
    SUM(CAST(IsTerminated AS INT)) AS Leavers,
    CAST
    (
        100.0 * SUM(CAST(IsTerminated AS INT))
        / NULLIF(COUNT(*),0)
        AS DECIMAL(5,2)
    ) AS AttritionRate
FROM gold.vw_WorkforceAnalytics
GROUP BY SnapshotDate;
GO
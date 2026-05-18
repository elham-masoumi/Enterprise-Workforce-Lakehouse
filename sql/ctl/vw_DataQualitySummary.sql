CREATE OR ALTER VIEW ctl.vw_DataQualitySummary
AS
SELECT
    DatasetName,
    Severity,
    COUNT(*) AS TotalIssues,
    MAX(CheckDateTime) AS LastDetected
FROM ctl.DataQualityIssues
GROUP BY
    DatasetName,
    Severity;
GO
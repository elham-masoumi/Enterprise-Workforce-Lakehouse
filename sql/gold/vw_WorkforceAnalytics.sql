CREATE OR ALTER VIEW gold.vw_WorkforceAnalytics
AS
SELECT
    f.SnapshotDate,
    d.EmployeeKey,
    d.EmployeeNaturalId,
    d.Gender,
    d.HireDate,
    d.DepartmentCode,
    d.JobCode,
    d.Location,
    d.EmploymentStatus,
    f.IsActive,
    f.IsTerminated,
    DATEDIFF(YEAR, d.HireDate, f.SnapshotDate) AS TenureYears
FROM dw.FactEmployeeSnapshot f
INNER JOIN dw.DimEmployee d
    ON f.EmployeeKey = d.EmployeeKey;
GO
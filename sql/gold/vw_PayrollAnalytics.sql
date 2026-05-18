CREATE OR ALTER VIEW gold.vw_PayrollAnalytics
AS
SELECT
    p.PayMonth,
    p.EmployeeNaturalId,
    d.DepartmentCode,
    d.JobCode,
    d.Location,
    p.BaseSalary,
    p.BonusAmount,
    p.BaseSalary + p.BonusAmount AS TotalCompensation
FROM ods.Payroll_Current p
LEFT JOIN dw.DimEmployee d
    ON p.EmployeeNaturalId = d.EmployeeNaturalId
   AND d.IsCurrent = 1;
GO
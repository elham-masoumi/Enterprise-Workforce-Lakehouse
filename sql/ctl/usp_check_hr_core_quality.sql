CREATE OR ALTER PROCEDURE ctl.usp_check_hr_core_quality
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM ctl.DataQualityIssues
    WHERE DatasetName = 'HR_Core';

    INSERT INTO ctl.DataQualityIssues
    (
        DatasetName,
        RuleName,
        Severity,
        AffectedRows,
        IssueDetails
    )
    SELECT
        'HR_Core',
        'Invalid EmploymentStatus',
        'WARN',
        COUNT(*),
        'Unexpected EmploymentStatus values detected'
    FROM ods.Employee_Current
    WHERE EmploymentStatus NOT IN
    (
        'Active',
        'Terminated',
        'Leave'
    )
    HAVING COUNT(*) > 0;

    INSERT INTO ctl.DataQualityIssues
    (
        DatasetName,
        RuleName,
        Severity,
        AffectedRows,
        IssueDetails
    )
    SELECT
        'HR_Core',
        'Future Hire Dates',
        'WARN',
        COUNT(*),
        'HireDate is in the future'
    FROM ods.Employee_Current
    WHERE HireDate > CAST(GETDATE() AS DATE)
    HAVING COUNT(*) > 0;
END;
GO
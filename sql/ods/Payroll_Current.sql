CREATE TABLE ods.Payroll_Current
(
    EmployeeNaturalId VARCHAR(20) NOT NULL,
    PayMonth DATE NOT NULL,
    BaseSalary DECIMAL(18,2),
    BonusAmount DECIMAL(18,2),
    LoadDate DATE
);
GO
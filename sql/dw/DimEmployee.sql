CREATE TABLE dw.DimEmployee
(
    EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeNaturalId VARCHAR(20) NOT NULL,
    Gender VARCHAR(10),
    HireDate DATE,
    DepartmentCode VARCHAR(20),
    JobCode VARCHAR(20),
    Location VARCHAR(100),
    EmploymentStatus VARCHAR(20),
    EffectiveStartDate DATE NOT NULL,
    EffectiveEndDate DATE NULL,
    IsCurrent BIT NOT NULL
);
GO
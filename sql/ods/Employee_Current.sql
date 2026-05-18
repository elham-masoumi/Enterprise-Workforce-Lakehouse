CREATE TABLE ods.Employee_Current
(
    EmployeeNaturalId VARCHAR(20) NOT NULL PRIMARY KEY,
    Gender VARCHAR(10),
    HireDate DATE,
    DepartmentCode VARCHAR(20),
    JobCode VARCHAR(20),
    Location VARCHAR(100),
    EmploymentStatus VARCHAR(20),
    SourceLoadDate DATE,
    RecordHash VARBINARY(32)
);
GO
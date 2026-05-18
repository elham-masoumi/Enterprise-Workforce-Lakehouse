CREATE TABLE dw.FactEmployeeSnapshot
(
    SnapshotDate DATE NOT NULL,
    EmployeeKey INT NOT NULL,
    IsActive BIT,
    IsTerminated BIT
);
GO
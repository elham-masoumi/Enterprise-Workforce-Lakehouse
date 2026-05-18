CREATE OR ALTER PROCEDURE dw.usp_load_dim_employee_scd2
    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRAN;

        UPDATE tgt
        SET
            EffectiveEndDate = DATEADD(DAY, -1, @SnapshotDate),
            IsCurrent = 0
        FROM dw.DimEmployee tgt
        INNER JOIN ods.Employee_Current src
            ON tgt.EmployeeNaturalId = src.EmployeeNaturalId
        WHERE tgt.IsCurrent = 1
          AND
          (
                tgt.DepartmentCode <> src.DepartmentCode
             OR tgt.JobCode <> src.JobCode
             OR tgt.Location <> src.Location
             OR tgt.EmploymentStatus <> src.EmploymentStatus
          );

        INSERT INTO dw.DimEmployee
        (
            EmployeeNaturalId,
            Gender,
            HireDate,
            DepartmentCode,
            JobCode,
            Location,
            EmploymentStatus,
            EffectiveStartDate,
            EffectiveEndDate,
            IsCurrent
        )
        SELECT
            src.EmployeeNaturalId,
            src.Gender,
            src.HireDate,
            src.DepartmentCode,
            src.JobCode,
            src.Location,
            src.EmploymentStatus,
            @SnapshotDate,
            NULL,
            1
        FROM ods.Employee_Current src
        LEFT JOIN dw.DimEmployee dim
            ON src.EmployeeNaturalId = dim.EmployeeNaturalId
           AND dim.IsCurrent = 1
        WHERE dim.EmployeeNaturalId IS NULL
           OR
           (
                dim.DepartmentCode <> src.DepartmentCode
             OR dim.JobCode <> src.JobCode
             OR dim.Location <> src.Location
             OR dim.EmploymentStatus <> src.EmploymentStatus
           );

        COMMIT;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;

    END CATCH
END;
GO
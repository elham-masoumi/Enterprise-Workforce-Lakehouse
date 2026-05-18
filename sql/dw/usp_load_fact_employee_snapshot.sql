CREATE OR ALTER PROCEDURE dw.usp_load_fact_employee_snapshot
    @SnapshotDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRAN;

        DELETE FROM dw.FactEmployeeSnapshot
        WHERE SnapshotDate = @SnapshotDate;

        INSERT INTO dw.FactEmployeeSnapshot
        (
            SnapshotDate,
            EmployeeKey,
            IsActive,
            IsTerminated
        )
        SELECT
            @SnapshotDate,
            dim.EmployeeKey,
            CASE
                WHEN dim.EmploymentStatus = 'Active'
                THEN 1
                ELSE 0
            END,
            CASE
                WHEN dim.EmploymentStatus <> 'Active'
                THEN 1
                ELSE 0
            END
        FROM dw.DimEmployee dim
        WHERE dim.EffectiveStartDate <= @SnapshotDate
          AND
          (
                dim.EffectiveEndDate IS NULL
                OR dim.EffectiveEndDate >= @SnapshotDate
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
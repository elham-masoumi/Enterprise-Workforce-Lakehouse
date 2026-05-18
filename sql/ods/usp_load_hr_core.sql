CREATE OR ALTER PROCEDURE ods.usp_load_hr_core
            (
                EmployeeNaturalId,
                Gender,
                HireDate,
                DepartmentCode,
                JobCode,
                Location,
                EmploymentStatus,
                SourceLoadDate,
                RecordHash
            )
            VALUES
            (
                src.EmployeeNaturalId,
                src.Gender,
                src.HireDate,
                src.DepartmentCode,
                src.JobCode,
                src.Location,
                src.EmploymentStatus,
                src.SourceLoadDate,
                src.RecordHash
            );

        SET @UpdatedRows = @@ROWCOUNT;

        UPDATE ctl.DatasetWatermark
        SET
            LastProcessedPartition = CONVERT(VARCHAR(20), @PartitionDate, 23),
            LastSuccessfulLoadDatetime = SYSDATETIME()
        WHERE DatasetName = 'hr_core';

        UPDATE ctl.PipelineRun
        SET
            EndTime = SYSDATETIME(),
            Status = 'Success',
            SourceRowCount = @SourceRowCount,
            TargetRowCount = (SELECT COUNT(*) FROM ods.Employee_Current),
            UpdatedRowCount = @UpdatedRows
        WHERE RunId = @RunId;

    END TRY
    BEGIN CATCH

        UPDATE ctl.PipelineRun
        SET
            EndTime = SYSDATETIME(),
            Status = 'Failed',
            ErrorMessage = ERROR_MESSAGE()
        WHERE RunId = SCOPE_IDENTITY();

        THROW;

    END CATCH
END;
GO
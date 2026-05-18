CREATE OR ALTER VIEW ctl.vw_PipelineMonitoring
AS
SELECT
    PipelineName,
    Status,
    COUNT(*) AS ExecutionCount,
    AVG(DATEDIFF(SECOND, StartTime, EndTime)) AS AvgDurationSeconds,
    MAX(EndTime) AS LastExecutionTime,
    SUM(ISNULL(SourceRowCount,0)) AS TotalSourceRows,
    SUM(ISNULL(InsertedRowCount,0)) AS TotalInsertedRows,
    SUM(ISNULL(UpdatedRowCount,0)) AS TotalUpdatedRows
FROM ctl.PipelineRun
GROUP BY
    PipelineName,
    Status;
GO
CREATE TABLE ctl.PipelineRun
(
    RunId INT IDENTITY(1,1) PRIMARY KEY,
    PipelineName VARCHAR(200),
    StartTime DATETIME2,
    EndTime DATETIME2,
    Status VARCHAR(50),
    TriggerType VARCHAR(50),
    Notes VARCHAR(500),
    SourceRowCount INT,
    TargetRowCount INT,
    InsertedRowCount INT,
    UpdatedRowCount INT,
    ErrorMessage VARCHAR(MAX)
);
GO
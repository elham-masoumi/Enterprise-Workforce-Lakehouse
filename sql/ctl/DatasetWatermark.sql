CREATE TABLE ctl.DatasetWatermark
(
    DatasetName VARCHAR(100) PRIMARY KEY,
    LastSuccessfulLoadDatetime DATETIME2,
    LastProcessedPartition VARCHAR(50)
);
GO
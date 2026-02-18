/*
    Table: dbo.EmployeeStatistics
    Purpose: Store snapshot metrics (e.g. active/inactive employee counts) for reporting and trending.
    Populated by SQL Server Agent job EmployeeStatistics_Daily.
*/
CREATE TABLE [dbo].[EmployeeStatistics] (
    [StatisticId]          INT              IDENTITY (1, 1) NOT NULL,
    [StatisticDescription] NVARCHAR(200)    NOT NULL,
    [StatisticDate]        DATETIME2(7)     NOT NULL,
    [StatisticValue]       INT              NOT NULL,
    CONSTRAINT [PK_dbo_EmployeeStatistics] PRIMARY KEY CLUSTERED ([StatisticId] ASC)
);

GO
CREATE NONCLUSTERED INDEX [IX_dbo_EmployeeStatistics_StatisticDate]
    ON [dbo].[EmployeeStatistics] ([StatisticDate] ASC);

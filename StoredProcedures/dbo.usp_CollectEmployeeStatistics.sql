/*
    Stored Procedure: dbo.usp_CollectEmployeeStatistics
    Purpose: Inserts current active and inactive employee counts into dbo.EmployeeStatistics.
    Used by SQL Server Agent job EmployeeStatistics_Daily (daily at 1:15 PM).
*/
CREATE PROCEDURE [dbo].[usp_CollectEmployeeStatistics]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATETIME2(7) = GETDATE();

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO dbo.EmployeeStatistics (StatisticDescription, StatisticDate, StatisticValue)
        SELECT N'Active Employees', @SnapshotDate, COUNT(*)
        FROM dbo.Employee
        WHERE IsActive = 1
        UNION ALL
        SELECT N'Inactive Employees', @SnapshotDate, COUNT(*)
        FROM dbo.Employee
        WHERE IsActive = 0;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

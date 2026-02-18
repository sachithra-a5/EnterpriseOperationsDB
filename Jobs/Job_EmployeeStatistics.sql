/*
    SQL Server Agent Job: EmployeeStatistics_Daily
    Created/updated from PostDeployment. Re-runnable: checks if job exists.
    Schedule: Daily at 1:15 PM. Executes dbo.usp_CollectEmployeeStatistics to insert counts into dbo.EmployeeStatistics.
    Runs in a separate batch (GO after previous script in PostDeployment) so @JobId, @JobName, @ScheduleId can be reused.
*/
DECLARE @JobId UNIQUEIDENTIFIER;
DECLARE @JobName SYSNAME = N'EmployeeStatistics_Daily';

-- Check if job already exists
SELECT @JobId = job_id FROM msdb.dbo.sysjobs WHERE name = @JobName;

IF @JobId IS NULL
BEGIN
    -- Create new job
    EXEC msdb.dbo.sp_add_job
        @job_name = @JobName,
        @enabled = 1,
        @owner_login_name = N'sa',
        @description = N'Runs dbo.usp_CollectEmployeeStatistics to collect active/inactive employee counts (SSDT PostDeployment).';

    SELECT @JobId = job_id FROM msdb.dbo.sysjobs WHERE name = @JobName;
END
ELSE
BEGIN
    -- Update existing job (ensure enabled and description)
    EXEC msdb.dbo.sp_update_job
        @job_id = @JobId,
        @enabled = 1,
        @owner_login_name = N'sa',
        @description = N'Runs dbo.usp_CollectEmployeeStatistics to collect active/inactive employee counts (SSDT PostDeployment).';
END

-- If job already existed, remove step 1 so we can re-add (keeps script idempotent)
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobsteps WHERE job_id = @JobId AND step_id = 1)
    EXEC msdb.dbo.sp_delete_jobstep @job_id = @JobId, @step_id = 1;

-- Add step 1: execute the stored procedure that collects employee statistics
EXEC msdb.dbo.sp_add_jobstep
    @job_id = @JobId,
    @step_name = N'Collect employee statistics',
    @step_id = 1,
    @subsystem = N'TSQL',
    @command = N'EXEC dbo.usp_CollectEmployeeStatistics;',
    @database_name = N'$(DatabaseName)',
    @on_success_action = 1,  -- Quit with success
    @on_fail_action = 2;     -- Quit with failure

-- Add or update schedule: daily at 1:15 PM
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobschedules js
               INNER JOIN msdb.dbo.sysschedules s ON js.schedule_id = s.schedule_id
               WHERE js.job_id = @JobId AND s.name = N'Daily_1_15PM')
BEGIN
    DECLARE @ScheduleId INT;
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name = N'Daily_1_15PM',
        @freq_type = 4,               -- Daily
        @freq_interval = 1,           -- Every 1 day
        @active_start_time = 131500;   -- 1:15:00 PM (13:15)

    SELECT @ScheduleId = schedule_id FROM msdb.dbo.sysschedules WHERE name = N'Daily_1_15PM';
    EXEC msdb.dbo.sp_attach_schedule @job_id = @JobId, @schedule_id = @ScheduleId;
END

-- Ensure job is assigned to local server
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobservers WHERE job_id = @JobId)
    EXEC msdb.dbo.sp_add_jobserver @job_id = @JobId;

PRINT 'Job EmployeeStatistics_Daily created or updated.';

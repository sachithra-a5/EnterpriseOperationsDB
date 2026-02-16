/*
    SQL Server Agent Job: Maintenance_EnterpriseOperations
    Created/updated from PostDeployment. Re-runnable: checks if job exists.
    Schedule: Daily at 2:00 AM.
*/
DECLARE @JobId UNIQUEIDENTIFIER;
DECLARE @JobName SYSNAME = N'Maintenance_EnterpriseOperations';

-- Check if job already exists
SELECT @JobId = job_id FROM msdb.dbo.sysjobs WHERE name = @JobName;

IF @JobId IS NULL
BEGIN
    -- Create new job
    EXEC msdb.dbo.sp_add_job
        @job_name = @JobName,
        @enabled = 1,
        @description = N'EnterpriseOperationsDB maintenance job (created by SSDT PostDeployment).';

    SELECT @JobId = job_id FROM msdb.dbo.sysjobs WHERE name = @JobName;
END
ELSE
BEGIN
    -- Update existing job (ensure enabled and description)
    EXEC msdb.dbo.sp_update_job
        @job_id = @JobId,
        @enabled = 1,
        @description = N'EnterpriseOperationsDB maintenance job (created by SSDT PostDeployment).';
END

-- If job already existed, remove step 1 so we can re-add (keeps script idempotent)
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobsteps WHERE job_id = @JobId AND step_id = 1)
    EXEC msdb.dbo.sp_delete_jobstep @job_id = @JobId, @step_id = 1;

-- Add step 1: simple T-SQL (placeholder for real maintenance)
EXEC msdb.dbo.sp_add_jobstep
    @job_id = @JobId,
    @step_name = N'Run maintenance',
    @step_id = 1,
    @subsystem = N'TSQL',
    @command = N'SELECT 1; /* Placeholder: replace with actual maintenance (e.g. index rebuild, stats update) */',
    @database_name = N'$(DatabaseName)',
    @on_success_action = 1,  -- Quit with success
    @on_fail_action = 2;      -- Quit with failure

-- Add or update schedule: daily at 2:00 AM
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobschedules js
               INNER JOIN msdb.dbo.sysschedules s ON js.schedule_id = s.schedule_id
               WHERE js.job_id = @JobId AND s.name = N'Daily_2AM')
BEGIN
    DECLARE @ScheduleId INT;
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name = N'Daily_2AM',
        @freq_type = 4,              -- Daily
        @freq_interval = 1,          -- Every 1 day
        @active_start_time = 020000; -- 2:00:00 AM

    SELECT @ScheduleId = schedule_id FROM msdb.dbo.sysschedules WHERE name = N'Daily_2AM';
    EXEC msdb.dbo.sp_attach_schedule @job_id = @JobId, @schedule_id = @ScheduleId;
END

-- Ensure job is assigned to local server
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobservers WHERE job_id = @JobId)
    EXEC msdb.dbo.sp_add_jobserver @job_id = @JobId;

PRINT 'Job Maintenance_EnterpriseOperations created or updated.';

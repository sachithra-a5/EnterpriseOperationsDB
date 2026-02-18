/*
    SQL Server Agent Job: Job_ExportEmployeeData
    Runs a PowerShell script that writes static data to D:\SQLJobs\Output\EmployeeExport_<timestamp>.txt.
    Logs to D:\SQLJobs\Logs\ExportEmployeeData_<timestamp>.log.
    Created/updated from PostDeployment. Re-runnable: checks if job exists (same pattern as other jobs).
    Schedule: Daily at 1:00 PM. PowerShell script path: D:\SQLJobs\Powershell\ExportEmployeeData.ps1
    Runs in a separate batch (GO after previous script in PostDeployment) so local variables do not collide.
*/
BEGIN TRY
    -- Ensure job category "Data Maintenance" exists
    IF NOT EXISTS (SELECT 1 FROM msdb.dbo.syscategories WHERE category_class = 1 AND name = N'Data Maintenance')
        EXEC msdb.dbo.sp_add_category @class = N'JOB', @type = N'LOCAL', @name = N'Data Maintenance';

    DECLARE @JobId UNIQUEIDENTIFIER;
    DECLARE @JobName SYSNAME = N'Job_ExportEmployeeData';

    -- Check if job already exists
    SELECT @JobId = job_id FROM msdb.dbo.sysjobs WHERE name = @JobName;

    IF @JobId IS NULL
    BEGIN
        -- Create new job
        EXEC msdb.dbo.sp_add_job
            @job_name = @JobName,
            @enabled = 1,
            @owner_login_name = N'sa',
            @category_name = N'Data Maintenance',
            @description = N'Writes static export to D:\SQLJobs\Output\ via PowerShell script (SSDT PostDeployment).';

        SELECT @JobId = job_id FROM msdb.dbo.sysjobs WHERE name = @JobName;
    END
    ELSE
    BEGIN
        -- Update existing job (ensure enabled, owner, category, description)
        EXEC msdb.dbo.sp_update_job
            @job_id = @JobId,
            @enabled = 1,
            @owner_login_name = N'sa',
            @category_name = N'Data Maintenance',
            @description = N'Writes static export to D:\SQLJobs\Output\ via PowerShell script (SSDT PostDeployment).';
    END

    -- If job already existed, remove step 1 so we can re-add (keeps script idempotent)
    IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobsteps WHERE job_id = @JobId AND step_id = 1)
        EXEC msdb.dbo.sp_delete_jobstep @job_id = @JobId, @step_id = 1;

    -- Add step 1: PowerShell – run script and propagate exit code
    EXEC msdb.dbo.sp_add_jobstep
        @job_id = @JobId,
        @step_name = N'Run ExportEmployeeData.ps1',
        @step_id = 1,
        @subsystem = N'PowerShell',
        @command = N'& ''D:\SQLJobs\Powershell\ExportEmployeeData.ps1''; exit $LASTEXITCODE',
        @on_success_action = 1,  -- Quit with success
        @on_fail_action = 2;     -- Quit with failure

    -- Add or update schedule: daily at 1:00 PM (attach only if not already attached)
    IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobschedules js
                   INNER JOIN msdb.dbo.sysschedules s ON js.schedule_id = s.schedule_id
                   WHERE js.job_id = @JobId AND s.name = N'Daily_1PM_Export')
    BEGIN
        DECLARE @ScheduleId INT;
        EXEC msdb.dbo.sp_add_schedule
            @schedule_name = N'Daily_1PM_Export',
            @freq_type = 4,               -- Daily
            @freq_interval = 1,           -- Every 1 day
            @active_start_time = 130000;  -- 1:00:00 PM (13:00)

        SELECT @ScheduleId = schedule_id FROM msdb.dbo.sysschedules WHERE name = N'Daily_1PM_Export';
        EXEC msdb.dbo.sp_attach_schedule @job_id = @JobId, @schedule_id = @ScheduleId;
    END

    -- Ensure job is assigned to local server
    IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobservers WHERE job_id = @JobId)
        EXEC msdb.dbo.sp_add_jobserver @job_id = @JobId;

    PRINT 'Job Job_ExportEmployeeData created or updated.';
END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(N'Job_ExportEmployeeData deployment failed: %s', 16, 1, @ErrMsg);
END CATCH

/*
    Trigger: dbo.trg_Employee_Insert
    Type: AFTER INSERT
    Table: dbo.Employee
    Purpose: Log each insert into dbo.EmployeeAudit (EmployeeId, EmployeeCode, Action, ActionDate).
    Captured columns in EmployeeAudit: EmployeeId, EmployeeCode, Action, ActionDate.
    Fires once per INSERT statement; inserted may contain multiple rows.
*/
CREATE TRIGGER [dbo].[trg_Employee_Insert]
ON [dbo].[Employee]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Captured columns in EmployeeAudit: EmployeeId, EmployeeCode, Action, ActionDate.
    -- inserted holds the row(s) just inserted; we log one audit row per row with Action = 'INSERT'.
    INSERT INTO [dbo].[EmployeeAudit] ([EmployeeId], [EmployeeCode], [Action], [ActionDate])
    SELECT
        i.[EmployeeId],
        i.[EmployeeCode],
        N'INSERT',
        GETDATE()
    FROM [inserted] i;
END;
GO

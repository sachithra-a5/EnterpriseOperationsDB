/*
    Trigger: dbo.trg_Employee_Insert
    Type: AFTER INSERT
    Table: dbo.Employee
    Purpose: Log each insert into dbo.EmployeeAudit (EmployeeId, Action, ActionDate).
    Fires once per INSERT statement; inserted may contain multiple rows.
*/
CREATE TRIGGER [dbo].[trg_Employee_Insert]
ON [dbo].[Employee]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Log each inserted row: EmployeeId, action type, and timestamp.
    -- inserted is a table that holds the row(s) that were just inserted.
    INSERT INTO [dbo].[EmployeeAudit] ([EmployeeId], [Action], [ActionDate])
    SELECT
        i.[EmployeeId],
        N'INSERT',
        GETDATE()
    FROM [inserted] i;
END;
GO

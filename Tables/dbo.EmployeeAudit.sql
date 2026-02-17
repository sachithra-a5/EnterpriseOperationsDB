/*
    Table: dbo.EmployeeAudit
    Purpose: Audit log for dbo.Employee actions (e.g. INSERT). Written by trg_Employee_Insert.
*/
CREATE TABLE [dbo].[EmployeeAudit] (
    [AuditId]     INT              IDENTITY (1, 1) NOT NULL,
    [EmployeeId]  INT              NOT NULL,
    [EmployeeCode] NVARCHAR(20)    NULL,
    [Action]      NVARCHAR(20)     NOT NULL,
    [ActionDate]  DATETIME2(7)     NOT NULL CONSTRAINT [DF_dbo_EmployeeAudit_ActionDate] DEFAULT (GETDATE()),
    CONSTRAINT [PK_dbo_EmployeeAudit] PRIMARY KEY CLUSTERED ([AuditId] ASC),
    CONSTRAINT [FK_dbo_EmployeeAudit_dbo_Employee] FOREIGN KEY ([EmployeeId]) REFERENCES [dbo].[Employee] ([EmployeeId])
);

GO
CREATE NONCLUSTERED INDEX [IX_dbo_EmployeeAudit_EmployeeId]
    ON [dbo].[EmployeeAudit] ([EmployeeId] ASC);

GO
CREATE NONCLUSTERED INDEX [IX_dbo_EmployeeAudit_ActionDate]
    ON [dbo].[EmployeeAudit] ([ActionDate] ASC);

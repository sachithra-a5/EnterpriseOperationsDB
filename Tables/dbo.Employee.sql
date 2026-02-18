/*
    Table: dbo.Employee
    Purpose: Employees; references hr.Department and config.Status.
*/
CREATE TABLE [dbo].[Employee] (
    [EmployeeId]   INT              IDENTITY (1, 1) NOT NULL,
    [EmployeeCode] NVARCHAR(20)     NOT NULL,
    [FullName]     NVARCHAR(500)    NOT NULL,
    [EmailAddress] NVARCHAR(150)    NULL,
    [DepartmentId] INT              NOT NULL,
    [StatusId]     INT              NOT NULL,
    [CreatedDate]  DATETIME2(7)     NOT NULL CONSTRAINT [DF_dbo_Employee_CreatedDate] DEFAULT (GETDATE()),
    [ModifiedDate] DATETIME2(7)     NOT NULL CONSTRAINT [DF_dbo_Employee_ModifiedDate] DEFAULT (GETDATE()),
    [IsActive]     BIT              NOT NULL CONSTRAINT [DF_dbo_Employee_IsActive] DEFAULT (1),
    [PhoneNumber]  NVARCHAR(20) NULL, 
    CONSTRAINT [PK_dbo_Employee] PRIMARY KEY CLUSTERED ([EmployeeId] ASC),
    CONSTRAINT [FK_dbo_Employee_hr_Department] FOREIGN KEY ([DepartmentId]) REFERENCES [hr].[Department] ([DepartmentId]),
    CONSTRAINT [FK_dbo_Employee_config_Status] FOREIGN KEY ([StatusId]) REFERENCES [config].[Status] ([StatusId]),
    CONSTRAINT [UQ_dbo_Employee_EmployeeCode] UNIQUE ([EmployeeCode])
);

GO
-- Unique emails for non-NULL values only; multiple NULLs allowed (filtered index).
CREATE UNIQUE NONCLUSTERED INDEX [UQ_dbo_Employee_EmailAddress]
    ON [dbo].[Employee] ([EmailAddress] ASC)
    WHERE [EmailAddress] IS NOT NULL;

GO
-- Covering index: seek by DepartmentId and return FullName without key lookups.
CREATE NONCLUSTERED INDEX [IX_dbo_Employee_DepartmentId]
    ON [dbo].[Employee] ([DepartmentId] ASC)
    INCLUDE ([FullName]);

GO
CREATE NONCLUSTERED INDEX [IX_dbo_Employee_StatusId]
    ON [dbo].[Employee] ([StatusId] ASC);

GO
CREATE NONCLUSTERED INDEX [IX_dbo_Employee_IsActive]
    ON [dbo].[Employee] ([IsActive] ASC);

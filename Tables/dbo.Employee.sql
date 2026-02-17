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
    CONSTRAINT [PK_dbo_Employee] PRIMARY KEY CLUSTERED ([EmployeeId] ASC),
    CONSTRAINT [FK_dbo_Employee_hr_Department] FOREIGN KEY ([DepartmentId]) REFERENCES [hr].[Department] ([DepartmentId]),
    CONSTRAINT [FK_dbo_Employee_config_Status] FOREIGN KEY ([StatusId]) REFERENCES [config].[Status] ([StatusId]),
    CONSTRAINT [UQ_dbo_Employee_EmployeeCode] UNIQUE ([EmployeeCode])
);

GO
CREATE NONCLUSTERED INDEX [IX_dbo_Employee_DepartmentId]
    ON [dbo].[Employee] ([DepartmentId] ASC);

GO
CREATE NONCLUSTERED INDEX [IX_dbo_Employee_StatusId]
    ON [dbo].[Employee] ([StatusId] ASC);

GO
CREATE NONCLUSTERED INDEX [IX_dbo_Employee_IsActive]
    ON [dbo].[Employee] ([IsActive] ASC);

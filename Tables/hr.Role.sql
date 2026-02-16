/*
    Table: hr.Role
    Purpose: Role lookup; belongs to a department.
*/
CREATE TABLE [hr].[Role] (
    [RoleId]       INT              IDENTITY (1, 1) NOT NULL,
    [RoleCode]     NVARCHAR(20)     NOT NULL,
    [RoleName]     NVARCHAR(100)    NOT NULL,
    [DepartmentId] INT              NOT NULL,
    [CreatedDate]  DATETIME2(7)     NOT NULL CONSTRAINT [DF_hr_Role_CreatedDate] DEFAULT (GETDATE()),
    [ModifiedDate] DATETIME2(7)     NOT NULL CONSTRAINT [DF_hr_Role_ModifiedDate] DEFAULT (GETDATE()),
    [IsActive]     BIT              NOT NULL CONSTRAINT [DF_hr_Role_IsActive] DEFAULT (1),
    CONSTRAINT [PK_hr_Role] PRIMARY KEY CLUSTERED ([RoleId] ASC),
    CONSTRAINT [FK_hr_Role_hr_Department] FOREIGN KEY ([DepartmentId]) REFERENCES [hr].[Department] ([DepartmentId]),
    CONSTRAINT [UQ_hr_Role_RoleCode] UNIQUE ([RoleCode])
);

GO
CREATE NONCLUSTERED INDEX [IX_hr_Role_DepartmentId]
    ON [hr].[Role] ([DepartmentId] ASC);

GO
CREATE NONCLUSTERED INDEX [IX_hr_Role_IsActive]
    ON [hr].[Role] ([IsActive] ASC);

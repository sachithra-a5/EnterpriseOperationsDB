/*
    Table: hr.Department
    Purpose: Department lookup for HR (used by Role and Employee).
*/
CREATE TABLE [hr].[Department] (
    [DepartmentId]   INT              IDENTITY (1, 1) NOT NULL,
    [DepartmentCode] NVARCHAR(20)     NOT NULL,
    [DepartmentName] NVARCHAR(100)    NOT NULL,
    [CreatedDate]    DATETIME2(7)      NOT NULL CONSTRAINT [DF_hr_Department_CreatedDate] DEFAULT (GETDATE()),
    [ModifiedDate]   DATETIME2(7)      NOT NULL CONSTRAINT [DF_hr_Department_ModifiedDate] DEFAULT (GETDATE()),
    [IsActive]       BIT              NOT NULL CONSTRAINT [DF_hr_Department_IsActive] DEFAULT (1),
    CONSTRAINT [PK_hr_Department] PRIMARY KEY CLUSTERED ([DepartmentId] ASC),
    CONSTRAINT [UQ_hr_Department_DepartmentCode] UNIQUE ([DepartmentCode])
);

GO
CREATE NONCLUSTERED INDEX [IX_hr_Department_IsActive]
    ON [hr].[Department] ([IsActive] ASC)
    INCLUDE ([DepartmentCode], [DepartmentName]);

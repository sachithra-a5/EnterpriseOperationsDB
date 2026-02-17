/*
    Table: dbo.Project
    Purpose: Projects; populated by the web application. No static data.
*/
CREATE TABLE [dbo].[Project] (
    [ProjectId]    INT              IDENTITY (1, 1) NOT NULL,
    [ProjectCode]  NVARCHAR(50)      NOT NULL,
    [ProjectName]  NVARCHAR(200)     NOT NULL,
    [Description]  NVARCHAR(500)     NULL,
    [StartDate]    DATE              NOT NULL,
    [EndDate]      DATE              NULL,
    [CreatedDate]  DATETIME2(7)      NOT NULL CONSTRAINT [DF_dbo_Project_CreatedDate] DEFAULT (GETDATE()),
    [ModifiedDate] DATETIME2(7)      NULL,
    [IsActive]     BIT              NOT NULL CONSTRAINT [DF_dbo_Project_IsActive] DEFAULT (1),
    CONSTRAINT [PK_dbo_Project] PRIMARY KEY CLUSTERED ([ProjectId] ASC),
    CONSTRAINT [UQ_dbo_Project_ProjectCode] UNIQUE ([ProjectCode])
);

GO
-- Lookups by ProjectName; INCLUDE (ProjectCode) for covering queries.
CREATE NONCLUSTERED INDEX [IX_dbo_Project_ProjectName]
    ON [dbo].[Project] ([ProjectName] ASC)
    INCLUDE ([ProjectCode]);

GO
CREATE NONCLUSTERED INDEX [IX_dbo_Project_IsActive]
    ON [dbo].[Project] ([IsActive] ASC);

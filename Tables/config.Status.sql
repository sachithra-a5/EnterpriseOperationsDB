/*
    Table: config.Status
    Purpose: Status lookup (e.g. Active, Inactive) used by other tables.
*/
CREATE TABLE [config].[Status] (
    [StatusId]     INT              IDENTITY (1, 1) NOT NULL,
    [StatusCode]   NVARCHAR(20)     NOT NULL,
    [StatusName]   NVARCHAR(100)    NOT NULL,
    [CreatedDate]  DATETIME2(7)     NOT NULL CONSTRAINT [DF_config_Status_CreatedDate] DEFAULT (GETDATE()),
    [ModifiedDate] DATETIME2(7)     NOT NULL CONSTRAINT [DF_config_Status_ModifiedDate] DEFAULT (GETDATE()),
    [IsActive]     BIT              NOT NULL CONSTRAINT [DF_config_Status_IsActive] DEFAULT (1),
    CONSTRAINT [PK_config_Status] PRIMARY KEY CLUSTERED ([StatusId] ASC),
    CONSTRAINT [UQ_config_Status_StatusCode] UNIQUE ([StatusCode])
);

GO
CREATE NONCLUSTERED INDEX [IX_config_Status_StatusCode]
    ON [config].[Status] ([StatusCode] ASC);

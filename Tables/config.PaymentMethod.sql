/*
    Table: config.PaymentMethod
    Purpose: Reference table for payment methods. IDs are fixed (not Identity) for consistent FK references across all environments.
*/
CREATE TABLE [config].[PaymentMethod] (
    [PaymentMethodId]   INT              NOT NULL,
    [PaymentMethodCode] NVARCHAR(50)     NOT NULL,
    [PaymentMethodName] NVARCHAR(100)    NOT NULL,
    [IsActive]          BIT              NOT NULL CONSTRAINT [DF_config_PaymentMethod_IsActive] DEFAULT (1),
    [CreatedDate]       DATETIME2(7)     NOT NULL CONSTRAINT [DF_config_PaymentMethod_CreatedDate] DEFAULT (GETDATE()),
    CONSTRAINT [PK_config_PaymentMethod] PRIMARY KEY CLUSTERED ([PaymentMethodId] ASC),
    CONSTRAINT [UQ_config_PaymentMethod_PaymentMethodCode] UNIQUE ([PaymentMethodCode])
);

GO
CREATE NONCLUSTERED INDEX [IX_config_PaymentMethod_PaymentMethodCode]
    ON [config].[PaymentMethod] ([PaymentMethodCode] ASC);

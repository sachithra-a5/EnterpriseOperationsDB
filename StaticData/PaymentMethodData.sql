/*
    StaticData\PaymentMethodData.sql
    Predefined payment methods. Same data and IDs in Dev, UAT, Prod. No environment logic.
    Idempotent: safe to re-run; uses IF NOT EXISTS on PaymentMethodId.
*/
PRINT 'PaymentMethodData: Loading reference data (all environments).';

IF NOT EXISTS (SELECT 1 FROM config.PaymentMethod WHERE PaymentMethodId = 1)
BEGIN
    INSERT INTO config.PaymentMethod (PaymentMethodId, PaymentMethodCode, PaymentMethodName, IsActive, CreatedDate)
    VALUES (1, 'CASH', 'Cash', 1, GETDATE());
END

IF NOT EXISTS (SELECT 1 FROM config.PaymentMethod WHERE PaymentMethodId = 2)
BEGIN
    INSERT INTO config.PaymentMethod (PaymentMethodId, PaymentMethodCode, PaymentMethodName, IsActive, CreatedDate)
    VALUES (2, 'CARD', 'Card', 1, GETDATE());
END

IF NOT EXISTS (SELECT 1 FROM config.PaymentMethod WHERE PaymentMethodId = 3)
BEGIN
    INSERT INTO config.PaymentMethod (PaymentMethodId, PaymentMethodCode, PaymentMethodName, IsActive, CreatedDate)
    VALUES (3, 'BANKTRANSFER', 'Bank Transfer', 1, GETDATE());
END

IF NOT EXISTS (SELECT 1 FROM config.PaymentMethod WHERE PaymentMethodId = 4)
BEGIN
    INSERT INTO config.PaymentMethod (PaymentMethodId, PaymentMethodCode, PaymentMethodName, IsActive, CreatedDate)
    VALUES (4, 'ONLINEPAYMENT', 'Online Payment', 1, GETDATE());
END

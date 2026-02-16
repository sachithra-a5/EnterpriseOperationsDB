/*
    StaticData\StatusData.sql
    Seed data for config.Status.
*/
PRINT 'StatusData: Environment = $(Environment)';

-- ========== COMMON DATA (all environments) ==========
IF NOT EXISTS (SELECT 1 FROM config.Status WHERE StatusCode = 'ACTIVE')
    INSERT INTO config.Status (StatusCode, StatusName, CreatedDate, ModifiedDate, IsActive)
    VALUES ('ACTIVE', 'Active', GETDATE(), GETDATE(), 1);

IF NOT EXISTS (SELECT 1 FROM config.Status WHERE StatusCode = 'INACTIVE')
    INSERT INTO config.Status (StatusCode, StatusName, CreatedDate, ModifiedDate, IsActive)
    VALUES ('INACTIVE', 'Inactive', GETDATE(), GETDATE(), 1);

-- ========== ENVIRONMENT-SPECIFIC DATA ==========
IF '$(Environment)' = 'Dev'
BEGIN
    IF NOT EXISTS (SELECT 1 FROM config.Status WHERE StatusCode = 'DEVONLY')
        INSERT INTO config.Status (StatusCode, StatusName, CreatedDate, ModifiedDate, IsActive)
        VALUES ('DEVONLY', 'Dev Only Status', GETDATE(), GETDATE(), 1);
END
ELSE IF '$(Environment)' = 'UAT'
BEGIN
    IF NOT EXISTS (SELECT 1 FROM config.Status WHERE StatusCode = 'UATONLY')
        INSERT INTO config.Status (StatusCode, StatusName, CreatedDate, ModifiedDate, IsActive)
        VALUES ('UATONLY', 'UAT Only Status', GETDATE(), GETDATE(), 1);
END
ELSE IF '$(Environment)' = 'Prod'
BEGIN
    -- Production-only statuses if needed.
    SET NOCOUNT ON;
END

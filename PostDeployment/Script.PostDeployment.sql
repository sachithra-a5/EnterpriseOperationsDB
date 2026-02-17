/*
    Post-Deployment Script
    Runs once after schema deploy. :r includes are resolved at BUILD time and inlined.
    Order: Static data (respect FK order), then Jobs.
*/
:r ..\StaticData\DepartmentData.sql
:r ..\StaticData\RoleData.sql
:r ..\StaticData\StatusData.sql
:r ..\StaticData\PaymentMethodData.sql
:r ..\Jobs\Job_Maintenance_EnterpriseOperations.sql

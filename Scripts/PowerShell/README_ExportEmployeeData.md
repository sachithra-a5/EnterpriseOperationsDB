# ExportEmployeeData – Deployment and Testing

## Overview

- **PowerShell script (source):** `Scripts\PowerShell\ExportEmployeeData.ps1`  
- **Server path (where the job runs it):** `D:\SQLJobs\Powershell\ExportEmployeeData.ps1`  
- **SQL Agent job:** `Job_ExportEmployeeData` (category: Data Maintenance, daily 1:00 PM)

The script writes **static values** (no database connection) to  
`D:\SQLJobs\Output\EmployeeExport_<yyyyMMdd_HHmmss>.txt` and logs to  
`D:\SQLJobs\Logs\ExportEmployeeData_<yyyyMMdd_HHmmss>.log`.  
It creates the `Output` and `Logs` folders if they do not exist.

---

## Deployment

1. **Deploy the database project** (including PostDeployment) so the job `Job_ExportEmployeeData` is created or updated on the target server (idempotent; safe to run multiple times).
2. **Copy the PowerShell script** to the server:
   - From repo: `Scripts\PowerShell\ExportEmployeeData.ps1`
   - To server: `D:\SQLJobs\Powershell\ExportEmployeeData.ps1`
   - Create `D:\SQLJobs\Powershell\`, `D:\SQLJobs\Output\`, and `D:\SQLJobs\Logs\` if they do not exist (the script can create Output and Logs; PowerShell folder is typically created by your release process or manually).

---

## Testing in Dev Before Prod

1. **Deploy script to Dev server**  
   Ensure `D:\SQLJobs\Powershell\ExportEmployeeData.ps1` exists and that the SQL Server Agent service account (or the account that runs the job) can read it and write to `D:\SQLJobs\Output\` and `D:\SQLJobs\Logs\`.

2. **Run the script manually (optional)**  
   On the Dev server, in PowerShell:
   ```powershell
   & 'D:\SQLJobs\Powershell\ExportEmployeeData.ps1'
   ```
   Check `D:\SQLJobs\Output\` and `D:\SQLJobs\Logs\` for the new file and log.

3. **Run the job once from SSMS**  
   In SQL Server Management Studio: **SQL Server Agent** → **Jobs** → **Job_ExportEmployeeData** → **Right‑click** → **Start Job at Step**.  
   Confirm the job step succeeds and that a new export file and log appear under `D:\SQLJobs\Output\` and `D:\SQLJobs\Logs\`.

4. **Confirm schedule**  
   In the job **Properties** → **Schedules**, verify the schedule **Daily_1PM_Export** (1:00 PM daily) is enabled.

5. **Promote to Prod**  
   After successful runs in Dev, deploy the same script and database project (with PostDeployment) to Prod and repeat the manual run / “Start Job at Step” check if desired.

---

## Troubleshooting

- **Job fails with “cannot run script”:** Ensure the script path is `D:\SQLJobs\Powershell\ExportEmployeeData.ps1` and that the Agent account has read/execute access.
- **Wrong content:** The script writes static lines only; edit the `$StaticLines` array in the script to change the output.
- **Exit code not reflected:** The job step uses `exit $LASTEXITCODE` so a script failure (exit 1) should mark the job step as failed.

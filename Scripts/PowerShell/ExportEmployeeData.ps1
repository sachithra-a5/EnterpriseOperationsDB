<#
.SYNOPSIS
    Writes static employee-style data to a text file. Used by SQL Agent job Job_ExportEmployeeData.

.DESCRIPTION
    No database connection. Writes static values to D:\SQLJobs\Output\EmployeeExport_<timestamp>.txt
    and logs to D:\SQLJobs\Logs\ExportEmployeeData_<timestamp>.log.
    Creates Output and Logs folders if they do not exist. Exit 0 = success, 1 = failure.

.NOTES
    Deploy this file to D:\SQLJobs\Powershell\ExportEmployeeData.ps1 on the server.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$BasePath = 'D:\SQLJobs'
$OutputPath = Join-Path $BasePath 'Output'
$LogsPath = Join-Path $BasePath 'Logs'
$ScriptName = 'ExportEmployeeData'
$Timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$LogFile = Join-Path $LogsPath "${ScriptName}_${Timestamp}.log"
$ExportFile = Join-Path $OutputPath "EmployeeExport_${Timestamp}.txt"

function Write-Log {
    param([string] $Message, [string] $Level = 'INFO')
    $Line = "{0:yyyy-MM-dd HH:mm:ss} [{1}] {2}" -f (Get-Date), $Level, $Message
    Add-Content -Path $LogFile -Value $Line -ErrorAction SilentlyContinue
    if ($Level -eq 'ERROR') { Write-Error $Message } else { Write-Verbose $Message }
}

try {
    # Create Output and Logs folders if they do not exist
    foreach ($Folder in $OutputPath, $LogsPath) {
        if (-not (Test-Path -LiteralPath $Folder)) {
            New-Item -ItemType Directory -Path $Folder -Force | Out-Null
            Write-Log "Created folder: $Folder"
        }
    }

    Write-Log "Starting $ScriptName.ps1"
    Write-Log "Export file: $ExportFile"

    # Static content (no database) – header and sample rows
    $StaticLines = @(
        "EmployeeId`tEmployeeCode`tFullName`tIsActive",
        "1`tEMP001`tJohn Smith`t1",
        "2`tEMP002`tJane Doe`t1",
        "3`tEMP003`tBob Wilson`t0"
    )
    $StaticLines | Set-Content -Path $ExportFile -Encoding UTF8
    Write-Log "Wrote $($StaticLines.Count) line(s) to $ExportFile"

    Write-Log "Completed successfully."
    exit 0
}
catch {
    Write-Log "Failed: $($_.Exception.Message)" -Level 'ERROR'
    if ($_.ScriptStackTrace) { Write-Log $_.ScriptStackTrace -Level 'ERROR' }
    exit 1
}

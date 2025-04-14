<#
.SYNOPSIS
Finds and terminates all running Tomcat server processes.

.DESCRIPTION
This script searches for processes that are likely Tomcat servers based on common keywords
in their process name or command line. It then prompts for confirmation before terminating
each identified process.

.NOTES
- Requires administrator privileges to terminate processes.
- This script relies on identifying Tomcat processes by keywords. It might incorrectly
  identify other Java-based applications. Use with caution and review the identified
  processes before confirming termination.
- Consider more robust identification methods if this script identifies false positives
  frequently (e.g., checking for specific arguments or the presence of Tomcat-related
  files).

.EXAMPLE
.\Stop-AllTomcat.ps1

#>
param(
    [Switch]$Force # Optional: If specified, will not prompt for confirmation before terminating
)

Write-Host "Searching for running Tomcat server processes..."

# Common keywords to identify Tomcat processes
$TomcatKeywords = @("tomcat", "catalina", "org.apache.catalina.startup.Bootstrap")

# Get all running processes
$Processes = Get-Process

# Filter processes based on keywords in ProcessName or CommandLine
$TomcatProcesses = $Processes | Where-Object {
    $_.ProcessName -like "*$($TomcatKeywords -join '*')*" -or
    (Get-WmiObject -Class Win32_Process -Filter "ProcessId=$($_.Id)" | Select-Object -ExpandProperty CommandLine) -like "*$($TomcatKeywords -join '*')*"
}

if ($TomcatProcesses.Count -gt 0) {
    Write-Host "Found the following Tomcat server processes:"
    foreach ($Process in $TomcatProcesses) {
        Write-Host "  Process Name: $($Process.ProcessName), PID: $($Process.Id)"
        if (-not $Force) {
            $Confirmation = Read-Host -Prompt "  Terminate this process? (Y/N)"
            if ($Confirmation -ceq "Y" -or $Confirmation -ceq "y") {
                try {
                    Stop-Process -Id $Process.Id -Force
                    Write-Host "  Terminated process $($Process.ProcessName) with PID $($Process.Id)."
                } catch {
                    Write-Error "  Error terminating process $($Process.ProcessName) with PID $($Process.Id): $($_.Exception.Message)"
                }
            } else {
                Write-Host "  Skipping termination of process $($Process.ProcessName) with PID $($Process.Id)."
            }
        } else {
            try {
                Stop-Process -Id $Process.Id -Force
                Write-Host "  (Forced) Terminated process $($Process.ProcessName) with PID $($Process.Id)."
            } catch {
                Write-Error "  Error terminating process $($Process.ProcessName) with PID $($Process.Id): $($_.Exception.Message)"
            }
        }
    }
} else {
    Write-Host "No running Tomcat server processes found."
}

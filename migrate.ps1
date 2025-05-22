param(
    [string]$sourceVMIP,
    [string]$targetVMIP,
    [string]$username,
    [string]$csvFilePath,
    [string]$localCsvPath,
    [string]$sshKeyPath   # Added parameter for SSH private key
)

Write-Host "Starting migration..."
Write-Host "Source VM IP: $sourceVMIP"
Write-Host "Target VM IP: $targetVMIP"
Write-Host "Username: $username"
Write-Host "CSV Path on Source VM: $csvFilePath"
Write-Host "Local CSV Path: $localCsvPath"
Write-Host "SSH Key Path: $sshKeyPath"

# Use ${} to avoid variable parsing issues
$remoteSource = "${username}@${sourceVMIP}:${csvFilePath}"
$remoteTarget = "${username}@${targetVMIP}:/home/${username}/mydata.csv"


# Run SCP directly (avoid cmd /c)
Write-Host "Copying from source VM..."
scp -o StrictHostKeyChecking=no -i "$sshKeyPath" "$remoteSource" "$localCsvPath"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to copy CSV from source VM."
    exit 1
}

Write-Host "Copying to target VM..."
scp -o StrictHostKeyChecking=no -i "$sshKeyPath" "$localCsvPath" "$remoteTarget"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to copy CSV to target VM."
    exit 1
}

Write-Host "CSV migration completed successfully."


# Write-Host "Copying from source VM..."
# $scpArgs1 = "-o StrictHostKeyChecking=no -i `"$sshKeyPath`" `"$remoteSource`" `"$localCsvPath`""
# $process1 = Start-Process -FilePath scp -ArgumentList $scpArgs1 -NoNewWindow -Wait -PassThru
# if ($process1.ExitCode -ne 0) {
#     Write-Error "Failed to copy CSV from source VM."
#     exit 1
# }

# Write-Host "Copying to target VM..."
# $scpArgs2 = "-o StrictHostKeyChecking=no -i `"$sshKeyPath`" `"$localCsvPath`" `"$remoteTarget`""
# $process2 = Start-Process -FilePath scp -ArgumentList $scpArgs2 -NoNewWindow -Wait -PassThru
# if ($process2.ExitCode -ne 0) {
#     Write-Error "Failed to copy CSV to target VM."
#     exit 1
# }

# Write-Host "CSV migration completed successfully."


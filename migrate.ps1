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

$remoteSource = "${username}@${sourceVMIP}:`"$csvFilePath`""

$remoteTarget = "${username}@${targetVMIP}:/home/${username}/mydata.csv"


$copyFromSourceCmd = "scp -o StrictHostKeyChecking=no -i `"$sshKeyPath`" `"$remoteSource`" `"$localCsvPath`""
$copyToTargetCmd = "scp -o StrictHostKeyChecking=no -i `"$sshKeyPath`" `"$localCsvPath`" `"$remoteTarget`""


Write-Host "Running: $copyFromSourceCmd"
$copyFromResult = & cmd /c $copyFromSourceCmd
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to copy CSV from source VM."
    exit 1
}

Write-Host "Running: $copyToTargetCmd"
$copyToResult = & cmd /c $copyToTargetCmd
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to copy CSV to target VM."
    exit 1
}

Write-Host "CSV migration completed successfully."

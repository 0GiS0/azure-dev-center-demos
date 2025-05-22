param(
    [string]$Source,
    [string]$DatabaseName,
    [string]$DatabaseFilePath,
    [string]$serverName
)

function createFolderIfNotExists {
    param (
        [string]$folderPath
    )
    if (!(Test-Path -Path $folderPath)) {
        New-Item -Path $folderPath -ItemType Directory | Out-Null
    }
}

# Create the folder if it does not exist
$folderPath = Split-Path -Path $DatabaseFilePath -Parent

# Download the database from the source URL
createFolderIfNotExists -folderPath $folderPath
Invoke-WebRequest -Uri $Source -OutFile $DatabaseFilePath

# Create the database file if it does not exist
if (!(Test-Path -Path $DatabaseFilePath)) {
    New-Item -Path $DatabaseFilePath -ItemType File | Out-Null
}

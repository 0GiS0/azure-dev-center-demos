param(
    [string]$Source,
    [string]$DatabaseName,
    [string]$DatabaseFilePath   
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

# Attach the database to the SQL Server instance from a .bak file
$sqlQuery = @"
USE [master];
CREATE DATABASE [$DatabaseName]
ON (FILENAME = '$DatabaseFilePath')
FOR ATTACH;
ALTER DATABASE [$DatabaseName] SET READ_WRITE;
ALTER DATABASE [$DatabaseName] SET MULTI_USER;
"@
# Execute the SQL query to attach the database
Invoke-Sqlcmd -Query $sqlQuery -ServerInstance "localhost" -ErrorAction Stop
Write-Host "Database '$DatabaseName' has been successfully attached from '$DatabaseFilePath'."


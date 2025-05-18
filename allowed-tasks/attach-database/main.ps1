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

# Attach the database to the SQL Server instance from a .bak file
$sqlQuery = @"

USE [master]
RESTORE DATABASE [$DatabaseName]
FROM DISK = N'$DatabaseFilePath' 
WITH MOVE N'Datos' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\[$DatabaseName].mdf', 
MOVE N'Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\[$DatabaseName].ldf', 
NOUNLOAD,
STATS = 5;
GO

"@
# Execute the SQL query to attach the database
Invoke-Sqlcmd -Query $sqlQuery -ServerInstance $serverName -ErrorAction Stop -TrustServerCertificate
Write-Host "Database '$DatabaseName' has been successfully attached from '$DatabaseFilePath'."
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

# Attach the database to the SQL Server instance
$connectionString = "Server=localhost;Database=master;Integrated Security=True;"
$sqlQuery = @"
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = '$DatabaseName')
BEGIN
    CREATE DATABASE [$DatabaseName]
END
USE [$DatabaseName]
IF NOT EXISTS (SELECT * FROM sys.master_files WHERE name = '$DatabaseName')
BEGIN
    CREATE DATABASE [$DatabaseName] 
    ON (FILENAME = '$DatabaseFilePath')
    FOR ATTACH
END
"@
Invoke-Sqlcmd -ConnectionString $connectionString -Query $sqlQuery -ErrorAction Stop

param(      
    [string]$DatabaseFilePath,
    [string]$SqlDataFolderPath = "C:\SQLData"
)

function createFolderIfNotExists {
    param([string]$folderPath)
    if (-not (Test-Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath | Out-Null
    }
}

try {
    # Search in DatabaseFilePath folder for .bak files
    $bakFiles = Get-ChildItem -Path $DatabaseFilePath -Filter "*.bak" -Recurse
    if ($bakFiles.Count -eq 0) {
        Write-Host "No .bak files found in the specified folder."
        return
    }

    # Get the .bak file path
    $DatabaseBakFile = $bakFiles[0].FullName
    Write-Host "Using .bak file: $DatabaseBakFile"

    $DatabaseName = [System.IO.Path]::GetFileNameWithoutExtension($DatabaseBakFile)

    # Create folder for SQL data files if it does not exist
    createFolderIfNotExists -folderPath $SqlDataFolderPath

    # Attach the database to the SQL Server instance from a .bak file
    $mdfPath = Join-Path $SqlDataFolderPath "$DatabaseName.mdf"
    $ldfPath = Join-Path $SqlDataFolderPath "$DatabaseName.ldf"
    $sqlQuery = @"

USE [master];
GO
RESTORE DATABASE [$DatabaseName]
FROM DISK = N'$DatabaseBakFile'
WITH
    MOVE '${DatabaseName}_Data' TO '$mdfPath',
    MOVE '${DatabaseName}_Log' TO '$ldfPath',
    FILE = 1,
    NOUNLOAD,
    STATS = 5;
GO

"@

    # Execute the SQL query to attach the database
    Invoke-Sqlcmd -Query $sqlQuery -ServerInstance 'localhost' -ErrorAction Stop
    Write-Host "Database '$DatabaseName' has been successfully attached from '$DatabaseFilePath'."
} catch {
    Write-Host "An error occurred: $_"
}
param(
    [string]$sqlUser = "tu_usuario_local",
    [string]$sqlInstance = "localhost"
)

$sql = @"
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'$env:COMPUTERNAME\$sqlUser')
BEGIN
    CREATE LOGIN [$env:COMPUTERNAME\$sqlUser] FROM WINDOWS;
END
ALTER SERVER ROLE [sysadmin] ADD MEMBER [$env:COMPUTERNAME\$sqlUser];
"@

$sql | sqlcmd -S $sqlInstance -E

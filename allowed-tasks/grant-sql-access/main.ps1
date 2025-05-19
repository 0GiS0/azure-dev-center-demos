param(
    [string]$sqlUser = "$env:COMPUTERNAME\tu_usuario_local",
    [string]$sqlInstance = "localhost"
)

$sql = @"
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'$sqlUser')
BEGIN
    CREATE LOGIN [$sqlUser] FROM WINDOWS;
END
ALTER SERVER ROLE [sysadmin] ADD MEMBER [$sqlUser];
"@

$sql | sqlcmd -S $sqlInstance -E

param(
    [string]$sqlUser = "tu_usuario_local",
    [string]$sqlInstance = "localhost"
)

$sql = @"
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'azuread\$sqlUser')
BEGIN
    CREATE LOGIN [azuread\$sqlUser] FROM WINDOWS;
END
ALTER SERVER ROLE [sysadmin] ADD MEMBER [azuread\$sqlUser];
"@

$sql | sqlcmd -S $sqlInstance -E

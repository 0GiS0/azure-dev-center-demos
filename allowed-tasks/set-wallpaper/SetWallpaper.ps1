[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $PicUrl
)

if (-not $PicUrl) {
    throw "PicUrl parameter is mandatory. Please provide a value for the PicUrl parameter."
}

# Descargar la imagen a una ruta temporal
$tempPath = "$env:TEMP\wallpaper.jpg"
Invoke-WebRequest -Uri $PicUrl -OutFile $tempPath

# Definir función para establecer el wallpaper
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# Establecer el wallpaper
$SPI_SETDESKWALLPAPER = 0x0014
$SPIF_UPDATEINIFILE = 0x01
$SPIF_SENDWININICHANGE = 0x02

[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $tempPath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDWININICHANGE) | Out-Null

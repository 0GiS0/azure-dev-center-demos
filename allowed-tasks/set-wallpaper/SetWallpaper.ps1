[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $PicUrl,   
)

if (-not $PicUrl) {
    throw "PicUrl parameter is mandatory. Please provide a value for the PicUrl parameter."
}

###################################################################################################


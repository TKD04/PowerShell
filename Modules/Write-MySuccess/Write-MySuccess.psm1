<#
.SYNOPSIS
Displays a success message in the console with a green color.

.PARAMETER Message
The message to display as a success message.
#>
function Write-MySuccess {
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Message
    )

    Write-Host -ForegroundColor Green -Object "SUCCESS: $Message"
}

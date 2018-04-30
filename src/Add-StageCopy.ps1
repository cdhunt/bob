<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Job
.OUTPUTS
    Job
.NOTES
    General notes
#>
function Add-StageCopy {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [Job]
        $InputObject
    )

    process {
        $stage = New-Object -TypeName Copy
        Add-BuildStage -Job $_ -Stage $stage | Write-Output
    }
}
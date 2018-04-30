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
    string[]
.NOTES
    General notes
#>
function Write-BuilderResults {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [Job]
        $InputObject
    )

    process {
        $_.GetResults() | Write-Output
    }
}
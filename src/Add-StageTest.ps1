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
function Add-StageTest {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [Job]
        $InputObject
    )

    process {
        $stage = New-Object -TypeName Test
        Add-BuildStage -Job $_ -Stage $stage | Write-Output
    }
}
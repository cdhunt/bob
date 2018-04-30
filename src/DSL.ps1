function BuildJob {
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [Alias("Source")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=1,
                   HelpMessage="Path to one or more locations.")]
        [Alias("Desgination")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Output,

        # Parameter help description
        [Parameter(Mandatory, Position=2)]
        [scriptblock]
        $ScriptBlock
    )

    begin {
        $global:BUILDER = [Job]::New($Path,$Output)
    }

    process {

        & $ScriptBlock

        $global:BUILDER | Write-Output
    }
}

function CleanStg() {
    $global:BUILDER | Add-StageClean | Out-Null
}

function CopyStg() {
    $global:BUILDER | Add-StageCopy | Out-Null
}

function TestStg() {
    $global:BUILDER | Add-StageTest | Out-Null
}
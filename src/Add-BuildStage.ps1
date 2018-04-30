function Add-BuildStage {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [Job]
        $Job,

        # Parameter help description
        [Parameter(Mandatory, Position=1)]
        [Stage]
        $Stage
    )

    process {
        $Job.AddStage($Stage) | Write-Output
    }

}
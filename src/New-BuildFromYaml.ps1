function New-BuildFromYaml {
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="ParameterSetName",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path
    )


    $config = Get-Content -Path $Path -Raw | ConvertFrom-Yaml

    $b = New-BuildJob -Path $config.build.source -Output $config.build.output

    ForEach ($stageName in $config.build.stages) {
        $stageObject = New-Object -TypeName $stageName
        $b | Add-BuildStage -Stage $stageObject | Out-Null
    }

    Write-Output -InputObject $b
}
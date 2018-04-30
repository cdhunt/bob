function New-BuildJob {
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
        $Output
    )

    process {

        New-Object -TypeName Job -ArgumentList $Path,$Output | Write-Output

    }

}
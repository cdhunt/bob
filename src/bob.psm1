class Stage {
    [string] $Name
    hidden [DateTime] $StartTime = [DateTime]::Now

    Stage($Name) {
        $this.Name = $Name
    }

    [TimeSpan] GetElapsed(){
        return [DateTime]::Now - $this.StartTime
    }

    [string] GetHeader() {
        return "~ [{0}] ~" -f $this.Name
    }
}

class Clean : Stage {

    Clean () : base('Clean') {}

    Invoke([Job]$J) {

        $J.LogHeader($this.GetHeader())

        if (Test-Path -Path $J.Destination) {
            Get-ChildItem -Path $J.Destination -Recurse | ForEach-Object {
                    $_ | Remove-Item -ErrorAction Stop -Confirm:$false -Recurse
                    $J.LogEntry("- {0}" -f $_.FullName)
            }
        }

        $J.LogEntry("[in {0:N2}s]" -f $this.GetElapsed().TotalSeconds)
    }
}

class Copy : Stage {

    Copy () : base('Copy') { }

    Invoke([job]$J) {

        $J.LogHeader($this.GetHeader())

        Get-ChildItem -Path $J.Source | ForEach-Object {
            if (!(Test-Path -Path $J.Destination)) {
                New-Item -ItemType Directory -Path $J.Destination
            }
            $_ | Copy-Item -Destination $J.Destination -ErrorAction Stop -Recurse
            $J.LogEntry("+ {0}" -f (Resolve-Path (Join-Path -Path $J.Destination -ChildPath $_.Name) ))
        }

        $J.LogEntry("[in {0:N2}s]" -f $this.GetElapsed().TotalSeconds)
    }
}

class Test : Stage {

    Test () : base('Test') { }

    Invoke([job]$J) {

        $J.LogHeader($this.GetHeader())

        $J.LogEntry("Test [{0}]" -f $J.Destination)

        $J.LogEntry("[in {0:N2}s]" -f $this.GetElapsed().TotalSeconds)
    }

}


class Job {
    [string] $Source
    [string] $Destination

    hidden [array] $Result = @()
    hidden [DateTime] $StartTime = [DateTime]::Now
    hidden [Stage[]] $Stages = @()

    Job ($Source, $Destination) {
        $this.Source = $Source
        $this.Destination = $Destination
    }

    [TimeSpan] GetElapsed(){
        return [DateTime]::Now - $this.StartTime
    }

    [void] LogHeader([string]$S) {
        $this.Result += $S
    }

    [void] LogEntry([string]$S) {
        $this.Result += "`t{0}" -f $S
    }

    [void] LogError([string]$S) {
        $this.LogEntry("`!![{0}]!!" -f $S)
    }

    [Job] AddStage([Stage]$S) {
        $this.Stages += $S

        return $this
    }

    [Job] Invoke() {
        $this.Stages | ForEach-Object {
            try {
                $_.Invoke($this)
            }
            catch {
                $this.LogError($_.Exception.Message)
                break
            }
        }

        return $this
    }

    [string] GetResult() {
        return $this.Result | Out-String
    }
}

# Private
$global:BUILDER = New-Object -TypeName Object

# Public
. $PSScriptRoot\New-BuildJob.ps1
. $PSScriptRoot\Add-BuildStage.ps1
. $PSScriptRoot\Add-StageCopy.ps1
. $PSScriptRoot\Add-StageClean.ps1
. $PSScriptRoot\Add-StageTest.ps1
. $PSScriptRoot\Invoke-Builder.ps1
. $PSScriptRoot\Write-BuilderResults.ps1
. $PSScriptRoot\DSL.ps1

# Aliases
if (!(Get-Alias -Name :Clean -ErrorAction SilentlyContinue)) { New-Alias -Name :Clean -Value Add-StageClean }
if (!(Get-Alias -Name :Copy -ErrorAction SilentlyContinue))  { New-Alias -Name :Copy -Value Add-StageCopy }
if (!(Get-Alias -Name :Test -ErrorAction SilentlyContinue))  { New-Alias -Name :Test -Value Add-StageTest }
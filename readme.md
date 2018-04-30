# Bob

This project is an exploration of [Software Design Patterns in PowerShell](https://www.automatedops.com/blog/2018/04/11/software-design-patterns-in-powershell-strategy-pattern/).
Currently, the goal isn't to produce a usable module, but to test out some ideas of how to put PowerShell modules together.
By building a module on top of PowerShell classes utilizing the Strategy pattern, we should be able to build a module that is easier to maintain and plug in additional functionality without changes to the core code.

We can use multiple forms of invocation depending on preference and context.

```powershell
# PS Classes w/Fluent API
PS> [Job]::New('src', 'dst').
>>         AddStage([Clean]::New()).
>>         AddStage([Copy]::New()).
>>         AddStage([Test]::New()) | Select stages

Stages
------
{Clean, Copy, Test}

# Cmdlet Pipeline
PS> New-BuildJob src dst | Add-StageClean | Add-StageCopy | Add-StageTest | Select stages

Stages
------
{Clean, Copy, Test}


# Cmdlet Pipeline w/ Generic Cmdlet
PS> New-BuildJob src dst | Add-StageClean | Add-StageCopy | Add-BuildStage -Stage ([Test]::New()) | Select stages

Stages
------
{Clean, Copy, Test}


# DSL
BuildJob src dst {
    CleanStg
    CopyStg
    TestStg
} | Select stages

Stages
------
{Clean, Copy, Test}
```

:warning: Please don't pay much attention to the names of things.
This is not meant to be an example of a well-formed module.
You probably won't win any scripting games by copying the structure of this module.
#Requires -Module bob

BuildJob .\src .\output\bob {
    CleanStg
    CopyStg
    TestStg
} | Invoke-Builder | Write-BuilderResults

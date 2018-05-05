<#
    open/close principle
    be open for extension, but closed for modification
    an entity can allow its behaviour to be extended without modifying its source code
#>

Import-Module .\src\bob.psd1 -Force

function testStrategy {
    param($p)

    $name = "Invoke-Build{0}" -f $p.gettype().name

    if (!(Get-Command $name -ErrorAction SilentlyContinue)) {
        return "$name not found"
    }

    "begin"
    "call $name"
    "end"
    ""
}

function Invoke-BuildScriptBlock {}
function Invoke-BuildString {}
function Invoke-BuildTestThis {}

class TestThis {}
class TestThis1 {}

testStrategy {}
testStrategy .\quotes.xml
testStrategy ([TestThis]::new())
testStrategy ([TestThis1]::new())
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent 
. "$here\$funcType\$sut"

Describe $sut.Trimend('.ps1') { 

    BeforeAll {
        Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psm1') -Force
    }

    Mock Get-Content -MockWith { "1`t0" } -Verifiable -ParameterFilter { $TotalCount } 
    Mock Get-Content -MockWith { '1	0', '0x00000012	S-1-1-0		Everyone	0	0' } -ParameterFilter { $TotalCount -ne 1 } -Verifiable
    Mock Test-Path -MockWith { $true } -Verifiable
    
    It 'Does not throw' {
        { Get-FslAssignment -Path TestDrive:\Notexist.fxa } | Should Not Throw
    }

    It 'Calls all Verifiable Mocks'{
        Assert-VerifiableMocks
    }
}
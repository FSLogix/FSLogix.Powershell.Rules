$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path $here
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

#. ..\..\Private\ConvertTo-FslRuleCode.ps1

Describe Add-FSlRule {
    
    Context -Name 'Output' {
        . ..\..\Private\ConvertTo-FslRuleCode.ps1
        Mock ConvertTo-FslRuleCode {'0x00000222'}
        Mock Add-Content {''} -ParameterFilter { $Encoding -and $Encoding -eq 'Unicode' }
        #Mock Export-Csv {''}

        It 'Does not throw' {
            {Add-FslRule -RuleFilePath 'Testdrive:\temprule.fxr' -FullName "Testdrive:\madeup.txt"} | should not throw
        }
        It 'Does not return an object' {
            ($result | Measure-Object).Count | Should Be 0
        }
        It 'Returns an object from passthru' {
            $result = Add-FslRule -RuleFilePath 'Testdrive:\temprule.fxr' -FullName "Testdrive:\madeup.txt" -Passthru
            ( $result | Measure-Object).Count | Should BeLessThan 7
            ( $result | Measure-Object).Count | Should BeGreaterThan 2
        }
        It 'Returns 2verbose lines'{
            $verboseLine = Add-FslRule -RuleFilePath 'Testdrive:\temprule.fxr' -FullName "Testdrive:\madeup.txt" -Verbose 4>&1
            $verboseLine.count | Should Be 4
        }
    }

}
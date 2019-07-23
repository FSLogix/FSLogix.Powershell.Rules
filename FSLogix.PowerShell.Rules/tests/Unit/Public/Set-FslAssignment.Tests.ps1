$here = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path | Split-Path | Split-Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#$funcType = Split-Path $here -Leaf
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psd1') -Force

Describe "$($sut.TrimEnd('.ps1'))" -Tag 'Unit','Public' {

    InModuleScope FSLogix.PowerShell.Rules {

        Context 'Input' {
            It 'Takes an object as pipeline input for Parameter Set Environment' {

                $pipeInput = [PSCustomObject]@{
                    Path                = 'TestDrive:\pipeline.fxa'
                    EnvironmentVariable = 'CLIENTNAME=PC1'
                    Passthru            = $true
                }

                $pipeInput | Set-FslAssignment
            }

            It 'Takes a single object as pipeline Input by value' {
                'TestDrive:\pipeline.fxa' | Set-FslAssignment -EnvironmentVariable 'CLIENTNAME=PC1'
                Test-Path TestDrive:\pipeline.fxa | Should -BeTrue
            }

            It 'Takes Parameters Positionally' {
                Set-FslAssignment 'TestDrive:\position.fxa' -EnvironmentVariable 'CLIENTNAME=PC1'
                Test-Path TestDrive:\position.fxa | Should -BeTrue
            }

            It "Takes an FSLogix Object as pipeline input" {
                $assignInput = [PSCustomObject]@{
                    PSTypeName          = "FSLogix.Assignment"
                    RuleSetApplies      = $false
                    UserName            = $null
                    GroupName           = $null
                    ADDistinguisedName  = $null
                    WellKnownSID        = $null
                    ProcessName         = $null
                    IncludeChildProcess = $null
                    IPAddress           = $null
                    ComputerName        = $null
                    OU                  = $null
                    EnvironmentVariable = 'CLIENTNAME=PC1'
                    AssignedTime        = 0
                    UnAssignedTime      = 0
                }

                $assignInput | Set-FslAssignment -Path TestDrive:\ObjectPipe.fxa
                Test-Path TestDrive:\ObjectPipe.fxa | Should -BeTrue

            }
        }

        Context 'Execution' {


        }

        Context 'Output' {

            It 'Produces comment based help' {
                $h = help Set-FslAssignment
                $h.count | Should -BeGreaterThan 10
            }

            It 'Outputs two verbose lines (one from Add-fslRule) on initial set' {
                $verboseLine = Set-FslAssignment -Path TestDrive:\Verbose.fxa -Verbose 4>&1 -EnvironmentVariable 'CLIENTNAME=PC1'
                $verboseLine.count | Should -Be 2
            }

            It "Only has three verbose lines in the case of multiple pipeline objects" {
                $pipeInput1 = [PSCustomObject]@{
                    EnvironmentVariable = 'CLIENTNAME=PC1'
                }
                $pipeInput2 = [PSCustomObject]@{
                    EnvironmentVariable = 'CLIENTNAME=PC2'
                }

                $verboseLine = $pipeInput1, $pipeInput2 | Set-FslAssignment -Path 'TestDrive:\multipipeline.fxa' -Verbose 4>&1
                $verboseLine.count | Should -Be 3
            }
        }
    }
}
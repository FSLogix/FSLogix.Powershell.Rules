$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent 
#. "$here\$funcType\$sut"

Import-Module -Name (Join-Path $here 'FSLogix.PowerShell.Rules.psd1') -Force

InModuleScope 'FSLogix.PowerShell.Rules' {

    Describe $sut.Trimend('.ps1') { 
        
    }

}

# All possible Param combinations below

<#
Add-FslAssignment -AssignmentFilePath [String] -UserName [String]
Add-FslAssignment -AssignmentFilePath [String] -UserName [String] -ADDistinguisedName [String]
Add-FslAssignment -AssignmentFilePath [String] -UserName [String] -RuleSetApplies
Add-FslAssignment -AssignmentFilePath [String] -UserName [String] -RuleSetApplies -ADDistinguisedName [String]
Add-FslAssignment -AssignmentFilePath [String] -GroupName [String]
Add-FslAssignment -AssignmentFilePath [String] -GroupName [String] -ADDistinguisedName [String]
Add-FslAssignment -AssignmentFilePath [String] -GroupName [String] -WellKnownSID [String]
Add-FslAssignment -AssignmentFilePath [String] -GroupName [String] -WellKnownSID [String] -ADDistinguisedName [String]
Add-FslAssignment -AssignmentFilePath [String] -GroupName [String] -RuleSetApplies
Add-FslAssignment -AssignmentFilePath [String] -GroupName [String] -RuleSetApplies -ADDistinguisedName [String]
Add-FslAssignment -AssignmentFilePath [String] -GroupName [String] -RuleSetApplies -WellKnownSID [String]
Add-FslAssignment -AssignmentFilePath [String] -GroupName [String] -RuleSetApplies -WellKnownSID [String] -ADDistinguisedName [String]
Add-FslAssignment -AssignmentFilePath [String] -ProcessName [String]
Add-FslAssignment -AssignmentFilePath [String] -ProcessName [String] -ProcessId
Add-FslAssignment -AssignmentFilePath [String] -ProcessName [String] -IncludeChildProcess
Add-FslAssignment -AssignmentFilePath [String] -ProcessName [String] -IncludeChildProcess -ProcessId
Add-FslAssignment -AssignmentFilePath [String] -ProcessName [String] -RuleSetApplies
Add-FslAssignment -AssignmentFilePath [String] -ProcessName [String] -RuleSetApplies -ProcessId
Add-FslAssignment -AssignmentFilePath [String] -ProcessName [String] -RuleSetApplies -IncludeChildProcess
Add-FslAssignment -AssignmentFilePath [String] -ProcessName [String] -RuleSetApplies -IncludeChildProcess -ProcessId
Add-FslAssignment -AssignmentFilePath [String] -IPAddress [String]
Add-FslAssignment -AssignmentFilePath [String] -IPAddress [String] -RuleSetApplies
Add-FslAssignment -AssignmentFilePath [String] -ComputerName [String]
Add-FslAssignment -AssignmentFilePath [String] -ComputerName [String] -RuleSetApplies
Add-FslAssignment -AssignmentFilePath [String] -OU [String]
Add-FslAssignment -AssignmentFilePath [String] -OU [String] -RuleSetApplies
Add-FslAssignment -AssignmentFilePath [String] -EnvironmentVariable [String]
Add-FslAssignment -AssignmentFilePath [String] -EnvironmentVariable [String] -UnAssignedTime [Int64]
Add-FslAssignment -AssignmentFilePath [String] -EnvironmentVariable [String] -AssignedTime [Int64]
Add-FslAssignment -AssignmentFilePath [String] -EnvironmentVariable [String] -AssignedTime [Int64] -UnAssignedTime [Int64]
Add-FslAssignment -AssignmentFilePath [String] -EnvironmentVariable [String] -RuleSetApplies
Add-FslAssignment -AssignmentFilePath [String] -EnvironmentVariable [String] -RuleSetApplies -UnAssignedTime [Int64]
Add-FslAssignment -AssignmentFilePath [String] -EnvironmentVariable [String] -RuleSetApplies -AssignedTime [Int64]
Add-FslAssignment -AssignmentFilePath [String] -EnvironmentVariable [String] -RuleSetApplies -AssignedTime [Int64] -UnAssignedTime [Int64]

#>
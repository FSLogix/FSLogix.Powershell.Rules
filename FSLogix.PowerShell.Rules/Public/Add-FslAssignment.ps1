function Add-FslAssignment {

    <#
        .SYNOPSIS
            Adds to the content of a FSLogix Rule assignment file.

        .DESCRIPTION
            This function can add to FSLogix assignment file contents, the assignment file should have the same basename as the matching rule file.
            This will not overwrite the contents of an existing file.

        .PARAMETER AssignmentFilePath
            The Target file path to set the assignment within
        .PARAMETER RuleSetApplies
            This determines whether a ruleset does or does not apply to users/groups/processes etc.  For instance when using a Hiding rule, applying that hiding rule to users will hide the file from the users assigned to it when applied.
        .PARAMETER UserName
            If you wish to tie down the rule to an individual user use theier unsername in this parameter.  Groupname is more usual for assignments however
        .PARAMETER GroupName
            Use this to tie the assignment of the rule to a specific group
        .PARAMETER WellKnownSID
            The Well Known SID for groups such as Domain Admins are useful for cross-language assignments, if you use a group with a well known SID in the groupname parameter this will be automatically filled out, so mostly useful for pipeline input.
        .PARAMETER ADDistinguisedName
            Full Distinguished name of AD component
        .PARAMETER ProcessName
            Process name for the rule assignment, mostly used for redirect rules
        .PARAMETER IncludeChildProcess
            If Process name is stated you can optionally include chile prcesses (recommended)
        .PARAMETER IPAddress
            Enter the IPv4 or IPv6 address. Partial strings are allowed. For example, if you enter 192.168, an address of 192.168.0.1 will be considered to match.
        .PARAMETER ComputerName
            Enter the Full Distinguished Name of the computer object, or the computer name (wildcards accepted). Must be in the format ComputerName@Domain
        .PARAMETER OU
            You can specify an Active Directory Container and the assignment will be effective for all of the objects in that container. Enter the Full Distinguished Name of the container.
        .PARAMETER EnvironmentVariable
            By Specifying an environment variable, you can customize rules in various other ways. A very useful example for this option is when using it with RDSH, XenApp, or other remote sessions. You can use the Environment Variable CLIENTNAME to limit visibility to the device being used to access the RDSH or XenApp system.
            The environment variables that are supported are the ones that are present when the user's session is created. Environment variables set during logon are not supported.
        .PARAMETER AssignedTime
            Only used for pipeline input
        .PARAMETER UnAssignedTime
            Only used for pipeline input
        .EXAMPLE
            A sample command that uses the function or script, optionaly followed
            by sample output and a description. Repeat this keyword for each example.
    #>

    [CmdletBinding()]
    Param (

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String]$AssignmentFilePath,

        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$RuleSetApplies,

        [Parameter(
            ParameterSetName = 'User',
            Position = 2,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$UserName,

        [Parameter(
            ParameterSetName = 'Group',
            Position = 3,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$GroupName,

        [Parameter(
            ParameterSetName = 'Group',
            Position = 4,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$WellKnownSID,

        [Parameter(
            ParameterSetName = 'User',
            Position = 5,
            ValuefromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'Group',
            Position = 5,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$ADDistinguisedName,

        [Parameter(
            ParameterSetName = 'Executable',
            Position = 6,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$ProcessName,

        [Parameter(
            ParameterSetName = 'Executable',
            Position = 7,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$IncludeChildProcess,

        <#
        [Parameter(
            ParameterSetName = 'Executable',
            Position = 8,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$ProcessId,
        #>

        [Parameter(
            ParameterSetName = 'Network',
            Position = 9,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$IPAddress,

        [Parameter(
            ParameterSetName = 'Computer',
            Position = 10,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [ValidatePattern(".*@.*")]
        [System.String]$ComputerName,

        [Parameter(
            ParameterSetName = 'OU',
            Position = 11,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$OU,

        [Parameter(
            ParameterSetName = 'EnvironmentVariable',
            Position = 12,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [ValidatePattern(".*=.*")]
        [System.String]$EnvironmentVariable,

        [Parameter(
            ParameterSetName = 'EnvironmentVariable',
            Position = 13,
            ValuefromPipelineByPropertyName = $true
        )]
        [Int64]$AssignedTime = 0,

        [Parameter(
            ParameterSetName = 'EnvironmentVariable',
            Position = 14,
            ValuefromPipelineByPropertyName = $true
        )]
        [Int64]$UnAssignedTime = 0
    )

    BEGIN {
        Set-StrictMode -Version Latest
        #check file has correct filename extension
        if ($AssignmentFilePath -notlike "*.fxa") {
            Write-Warning 'Assignment files should have an fxa extension'
        }
        if ( -not ( Test-Path $AssignmentFilePath )) {
            $version = 1
            $minimumLicenseAssignedTime = 0
            Set-Content -Path $AssignmentFilePath -Value "$version`t$minimumLicenseAssignedTime" -Encoding Unicode -ErrorAction Stop
        }

    } # Begin
    PROCESS {

        $assignmentCode = $null
        $idString = $null
        $DistinguishedName = $null
        $FriendlyName = $null


        $convertToFslAssignmentCodeParams = @{}

        if ($RuleSetApplies) {
            $convertToFslAssignmentCodeParams += @{ 'Apply' = $true }
        }
        else {
            $convertToFslAssignmentCodeParams += @{ 'Remove' = $true }
        }

        switch ($PSCmdlet.ParameterSetName) {
            User {

                $convertToFslAssignmentCodeParams += @{ 'User' = $true }

                if ($ADDistinguisedName) {
                    $convertToFslAssignmentCodeParams += @{ 'ADDistinguishedName' = $true }
                    $distinguishedName = $ADDistinguisedName
                }

                $idString = $UserName
                $friendlyName = $UserName
                break
            }
            Group {

                $convertToFslAssignmentCodeParams += @{ 'Group' = $true }

                if ( $ADDistinguisedName ) {
                    $convertToFslAssignmentCodeParams += @{ 'ADDistinguishedName' = $true }
                    $distinguishedName = $ADDistinguisedName
                }

                #Determine if the group has a Well Known SID
                $wks = [Enum]::GetValues([System.Security.Principal.WellKnownSidType])
                $account = New-Object System.Security.Principal.NTAccount($GroupName)
                $sid = $account.Translate([System.Security.Principal.SecurityIdentifier])
                $result = foreach ($s in $wks) { $sid.IsWellKnown($s)}

                if ( $result -contains $true ) {
                    $idString = $sid.Value
                }
                else {
                    $idString = $GroupName
                }

                $friendlyName = $GroupName

                break
            }
            Executable {

                $convertToFslAssignmentCodeParams += @{ 'Process' = $true }

                if ($IncludeChildProcess) {
                    $convertToFslAssignmentCodeParams += @{ 'ApplyToProcessChildren' = $true }
                }
                #if ($ProcessId) {
                #    $convertToFslAssignmentCodeParams += @{ 'ProcessId' = $true }
                #}


                $idString = $ProcessName
                break
            }
            Network {
                $convertToFslAssignmentCodeParams += @{ 'Network' = $true }
                $idString = $IPAddress
                break
            }
            Computer {
                $convertToFslAssignmentCodeParams += @{ 'Computer' = $true }
                $idString = $ComputerName
                break
            }
            OU {
                $convertToFslAssignmentCodeParams += @{ 'ADDistinguishedName' = $true }
                $idString = $OU
                break
            }
            EnvironmentVariable {
                $convertToFslAssignmentCodeParams += @{ 'EnvironmentVariable' = $true }
                $idString = $EnvironmentVariable
                if ( $AssignedTime -eq 0 -and $convertToFslAssignmentCodeParams.Remove -eq $true ) {
                    $AssignedTime = (Get-Date).ToFileTime()
                }
                break
            }
        }

        if ( -not $AssignedTime ) {
            $AssignedTime = 0
        }

        if ( -not $UnAssignedTime ) {
            $UnAssignedTime = 0
        }

        if ( -not (Test-Path variable:script:DistinguishedName) ) {
            $DistinguishedName = ''
        }

        if ( -not (Test-Path variable:script:Passthru) ) {
            $Passthru = $false
        }

        $assignmentCode = ConvertTo-FslAssignmentCode @convertToFslAssignmentCodeParams

        $message = "$assignmentCode`t$idString`t$DistinguishedName`t$FriendlyName`t$AssignedTime`t$UnAssignedTime"

        $addContentParams = @{
            'Path'     = $AssignmentFilePath
            'Encoding' = 'Unicode'
            'Value'    = $message
        }

        Add-Content @addContentParams

        Write-Verbose -Message "Written $message to $AssignmentFilePath"

        if ($passThru) {
            $passThruObject = [pscustomobject]@{
                assignmentCode    = $assignmentCode
                idString          = $idString
                DistinguishedName = $DistinguishedName
                FriendlyName      = $FriendlyName
                AssignedTime      = $AssignedTime
                UnAssignedTime    = $UnAssignedTime
            }
            Write-Output $passThruObject
        }
    } #Process
    END {} #End
}  #function Add-FslAssignment
function Set-FslAssignment {

    <#
        .SYNOPSIS
            Sets the content of a FSLogix Rule assignment file.

        .DESCRIPTION
            This function can set an FSLogix assignment file contents, the assignment file should have the same basename as the matching rule file.
            This will overwrite the contents of an existing file.

        .PARAMETER AssignmentFilePath
            The Target file path to set the assignment within
        .PARAMETER RuleSetApplies
            This determines whether a ruleset does or does not apply to users/groups/processes etc.  For instance when using a Hiding rule, applying that hiding rule to users will hide the file from the users assigned to it when applied.
        .PARAMETER UserName
            If you wish to tie down the rule to an individual user use theier unsername in this parameter.  Groupname is more usual for assignments however
        .PARAMETER GroupName
            Use this to tie the assignment of the rule to a specific group
        .PARAMETER WellKnownSID
            The Well Known SID for groups such as Domain Admins are useful for cross-language assignments, if you use a group with a well known SID in the group name parameter this will be automatically filled out, so mostly useful for pipeline input.
        .PARAMETER ADDistinguisedName
            Full Distinguished name of AD component
        .PARAMETER ProcessName
            Process name for the rule assignment, mostly used for redirect rules
        .PARAMETER IncludeChildProcess
            If Process name is stated you can optionally include chile prcesses (recommended)
        .PARAMETER ProcessId
            If you know process ID, but not name, used for troubleshooting mainly
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
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [Alias('AssignmentFilePath')]
        [System.String]$Path,

        [Parameter(
            ParameterSetName = 'User',
            ValuefromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'Group',
            ValuefromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'Executable',
            ValuefromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'Network',
            ValuefromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'Computer',
            ValuefromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'OU',
            ValuefromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'EnvironmentVariable',
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$RuleSetApplies,

        [Parameter(
            ParameterSetName = 'User',
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$UserName,

        [Parameter(
            ParameterSetName = 'Group',
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$GroupName,

        [Parameter(
            ParameterSetName = 'Group',
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$WellKnownSID,

        [Parameter(
            ParameterSetName = 'User',
            ValuefromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'Group',
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$ADDistinguisedName,

        [Parameter(
            ParameterSetName = 'Executable',
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$ProcessName,

        [Parameter(
            ParameterSetName = 'Executable',
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$IncludeChildProcess,

        [Parameter(
            ParameterSetName = 'Network',
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$IPAddress,

        [Parameter(
            ParameterSetName = 'Computer',
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [ValidatePattern(".*@.*")]
        [System.String]$ComputerName,

        [Parameter(
            ParameterSetName = 'OU',
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$OU,

        [Parameter(
            ParameterSetName = 'EnvironmentVariable',
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [ValidatePattern(".*=.*")]
        [System.String]$EnvironmentVariable,

        [Parameter(
            ParameterSetName = 'EnvironmentVariable',
            ValuefromPipelineByPropertyName = $true
        )]
        [Int64]$AssignedTime = 0,

        [Parameter(
            ParameterSetName = 'EnvironmentVariable',
            ValuefromPipelineByPropertyName = $true
        )]
        [Int64]$UnAssignedTime = 0,

        [Parameter(
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$PassThru,

        [Parameter(
            ParameterSetName = 'AssignmentObjectPipeline',
            ValuefromPipeline = $true,
            ValuefromPipelineByPropertyName = $true
        )]
        [PSTypeName('FSLogix.Assignment')]$InputObject
    )
    BEGIN {
        Set-StrictMode -Version Latest
        $version = 1
        $minimumLicenseAssignedTime = 0
        $setContent = $true

    } # Begin
    PROCESS {

        #Grab current parameters be VERY careful about moving this away from the top of the scriptas it's grabbing the PSItem which can change a lot
        #$BoundParameters = $CommandLineParameters | Reset-PSBoundParameters $PSBoundParameters

        #check file has correct filename extension
        if ($Path -notlike "*.fxa") {
            Write-Warning 'Assignment files should have an fxa extension'
        }

        <#
        #Change Items object to hashtable for use in splatting
        $addFslAssignmentParams = @{}
        $Items | Get-Member -MemberType *Property | ForEach-Object {
            $addFslAssignmentParams.($_.name) = $Items.($_.name)
        }
        #>

        #Add first line if pipeline input
        If ($setContent) {
            Set-Content -Path $Path -Value "$version`t$minimumLicenseAssignedTime" -Encoding Unicode -ErrorAction Stop
            Add-FslAssignment @PSBoundParameters
            $setContent = $false
        }
        else {
            Add-FslAssignment @PSBoundParameters
        }

    } #Process
    END {
    } #End
}  #function Set-FslAssignment
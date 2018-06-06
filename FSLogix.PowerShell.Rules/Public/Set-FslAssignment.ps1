function Set-FslAssignment {
    [CmdletBinding()]

	<#
        .SYNOPSIS
            Sets the content of a FSLogix Rule assignment file.

        .DESCRIPTION
            This function can set an FSLogix assignment file contents, the assignment file should have the same basename as the matching rule file.
            This will overwrite the contents of an existing file.

        .PARAMETER AssignmentFilePath
            The description of a parameter. Add a .PARAMETER keyword for
            each parameter in the function or script syntax.
            Type the parameter name on the same line as the .PARAMETER keyword.
            Type the parameter description on the lines following the .PARAMETER
            keyword. Windows PowerShell interprets all text between the .PARAMETER
            line and the next keyword or the end of the comment block as part of
            the parameter description. The description can include paragraph breaks.
            The Parameter keywords can appear in any order in the comment block, but
            the function or script syntax determines the order in which the parameters
            (and their descriptions) appear in help topic. To change the order,
            change the syntax.
            You can also specify a parameter description by placing a comment in the
            function or script syntax immediately before the parameter variable name.
            If you use both a syntax comment and a Parameter keyword, the description
            associated with the Parameter keyword is used, and the syntax comment is
            ignored.

        .PARAMETER RuleSetApplies
            This determines whether a ruleset does or does not apply to users/groups/processes etc.  For instance when using a Hiding rule, applying that hiding rule to users will hide the file from the users assigned to it when applied.
        .PARAMETER UserName
            If you wish to tie down the rule to an individual user use theier unsername in this parameter.  Groupname is more usual for assignments however
        .PARAMETER GroupName
            Use this to tie the assignment of the rule to a specific group
        .PARAMETER WellKnownSID
            The Well Known SID for groups such as Domain Admins are useful for cross-language 
        .PARAMETER ADDistinguisedName

        .PARAMETER ProcessName

        .PARAMETER IncludeChildProcess

        .PARAMETER ProcessId

        .PARAMETER IPAddress

        .PARAMETER ComputerName

        .PARAMETER OU

        .PARAMETER EnvironmentVariable

        .PARAMETER AssignedTime

        .PARAMETER UnAssignedTime

        .EXAMPLE
            A sample command that uses the function or script, optionaly followed
            by sample output and a description. Repeat this keyword for each example.
    #>

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true
        )]
        [System.String]$AssignmentFilePath,

        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$RuleSetApplies,

        [Parameter(
            Position = 2,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$UserName,

        [Parameter(
            Position = 3,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$GroupName,

        [Parameter(
            Position = 4,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$WellKnownSID,

        [Parameter(
            Position = 6,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$ADDistinguisedName,

        [Parameter(
            Position = 7,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$ProcessName,

        [Parameter(
            Position = 8,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$IncludeChildProcess,

        [Parameter(
            Position = 9,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$ProcessId,

        [Parameter(
            Position = 10,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.Net.IPAddress]$IPAddress,

        [Parameter(
            Position = 11,
            ValuefromPipelineByPropertyName = $true
        )]
        [ValidatePattern(".*@.*")]
        [System.String]$ComputerName,

        [Parameter(
            Position = 12,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$OU,

        [Parameter(
            Position = 13,
            ValuefromPipelineByPropertyName = $true
        )]
        [ValidatePattern(".*=.*")]
        [System.String]$EnvironmentVariable,

        [Parameter(
            Position = 14,
            ValuefromPipelineByPropertyName = $true
        )]
        [Int64]$AssignedTime = 0,

        [Parameter(
            Position = 15,
            ValuefromPipelineByPropertyName = $true
        )]
        [Int64]$UnAssignedTime = 0
    )

    BEGIN {
        Set-StrictMode -Version Latest

        $version = 1
        $minimumLicenseAssignedTime = 0
        $setContent = $true

    } # Begin
    PROCESS {

        #Grab current parameters be VERY careful about moving this away from the top of the scriptas it's grabbing the PSItem which can change a lot
        $Items = $PSItem

        #check file has correct filename extension
        if ($AssignmentFilePath -notlike "*.fxa") {
            Write-Warning 'Assignment files should have an fxa extension'
        }

        #Change Items object to hashtable for use in splatting
        $addFslAssignmentParams = @{}
        $Items | Get-Member -MemberType *Property | ForEach-Object { 
            $addFslAssignmentParams.($_.name) = $Items.($_.name)
        } 
        
        #Add first line if pipeline input
        If ($setContent) {
            Set-Content -Path $AssignmentFilePath -Value "$version`t$minimumLicenseAssignedTime" -Encoding Unicode -ErrorAction Stop
            Add-FslAssignment @addFslAssignmentParams -AssignmentFilePath $AssignmentFilePath
            $setContent = $false
        }
        else {
            Add-FslAssignment @addFslAssignmentParams -AssignmentFilePath $AssignmentFilePath
        }

    } #Process
    END {
    } #End
}  #function Set-FslAssignment
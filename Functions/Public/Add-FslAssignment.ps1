function Add-FslAssignment {
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
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [Validateset($true,$false)]
        [System.String]$RuleSetApplies,

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
            ParameterSetName = 'Process',
            Position = 4,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$ProcessName,

        [Parameter(
            ParameterSetName = 'Process',
            Position = 5,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$IncludeChildProcess,

        [Parameter(
            ParameterSetName = 'Process',
            Position = 6,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$ProcessId,

        [Parameter(
            ParameterSetName = 'Network',
            Position = 7,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.Net.IPAddress]$IPAddress,

        [Parameter(
            ParameterSetName = 'Computer',
            Position = 8,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [ValidatePattern(".*@.*")]
        [System.String]$ComputerName,

        [Parameter(
            ParameterSetName = 'OU',
            Position = 9,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$OU,

        [Parameter(
            ParameterSetName = 'EnvironmentVariable',
            Position = 10,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [ValidatePattern(".*=.*")]
        [System.String]$EnvironmentVariable,

        [Parameter(
            ParameterSetName = 'EnvironmentVariable',
            Position = 11,
            ValuefromPipelineByPropertyName = $true
        )]
        [datetime]$AssignedTime,

        [Parameter(
            ParameterSetName = 'EnvironmentVariable',
            Position = 12,
            ValuefromPipelineByPropertyName = $true
        )]
        [datetime]$UnAssignedTime,

        [Parameter(
            ParameterSetName = 'User',
            Position = 13,
            ValuefromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'Group',
            Position = 13,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$ADDistinguisedName



    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {
        #check file has correct filename extension
        if ($AssignmentFilePath -notlike "*.fxa") {
            Write-Warning 'Assignment files should have an fxa extension'
        }

    } #Process
    END {} #End
}  #function Add-FslAssignment
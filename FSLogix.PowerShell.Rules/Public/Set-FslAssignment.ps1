function Set-FslAssignment {
    [CmdletBinding()]

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
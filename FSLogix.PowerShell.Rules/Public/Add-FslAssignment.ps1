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
            ValuefromPipeline = $true
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

        [Parameter(
            ParameterSetName = 'Executable',
            Position = 8,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$ProcessId,

        [Parameter(
            ParameterSetName = 'Network',
            Position = 9,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.Net.IPAddress]$IPAddress,

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
        [Int]$AssignedTime = (Get-Date).ToFileTime(),

        [Parameter(
            ParameterSetName = 'EnvironmentVariable',
            Position = 14,
            ValuefromPipelineByPropertyName = $true
        )]
        [Int]$UnAssignedTime = 0
    )

    BEGIN {
        Set-StrictMode -Version Latest
        #check file has correct filename extension
        if ($AssignmentFilePath -notlike "*.fxa") {
            Write-Warning 'Assignment files should have an fxa extension'
        }
    } # Begin
    PROCESS {


        $convertToFslAssignmentCodeParams = @{}

        if ($RuleSetApplies) {
            $convertToFslAssignmentCodeParams += @{ 'Apply' = $true }
        }
        else {
            $convertToFslAssignmentCodeParams += @{ 'Remove' = $true }
        }

        switch ($PSCmdlet.ParameterSetName) {
            User {
                switch ($true) {
                    $UserName {$convertToFslAssignmentCodeParams += @{ 'User' = $true }
                    }
                    $ADDistinguisedName {$convertToFslAssignmentCodeParams += @{ 'ADDistinguishedName' = $true }
                    }
                }
                break
            }
            Group {
                switch ($true) {
                    $GroupName {$convertToFslAssignmentCodeParams += @{ 'Group' = $true }
                    }
                    $ADDistinguisedName {$convertToFslAssignmentCodeParams += @{ 'ADDistinguishedName' = $true }
                    }
                }
                break
            }
            Executable {
                switch ($true) {
                    $ProcessName {$convertToFslAssignmentCodeParams += @{ 'Process' = $true }
                    }
                    $IncludeChildProcess {$convertToFslAssignmentCodeParams += @{ 'ApplyToProcessChildren' = $true }
                    }
                    $ProcessId {$convertToFslAssignmentCodeParams += @{ 'ProcessId' = $true }
                    }
                }
                break
            }
            Network {}
            Computer {}
            OU {}
            EnvironmentVariable {}
        }

        $assignmentCode = ConvertTo-FslAssignmentCode @convertToFslAssignmentCodeParams

        Write-Output $assignmentCode
    } #Process
    END {} #End
}  #function Add-FslAssignment
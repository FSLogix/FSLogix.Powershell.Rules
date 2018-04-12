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
        if ( -not ( Test-Path $AssignmentFilePath )){
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
                
                if ( $ADDistinguisedName ){
                    $convertToFslAssignmentCodeParams += @{ 'ADDistinguishedName' = $true }
                    $distinguishedName = $ADDistinguisedName
                }
                
                if ( $WellKnownSID ) {
                    $idString = $WellKnownSID
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
                if ($ProcessId) {
                    $convertToFslAssignmentCodeParams += @{ 'ProcessId' = $true }
                }
                

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
                if ( $AssignedTime -eq 0 -and $convertToFslAssignmentCodeParams.Remove -eq $true ){
                    $AssignedTime = (Get-Date).ToFileTime()
                }
                break
            }
        }

        if ( -not $AssignedTime ){
            $AssignedTime = 0
        }

        if ( -not $UnAssignedTime ){
            $UnAssignedTime = 0
        }

        if ( -not (Test-Path variable:script:DistinguishedName) ){
            $DistinguishedName = ''
        }

        if ( -not (Test-Path variable:script:Passthru) ){
            $Passthru = $false
        }

        $assignmentCode = ConvertTo-FslAssignmentCode @convertToFslAssignmentCodeParams

        $message = "$assignmentCode`t$idString`t$DistinguishedName`t$FriendlyName`t$AssignedTime`t$UnAssignedTime"

        $addContentParams = @{
            'Path'     = $AssignmentFilePath
            'Encoding' = 'Unicode'
            'Value'    =  $message
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
function Set-FslRule {
    [CmdletBinding()]

    Param (

        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$RuleFilePath,

        [Parameter(
            ParameterSetName = 'Hiding',
            Position = 2,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [Parameter(
            ParameterSetName = 'Redirect',
            Position = 2,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [Parameter(
            ParameterSetName = 'AppContainer',
            Position = 2,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [Parameter(
            ParameterSetName = 'SpecifyValue',
            Position = 2,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [Alias('Name')]
        [System.String]$FullName,

        [Parameter(
            ParameterSetName = 'Hiding',
            Mandatory = $true,
            Position = 3,
            ValuefromPipelineByPropertyName = $true
        )]
        [ValidateSet('FolderOrKey', 'FileOrValue', 'Font', 'Printer')]
        [System.String]$HidingType,

        [Parameter(
            ParameterSetName = 'Redirect',
            Mandatory = $true,
            Position = 6,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$RedirectDestPath,

        [Parameter(
            ParameterSetName = 'Redirect',
            Mandatory = $true,
            Position = 7,
            ValuefromPipelineByPropertyName = $true
        )]
        [ValidateSet('FolderOrKey', 'FileOrValue')]
        [string]$RedirectType,

        [Parameter(
            ParameterSetName = 'Redirect',
            Position = 8,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$CopyObject,


        [Parameter(
            ParameterSetName = 'AppContainer',
            Mandatory = $true,
            Position = 9,
            ValuefromPipelineByPropertyName = $true
        )]
        [string]$DiskFile,

        [Parameter(
            ParameterSetName = 'SpecifyValue',
            Mandatory = $true,
            Position = 10,
            ValuefromPipelineByPropertyName = $true
        )]
        [Alias('Binary')]
        [string]$Data,

        [Parameter(
            Position = 11,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$Comment = 'Created By PowerShell Script',

        [Parameter(
            Position = 13,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Passthru,

        [Parameter(
            ParameterSetName = 'RuleObjectPipeline',
            Position = 14,
            ValuefromPipeline = $true,
            ValuefromPipelineByPropertyName = $true
        )]
        [PSTypeName('FSLogix.Rule')]$RuleObject
    )


    BEGIN {
        Set-StrictMode -Version Latest
        #fix $PSBoundparameters bug
        #$CommandLineParameters = $PSBoundParameters | Start-FixPSBoundParameters
        $version = 1
        $setContent = $true
    } # Begin
    PROCESS {

        #Grab current parameters be VERY careful about moving this away from the top of the scriptas it's grabbing the PSItem which can change a lot
        #$Items = $PSItem
        #$BoundParameters = $CommandLineParameters | Reset-PSBoundParameters $PSBoundParameters

        #check file has correct filename extension
        if ($RuleFilePath -notlike "*.fxr") {
            Write-Warning 'The Rule file should have an fxr extension'
        }

        <#
        #Change Items object to hashtable for use in splatting
        $addFslRuleParams = @{}
        $Items | Get-Member -MemberType *Property | ForEach-Object {
            $addFslRuleParams.($_.name) = $Items.($_.name)
        }
        #>

        #Add first line if pipeline input
        If ($setContent) {
            Set-Content -Path $RuleFilePath -Value $version -Encoding Unicode -ErrorAction Stop
            Add-FslRule @PSBoundParameters   # -RuleFilePath $RuleFilePath
            $setContent = $false
        }
        else {
            Add-FslRule @PSBoundParameters    #-RuleFilePath $RuleFilePath
        }
    } #Process
    END {} #End
}  #function Set-FslRule

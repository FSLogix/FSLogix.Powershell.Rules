function Set-FslRule {
    [CmdletBinding()]

    Param (

        [Parameter(
            Position = 1,
            ValuefromPipeline = $true,
            ValuefromPipelineByPropertyName = $true
        )]
        [Alias('Name')]
        [System.String]$FullName,

        [Parameter(
            Position = 2,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$RuleFilePath,

        [Parameter(
            Position = 3,
            ValuefromPipelineByPropertyName = $true
        )]
        [ValidateSet('FolderOrKey', 'FileOrValue', 'Font', 'Printer')]
        [System.String]$HidingType,

        [Parameter(
            Position = 6,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$RedirectDestPath,

        [Parameter(
            Position = 7,
            ValuefromPipelineByPropertyName = $true
        )]
        [ValidateSet('FolderOrKey', 'FileOrValue')]
        [System.String]$RedirectType,

        [Parameter(
            Position = 8,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$CopyObject,


        [Parameter(
            Position = 9,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$DiskFile,

        [Parameter(
            Position = 10,
            ValuefromPipelineByPropertyName = $true
        )]
        [Alias('Binary')]
        [System.String]$Data,

        [Parameter(
            Position = 11,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$Comment = 'Created By Powershell Script',

        [Parameter(
            Position = 13,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Passthru
    )


    BEGIN {
        Set-StrictMode -Version Latest
        $version = 1
        $setContent = $true
        Set-Content -Path $RuleFilePath -Value $version -Encoding Unicode -ErrorAction Stop
    } # Begin
    PROCESS {

        #Grab current parameters be VERY careful about moving this away from the top of the scriptas it's grabbing the PSItem which can change a lot
        $Items = $PSItem

        #check file has correct filename extension
        if ($RuleFilePath -notlike "*.fxr") {
            Write-Warning 'The Rule file should have an fxr extension'
        }

        #Change Items object to hashtable for use in splatting
        $addFslRuleParams = @{}
        $Items | Get-Member -MemberType *Property | ForEach-Object {
            $addFslRuleParams.($_.name) = $Items.($_.name)
        }

        #Add first line if pipeline input
        If ($setContent) {
            Set-Content -Path $RuleFilePath -Value $version -Encoding Unicode -ErrorAction Stop
            Add-FslRule @addFslRuleParams -RuleFilePath $RuleFilePath
            $setContent = $false
        }
        else {
            Add-FslRule @addFslRuleParams -RuleFilePath $RuleFilePath
        }
    } #Process
    END {} #End
}  #function Set-FslRule

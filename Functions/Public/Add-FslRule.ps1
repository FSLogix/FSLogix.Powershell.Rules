function Add-FslRule {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipeline = $true,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [Alias('Name')]
        [System.String]$FullName,

        [Parameter(
            ParameterSetName = 'RuleType',
            Position = 1,
            ValuefromPipelineByPropertyName = $true
        )]
        [ValidateSet('Hiding', 'Redirect', 'Java', 'SpecificData', 'VolumeAutomount')]
        [System.String]$RuleType = 'Hiding',

        [Parameter(
            Position = 2,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$RedirectTarget,

        [Parameter(
            Position = 3,
            Mandatory = $true,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$RuleFilePath,

        [Parameter(
            ParameterSetName = 'RuleType',
            Position = 5,
            ValuefromPipelineByPropertyName = $true
        )]
        [ValidateSet('File', 'Folder', 'RegistryValue', 'RegistryKey', 'Font', 'Printer')]
        [string]$RuleTarget = 'File',

        [Parameter(
            ParameterSetName = 'RuleType',
            Position = 7,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$CopyObject,

        [Parameter(
            Position = 8,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$Comment = 'Created By Powershell Script',

        [Parameter(
            ParameterSetName = 'Flags',
            Position = 9,
            Mandatory = $true,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$Flags,

        [Parameter(
            Position = 10,
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Passthru
    )


    BEGIN {
        Set-StrictMode -Version Latest
        $FRX_RULE_SRC_IS_A_FILE_OR_VALUE = 0x00000002
        $FRX_RULE_TYPE_REDIRECT = 0x00000100
    } # Begin
    PROCESS {
        if ($PSCmdlet.ParameterSetName -eq 'RuleType') {

            $convertToFslRuleCodeParams = @{
                'Persistent' = $true
                'CopyObject' = $CopyObject
            }

            switch ($true) {
                { $RuleTarget -eq 'Font' } { $convertToFslRuleCodeParams += @{ 'HideFont' = $true }}
                { $RuleTarget -eq 'Printer' } { $convertToFslRuleCodeParams += @{ 'HidePrinter' = $true }}
                { $RuleTarget -eq 'File' -or $RuleTarget -eq 'RegistryValue'} { $convertToFslRuleCodeParams += @{ 'FileOrValue' = $true }}
                { $RuleTarget -eq 'Folder' -or $RuleTarget -eq 'RegistryKey'} { $convertToFslRuleCodeParams += @{ 'FolderOrKey' = $true }}
                { $RuleType -eq 'VolumeAutoMount' } { $convertToFslRuleCodeParams += @{ 'VolumeAutomount' = $true }}
                { $RuleType -eq 'SpecificData' } { $convertToFslRuleCodeParams += @{ 'SpecificData' = $true }}
                { $RuleType -eq 'Java' } { $convertToFslRuleCodeParams += @{ 'Java' = $true }}
                { $RuleType -eq 'Redirect' } { $convertToFslRuleCodeParams += @{ 'Redirect' = $true }}
                { $RuleType -eq 'Hiding' -and
                $RuleTarget -ne 'Font' -and
                $RuleTarget -ne 'Printer' } { $convertToFslRuleCodeParams += @{ 'Hiding' = $true }}         
            }

            $Flags = ConvertTo-FslRuleCode @convertToFslRuleCodeParams
        }



        if ($flags -bor  $FRX_RULE_SRC_IS_A_FILE_OR_VALUE) {
            $sourceParent = Split-Path $FullName -Parent
            $source = Split-Path $FullName -Leaf
        }
        else {
            $sourceParent = $FullName
            $source = ''
        }

        if ($flags -band $FRX_RULE_SRC_IS_A_FILE_OR_VALUE -and 
            $flags -band $FRX_RULE_TYPE_REDIRECT) {
            $destParent = Split-Path $RedirectTarget -Parent
            $dest = Split-Path $RedirectTarget -Leaf
        }
        else {
            $destParent = $RedirectTarget
            $dest = ''
        }

        #Binary is an unused field in fxr files
        $binary = $null

        $addContentParams = @{
            'Path'     = $RuleFilePath
            'Encoding' = 'Unicode'
        }

        Add-Content @addContentParams -Value "##$Comment"
        Write-Verbose -Message "Written $Comment to $RuleFilePath"

        $message = "$SourceParent`t$Source`t$DestParent`t$Dest`t$Flags`t$binary"

        Add-Content @addContentParams -Value $message

        Write-Verbose -Message "Written $message to $RuleFilePath"

        If($passThru){
            $passThruObject = [pscustomobject]@{
                SourceParent = $SourceParent
                Source = $Source
                DestParent = $DestParent
                Dest = $Dest
                Flags = $Flags
                binary = $binary
                Comment = $Comment
            }
            Write-Output $passThruObject
        }

    } #Process
    END {} #End
}  #function Add-FslRule

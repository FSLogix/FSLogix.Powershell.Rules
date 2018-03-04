function Add-FslRule {
    [CmdletBinding()]

    Param (

        [Parameter(
            Position = 1,
            ValuefromPipeline = $true,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [Alias('Name')]
        [System.String]$FullName,

        [Parameter(
            Position = 2,
            Mandatory = $true,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$RuleFilePath,

        [Parameter(
            ParameterSetName = 'Hiding',
            Mandatory = $true,
            Position = 3,
            ValuefromPipelineByPropertyName = $true
        )]
        [ValidateSet('File', 'Folder', 'RegistryValue', 'RegistryKey', 'Font', 'Printer')]
        [string]$HidingType,

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
        [ValidateSet('File', 'Folder', 'RegistryValue', 'RegistryKey')]
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
        [string]$Data,

        [Parameter(
            Position = 11,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$Comment = 'Created By Powershell Script',

        [Parameter(
            ParameterSetName = 'Flags',
            Position = 12,
            Mandatory = $true,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$Flags,

        [Parameter(
            Position = 13,
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

        $convertToFslRuleCodeParams = @{
            'Persistent' = $true
            'CopyObject' = $CopyObject
        }        

        switch ($PSCmdlet.ParameterSetName) {

            Hiding {  
                switch ($true) {
                    { $HidingType -eq 'Font' } { $convertToFslRuleCodeParams += @{ 'HideFont' = $true } }
                    { $HidingType -eq 'Printer' } { $convertToFslRuleCodeParams += @{ 'HidePrinter' = $true } }
                    { $HidingType -eq 'File' -or $HidingType -eq 'RegistryValue'} { $convertToFslRuleCodeParams += @{ 'FileOrValue' = $true } }
                    { $HidingType -eq 'Folder' -or $HidingType -eq 'RegistryKey'} { $convertToFslRuleCodeParams += @{ 'FolderOrKey' = $true } }
                    { $HidingType -ne 'Font' -and $HidingType -ne 'Printer' } { $convertToFslRuleCodeParams += @{ 'Hiding' = $true } }
                }
                break
            }
            Redirect {  
                $convertToFslRuleCodeParams += @{ 'Redirect' = $true }
                break
            }
            AppContainer {  
                $convertToFslRuleCodeParams += @{ 'VolumeAutomount' = $true }
                break
            }
            SpecifyValue {  
                $convertToFslRuleCodeParams += @{ 'SpecificData' = $true }
                break
            }
            Flags {  
                #No neccesary actions
                break
            }
        }
        if (-not $Flags){
            $flags = ConvertTo-FslRuleCode @convertToFslRuleCodeParams
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
            $destParent = Split-Path $RedirectDestPath -Parent
            $dest = Split-Path $RedirectDestPath -Leaf
        }
        else {
            $destParent = $RedirectDestPath
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

        If ($passThru) {
            $passThruObject = [pscustomobject]@{
                SourceParent = $SourceParent
                Source       = $Source
                DestParent   = $DestParent
                Dest         = $Dest
                Flags        = $Flags
                binary       = $binary
                Comment      = $Comment
            }
            Write-Output $passThruObject
        }

    } #Process
    END {} #End
}  #function Add-FslRule
function Add-FslRule {
    [CmdletBinding()]

    Param (

        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValuefromPipelineByPropertyName = $true
        )]
        [Alias('RuleFilePath')]
        [System.String]$Path,

        [Parameter(
            ParameterSetName = 'Hiding',
            Position = 2,
            ValueFromPipeline = $true,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [Parameter(
            ParameterSetName = 'Redirect',
            Position = 2,
            ValueFromPipeline = $true,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [Parameter(
            ParameterSetName = 'AppContainer',
            Position = 2,
            ValueFromPipeline = $true,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [Parameter(
            ParameterSetName = 'SpecifyValue',
            Position = 2,
            ValueFromPipeline = $true,
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
        [string]$ValueData,

        [Parameter(
            ParameterSetName = 'SpecifyValue',
            Mandatory = $false,
            ValuefromPipelineByPropertyName = $true
        )]
        [ValidateSet('String', 'DWORD', 'QWORD', 'Multi-String', 'ExpandableString')]
        [string]$RegValueType = 'String',

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
            ValuefromPipeline = $true,
            ValuefromPipelineByPropertyName = $true
        )]
        [PSTypeName('FSLogix.Rule')]$RuleObject
    )

    BEGIN {
        Set-StrictMode -Version Latest

        $FRX_RULE_SRC_IS_A_FILE_OR_VALUE = 0x00000002
        $FRX_RULE_TYPE_REDIRECT = 0x00000100
        $FRX_RULE_TYPE_SPECIFIC_DATA = 0x00000800

    } # Begin
    PROCESS {

        if ( -not ( Test-Path $Path )) {
            $version = 1
            Set-Content -Path $Path -Value $version -Encoding Unicode -ErrorAction Stop
        }
        #check file has correct filename extension
        if ($Path -notlike "*.fxr") {
            Write-Warning 'Rule files should have an fxr extension'
        }

        $convertToFslRuleCodeParams = @{ }

        #This switch statement sets up the function parameters for ConvertT-FslRuleCode
        switch ($PSCmdlet.ParameterSetName) {

            Hiding {
                switch ($true) {
                    { $HidingType -eq 'Font' } { $convertToFslRuleCodeParams += @{ 'HideFont' = $true }
                    }
                    { $HidingType -eq 'Printer' } { $convertToFslRuleCodeParams += @{ 'Printer' = $true }
                    }
                    { $HidingType -eq 'FileOrValue' } { $convertToFslRuleCodeParams += @{ 'FileOrValue' = $true }
                    }
                    { $HidingType -eq 'FolderOrKey' } { $convertToFslRuleCodeParams += @{ 'FolderOrKey' = $true }
                    }
                    { $HidingType -ne 'Font' -and $HidingType -ne 'Printer' } { $convertToFslRuleCodeParams += @{ 'Hiding' = $true }
                    }
                }
                break
            }
            Redirect {
                $convertToFslRuleCodeParams += @{ 'Redirect' = $true }

                switch ($true) {
                    { $RedirectType -eq 'FileOrValue' } { $convertToFslRuleCodeParams += @{ 'FileOrValue' = $true }
                    }
                    { $RedirectType -eq 'FolderOrKey' } { $convertToFslRuleCodeParams += @{ 'FolderOrKey' = $true }
                    }
                }
                $convertToFslRuleCodeParams += @{
                    'CopyObject' = $CopyObject
                }

                break
            }
            AppContainer {
                $convertToFslRuleCodeParams += @{ 'VolumeAutomount' = $true }
                break
            }
            SpecifyValue {
                $convertToFslRuleCodeParams += @{ 'SpecificData' = $true }
                $convertToFslRuleCodeParams += @{ 'FileOrValue' = $true }
                break
            }
            RuleObjectPipeline {
                if ($RuleObject.HidingType) {
                    switch ($true) {
                        { $RuleObject.HidingType -eq 'Font' } { $convertToFslRuleCodeParams += @{ 'HideFont' = $true }
                        }
                        { $RuleObject.HidingType -eq 'Printer' } { $convertToFslRuleCodeParams += @{ 'Printer' = $true }
                        }
                        { $RuleObject.HidingType -eq 'FileOrValue' } { $convertToFslRuleCodeParams += @{ 'FileOrValue' = $true }
                        }
                        { $RuleObject.HidingType -eq 'FolderOrKey' } { $convertToFslRuleCodeParams += @{ 'FolderOrKey' = $true }
                        }
                        { $RuleObject.HidingType -ne 'Font' -and $RuleObject.HidingType -ne 'Printer' } { $convertToFslRuleCodeParams += @{ 'Hiding' = $true }
                        }
                    }
                }
                if ($RuleObject.RedirectType) {
                    $convertToFslRuleCodeParams += @{ 'Redirect' = $true }
                    switch ($true) {
                        { $RuleObject.RedirectType -eq 'FileOrValue' } { $convertToFslRuleCodeParams += @{ 'FileOrValue' = $true }
                        }
                        { $RuleObject.RedirectType -eq 'FolderOrKey' } { $convertToFslRuleCodeParams += @{ 'FolderOrKey' = $true }
                        }
                    }
                }
                if ($RuleObject.DiskFile) {
                    $convertToFslRuleCodeParams += @{ 'VolumeAutomount' = $true }
                }
                if ($RuleObject.Data) {
                    $convertToFslRuleCodeParams += @{ 'SpecificData' = $true }
                    $convertToFslRuleCodeParams += @{ 'FileOrValue' = $true }
                    $RegValueType = $RuleObject.RegValueType
                    $ValueData = $RuleObject.Data
                }
                if ($RuleObject.CopyObject) {
                    $convertToFslRuleCodeParams += @{ 'CopyObject' = $true }
                }
                $FullName = $RuleObject.FullName
                $RedirectDestPath = $RuleObject.RedirectDestPath
            }

        }

        $flags = ConvertTo-FslRuleCode @convertToFslRuleCodeParams

        switch ($true) {
            (($flags -band  $FRX_RULE_TYPE_SPECIFIC_DATA) -eq 2048) {
                $sourceParent = Split-Path $FullName -Parent
                $source = Split-Path $FullName -Leaf

                switch ($RegValueType) {
                    String {
                        #$RegValueTypeFile = 'StringValue'
                        $binary = ConvertTo-FslRegHex -RegData $ValueData -RegValueType $RegValueType
                        break
                    }
                    DWORD {
                        #$RegValueTypeFile = 'dword'

                        $binary = try {
                            #$intValueData = [uint32]$ValueData
                            try {
                                ConvertTo-FslRegHex -RegData $ValueData -RegValueType $RegValueType -ErrorAction Stop
                            }
                            catch {
                                Write-Error "Could not convert $ValueData of value $RegValueType to a registry hex code"
                            }
                        }
                        catch {
                            Write-Error "Could not convert $ValueData to an Integer"
                            exit
                        }
                        break
                    }
                    QWORD {
                        #$RegValueTypeFile = 'qword'
                        $binary = try {
                            #$intValueData = [int32]$ValueData
                            try {
                                ConvertTo-FslRegHex -RegData $ValueData -RegValueType $RegValueType -ErrorAction Stop
                            }
                            catch {
                                Write-Error "Could not convert $ValueData of value $RegValueType to a registry hex code"
                            }
                        }
                        catch {
                            Write-Error "Could not convert $ValueData to an Integer"
                            exit
                        }
                        break
                    }
                    Multi-String {
                        #$RegValueTypeFile = 'Multi-String'
                        break
                    }
                    ExpandableString {
                        #$RegValueTypeFile = 'ExpandableString'
                        break
                    }
                }
                break
            }
            (($flags -band  $FRX_RULE_SRC_IS_A_FILE_OR_VALUE) -eq 2) {
                $sourceParent = Split-Path $FullName -Parent
                $source = Split-Path $FullName -Leaf
                $binary = $null
                break
            }
            Default {
                $sourceParent = $FullName
                $source = $null
                $binary = $null
            }
        }

        if ($flags -band $FRX_RULE_SRC_IS_A_FILE_OR_VALUE -and
            $flags -band $FRX_RULE_TYPE_REDIRECT) {
            $destParent = Split-Path $RedirectDestPath -Parent
            $dest = Split-Path $RedirectDestPath -Leaf
        }
        else {
            $destParent = $RedirectDestPath
            $dest = $null
        }

        $addContentParams = @{
            'Path'     = $Path
            'Encoding' = 'Unicode'
            'WhatIf'   = $false
        }

        Add-Content @addContentParams -Value "##$Comment"
        Write-Verbose -Message "Written $Comment to $Path"

        If ($convertToFslRuleCodeParams.ContainsKey( 'CopyObject' ) -and
            $convertToFslRuleCodeParams.ContainsKey( 'Redirect' ) -and
            $convertToFslRuleCodeParams.ContainsKey( 'FolderOrKey' ) ) {
            $SourceParent = $SourceParent.TrimEnd('\') + '\'
            $destParent = $destParent.TrimEnd('\') + '\'
        }
        else {
            $destParent = $destParent.TrimEnd('\')
        }

        $message = "$SourceParent`t$Source`t$DestParent`t$Dest`t$Flags`t$binary"

        Add-Content @addContentParams -Value $message

        Write-Verbose -Message "Written $message to $Path"

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
    END { } #End
}  #function Add-FslRule
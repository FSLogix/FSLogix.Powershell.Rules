function ConvertFrom-FslRuleCode {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [Int]$RuleCode
    )

    BEGIN {
        Set-StrictMode -Version Latest
        $FRX_RULE_SRC_IS_A_DIR_OR_KEY = 0x00000001
        $FRX_RULE_SRC_IS_A_FILE_OR_VALUE = 0x00000002
        $FRX_RULE_SHOULD_COPY_FILE = 0x00000010
        $FRX_RULE_TYPE_REDIRECT = 0x00000100
        $FRX_RULE_TYPE_HIDING = 0x00000200
        $FRX_RULE_TYPE_HIDE_PRINTER = 0x00000400
        $FRX_RULE_TYPE_SPECIFIC_DATA = 0x00000800 #Specific Value Rule
        $FRX_RULE_TYPE_JAVA = 0x00001000
        $FRX_RULE_TYPE_VOLUME_AUTOMOUNT = 0x00002000
        $FRX_RULE_TYPE_HIDE_FONT = 0x00004000
    } # Begin

    PROCESS {

        switch ($true) {
            { $RuleCode -band $FRX_RULE_SRC_IS_A_DIR_OR_KEY } { $folderOrKey = $true }
            { -not ( $RuleCode -band $FRX_RULE_SRC_IS_A_DIR_OR_KEY ) } { $folderOrKey = $false}
            { $RuleCode -band $FRX_RULE_SRC_IS_A_FILE_OR_VALUE } {$fileOrValue = $true}
            { -not ( $RuleCode -band $FRX_RULE_SRC_IS_A_FILE_OR_VALUE ) } { $fileOrValue = $false }
            { $RuleCode -band $FRX_RULE_SHOULD_COPY_FILE } { $copyObject = $true }
            { -not ( $RuleCode -band $FRX_RULE_SHOULD_COPY_FILE ) } { $copyObject = $false }
            { $RuleCode -band $FRX_RULE_TYPE_REDIRECT } { $redirect = $true}
            { -not ( $RuleCode -band $FRX_RULE_TYPE_REDIRECT ) } { $redirect = $false }
            { $RuleCode -band $FRX_RULE_TYPE_HIDING } { $hiding = $true}
            { -not ( $RuleCode -band $FRX_RULE_TYPE_HIDING ) } { $hiding = $false }
            { $RuleCode -band $FRX_RULE_TYPE_HIDE_PRINTER } { $hidePrinter = $true }
            { -not ( $RuleCode -band $FRX_RULE_TYPE_HIDE_PRINTER ) } { $hidePrinter = $false}
            { $RuleCode -band $FRX_RULE_TYPE_SPECIFIC_DATA } { $specificData = $true }
            { -not ( $RuleCode -band $FRX_RULE_TYPE_SPECIFIC_DATA ) } { $specificData = $false }
            { $RuleCode -band $FRX_RULE_TYPE_JAVA } { $java = $true }
            { -not ( $RuleCode -band $FRX_RULE_TYPE_JAVA ) } { $java = $false }
            { $RuleCode -band $FRX_RULE_TYPE_VOLUME_AUTOMOUNT } { $volumeAutoMount = $true}
            { -not ( $RuleCode -band $FRX_RULE_TYPE_VOLUME_AUTOMOUNT ) } { $volumeAutoMount = $false }
            { $RuleCode -band $FRX_RULE_TYPE_HIDE_FONT } { $font = $true }
            { -not ( $RuleCode -band $FRX_RULE_TYPE_HIDE_FONT ) } { $font = $false }
            default {}
        } #Switch

        $outObject = [PSCustomObject]@{
            'FolderOrKey'     = $folderOrKey
            'FileOrValue'     = $fileOrValue
            'CopyObject'      = $copyObject
            'Redirect'        = $redirect
            'Hiding'          = $hiding
            'Printer'         = $hidePrinter
            'SpecificData'    = $specificData
            'Java'            = $java
            'VolumeAutoMount' = $volumeAutoMount
            'HideFont'        = $font
        }
        Write-Output $outObject
    } #Process
    END {} #End
}  #function ConvertFrom-FslRuleCode
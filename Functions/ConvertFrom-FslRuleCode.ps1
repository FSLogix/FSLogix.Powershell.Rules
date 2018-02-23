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
    } # Begin
    PROCESS {

        $FRX_RULE_SRC_IS_A_DIR_OR_KEY       = 0x00000001
        $FRX_RULE_SRC_IS_A_FILE_OR_VALUE    = 0x00000002
        $FRX_RULE_CONTAINS_USER_VARS        = 0x00000008
        $FRX_RULE_SHOULD_COPY_FILE          = 0x00000010
        $FRX_RULE_IS_PERSISTANT             = 0x00000020 #Ask what this means
        $FRX_RULE_TYPE_REDIRECT             = 0x00000100
        $FRX_RULE_TYPE_HIDING               = 0x00000200
        $FRX_RULE_TYPE_HIDE_PRINTER	        = 0x00000400
        $FRX_RULE_TYPE_SPECIFIC_DATA        = 0x00000800 #Specific Value Rule
        $FRX_RULE_TYPE_JAVA                 = 0x00001000
        $FRX_RULE_TYPE_VOLUME_AUTOMOUNT     = 0x00002000 #Ask what this means
        $FRX_RULE_TYPE_HIDE_FONT            = 0x00004000
        $FRX_RULE_TYPE_MASK                 = 0x00007F00 #Ask what this means


        switch ($true){
            { $RuleCode -band $FRX_RULE_SRC_IS_A_DIR_OR_KEY } { Write-Output 'Key'}
            { -not ( $RuleCode -band $FRX_RULE_SRC_IS_A_DIR_OR_KEY ) } { Write-Output 'Not Key'}
            { $RuleCode -band $FRX_RULE_SRC_IS_A_FILE_OR_VALUE } { Write-Output 'File'}
            { -not ( $RuleCode -band $FRX_RULE_SRC_IS_A_FILE_OR_VALUE ) } { Write-Output 'Not File'}
            { $RuleCode -band $FRX_RULE_CONTAINS_USER_VARS } { Write-Output 'Vars'}
            { -not ( $RuleCode -band $FRX_RULE_CONTAINS_USER_VARS ) } { Write-Output 'Not Vars'}
            { $RuleCode -band $FRX_RULE_SHOULD_COPY_FILE } { Write-Output 'Copy'}
            { -not ( $RuleCode -band $FRX_RULE_SHOULD_COPY_FILE ) } { Write-Output 'Not Copy'}
            { $RuleCode -band $FRX_RULE_IS_PERSISTANT } { Write-Output 'Persistent'}
            { -not ( $RuleCode -band $FRX_RULE_IS_PERSISTANT ) } { Write-Output 'Not Persistent'}
            { $RuleCode -band $FRX_RULE_TYPE_REDIRECT } { Write-Output 'Redirect'}
            { -not ( $RuleCode -band $FRX_RULE_TYPE_REDIRECT ) } { Write-Output 'Not Redirect'}
            { $RuleCode -band $FRX_RULE_TYPE_HIDING } { Write-Output 'Hiding'}
            { -not ( $RuleCode -band $FRX_RULE_TYPE_HIDING ) } { Write-Output 'Not Hiding'}
            { $RuleCode -band $FRX_RULE_TYPE_HIDE_PRINTER } { Write-Output 'Printer'}
            { -not ( $RuleCode -band $FRX_RULE_TYPE_HIDE_PRINTER ) } { Write-Output 'Not Printer'}
            { $RuleCode -band $FRX_RULE_TYPE_SPECIFIC_DATA } { Write-Output 'Specific'}
            { -not ( $RuleCode -band $FRX_RULE_TYPE_SPECIFIC_DATA ) } { Write-Output 'Not Specific'}
            { $RuleCode -band $FRX_RULE_TYPE_JAVA } { Write-Output 'Java'}
            { -not ( $RuleCode -band $FRX_RULE_TYPE_JAVA ) } { Write-Output 'Not Java'}
            { $RuleCode -band $FRX_RULE_TYPE_VOLUME_AUTOMOUNT } { Write-Output 'Mount'}
            { -not ( $RuleCode -band $FRX_RULE_TYPE_VOLUME_AUTOMOUNT ) } { Write-Output 'Not Mount'}
            { $RuleCode -band $FRX_RULE_TYPE_HIDE_FONT } { Write-Output 'Font'}
            { -not ( $RuleCode -band $FRX_RULE_TYPE_HIDE_FONT ) } { Write-Output 'Not Font'}
            { $RuleCode -band $FRX_RULE_TYPE_MASK } { Write-Output 'Mask'}
            { -not ( $RuleCode -band $FRX_RULE_TYPE_MASK ) } { Write-Output 'Not Mask'}
            default {}
        }
    } #Process
    END {} #End
}  #function ConvertFrom-FslRuleCode
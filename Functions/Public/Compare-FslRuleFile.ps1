function Compare-FslRuleFile {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.Array]$Files,

        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true
        )]
        [System.String]$OutputPath = "$PSScriptRoot"
    )

    BEGIN {
        Set-StrictMode -Version Latest
        $FRX_RULE_TYPE_HIDING = 0x00000200
        $FRX_RULE_SRC_IS_A_DIR_OR_KEY = 0x00000001
    } # Begin
    PROCESS {

        foreach ($filepath in $Files) {
            if (-not (Test-Path $filepath)){
                Write-Error "$filepath does not exist"
                exit
            }
        }

        foreach ($filepath in $Files) {
            $diffRule = @()

            $referenceFile = $filepath
            $baseFileName = $filepath | Get-ChildItem | Select-Object -ExpandProperty BaseName
            $rules = Get-FslRule $filepath
            #Get hiding rules (only concerned with hiding rules that are registry keys)
            $refRule = $rules | Where-Object { $_.Flags -band $FRX_RULE_TYPE_HIDING -and $_.Flags -band $FRX_RULE_SRC_IS_A_DIR_OR_KEY -and $_.FullName -like "HKLM*"} | Select-Object -ExpandProperty FullName

            foreach ($filepath in $Files){
                if ($filepath -ne $referenceFile){
                    $notRefRule = Get-FslRule $filepath
                     #Get hiding rules (only concerned with hiding rules that are registry keys)
                    $notRefHideRules = $notRefRule | Where-Object { $_.Flags -band $FRX_RULE_TYPE_HIDING -and $_.Flags -band $FRX_RULE_SRC_IS_A_DIR_OR_KEY -and $_.FullName -like "HKLM*"} | Select-Object -ExpandProperty FullName
                    $diffRule += $notRefHideRules
                }
            }

            #get rid of dupes between the rest of the files
            $uniqueDiffRule = $diffRule | Group-Object | Select-Object -ExpandProperty Name

            #Add all together
            $refAndDiff = $refRule + $uniqueDiffRule

            #Get Dupes between current file and rest of files
            $dupes = $refAndDiff  | Group-Object | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Name

            #remove dupes from old rule list
            $newRules = $rules | Where-Object {$dupes -notcontains $_.FullName }

            $newRuleFileName = Join-Path $OutputPath ($baseFileName + '_Hiding' + '.fxr')

            $newRedirectFileName = Join-Path $OutputPath ($baseFileName + '_Redirect' + '.fxr')

            $newRules | Set-FslRule -RuleFilePath $newRuleFileName

            $newRedirect = $dupes | Select-Object -Property @{n='FullName';e={$_}}, @{n='RedirectDestPath';e={
                "HKLM\Software\FSLogix\Redirect\$($baseFileName)\$($_.TrimStart('HKLM\'))"
            }}

            $newRedirect | Set-FslRule -RuleFilePath $newRedirectFileName -RedirectType FolderOrKey


        }

    } #Process
    END {} #End
}  #function Compare-FslRuleFile

. .\Get-FslRule.ps1
. .\Set-FslRule.ps1
. .\Add-FslRule.ps1
. ..\Private\ConvertTo-FslRuleCode.ps1
. ..\Private\ConvertFrom-FslRuleCode.ps1

Compare-FslRuleFile -Files  ..\..\TestFiles\AppRule_Project2013Pro.fxr, ..\..\TestFiles\AppRule_Office2013.fxr, ..\..\TestFiles\AppRule_Visio2013Pro.fxr
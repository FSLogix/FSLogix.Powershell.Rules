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
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $false
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
            $rules = Get-FslRule $filepath
            #Get hiding rules (only concerned with hiding rules that are registry keys)
            $refRule = $rules | Where-Object { $_.Flags -band $FRX_RULE_TYPE_HIDING -and $_.Flags -band $FRX_RULE_SRC_IS_A_DIR_OR_KEY -and $_.SrcParent -like "HKLM*"} | Select-Object -ExpandProperty SrcParent

            foreach ($filepath in $Files){
                if ($filepath -ne $referenceFile){
                    $notRefRule = Get-FslRule $filepath
                     #Get hiding rules (only concerned with hiding rules that are registry keys)
                    $notRefHideRules = $notRefRule | Where-Object { $_.Flags -band $FRX_RULE_TYPE_HIDING -and $_.Flags -band $FRX_RULE_SRC_IS_A_DIR_OR_KEY -and $_.SrcParent -like "HKLM*"} | Select-Object -ExpandProperty SrcParent
                    $diffRule += $notRefHideRules 
                }
            }

            $uniqueDiffRule = $diffRule | Group-Object | Select-Object -ExpandProperty Name 
            
            $refAndDiff = $refRule + $uniqueDiffRule

            $dupes = $refAndDiff  | Group-Object | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Name

            $dupes.count

            $newHiding = $rules | Where-Object {$dupes -notcontains $_.SrcParent }

            $newRedirect = $rules | Where-Object {$dupes -contains $_.SrcParent }

            $newHiding.count# | Set-FslRule
            $newRedirect.count

        }
        
    } #Process
    END {} #End
}  #function Compare-FslRuleFile

. D:\PoSHCode\GitHub\Create-Rules-Files\Functions\Public\Get-FslRule.ps1

Compare-FslRuleFile -Files D:\PoSHCode\GitHub\Create-Rules-Files\TestFiles\AppRule_Project2013Pro.fxr, D:\PoSHCode\GitHub\Create-Rules-Files\TestFiles\AppRule_Office2013.fxr, D:\PoSHCode\GitHub\Create-Rules-Files\TestFiles\AppRule_Visio2013Pro.fxr
function Add-FslNewRuleFile {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String[]]$VisibleAppHidingRule,

        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true

        )]
        [System.String[]]$HidableAppHidingRule,

        [Parameter(
            Position = 2,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$OutHidingFile,

        [Parameter(
            Position = 3,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$OutRedirectFile,

        [Parameter(
            Position = 4,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$AppName
    )

    BEGIN {
        Set-StrictMode -Version Latest

        #region load helper functions

        #Find-DuplicateLine
        function Find-DuplicateLine {
            [cmdletbinding()]
            param (
                [Parameter(
                    Position = 0,
                    ValuefromPipelineByPropertyName = $true,
                    Mandatory = $true
                )]
                [System.String[]]$VisibleAppHidingRule,

                [Parameter(
                    Position = 1,
                    ValuefromPipelineByPropertyName = $true,
                    Mandatory = $true

                )]
                [System.String[]]$HidableAppHidingRule
            )

            $visibleRulesOnly = $VisibleAppHidingRule | Where-Object { $_.Startswith('HKLM\SOFTWARE\') -eq $true }
            $hidingRulesOnly = $HidableAppHidingRule | Where-Object { $_.Startswith('HKLM\SOFTWARE\') -eq $true }

            $rules = $visibleRulesOnly + $hidingRulesOnly

            $dupes = $rules | Group-Object | Where-Object {$_.Count -gt 1 } | Select-Object -ExpandProperty Name

            Write-Output $dupes
        }
        #Write-FslRedirectLine
        function Write-FslRedirectLine {

            [cmdletbinding()]
            Param (
                [String[]]$DuplicateLine,
                [System.String]$OutRedirectFile,
                [System.String]$AppName
            )

            if (Test-Path $OutRedirectFile) {
                Write-Error 'File Already Exists'
            }
            else {

                Add-Content $OutRedirectFile '1' -Encoding Unicode
                Add-Content $OutRedirectFile '##' -Encoding Unicode

                foreach ($line in $DuplicateLine) {

                    $regPath = $line.split()[0]
                    $destination = $regPath.replace('HKLM\SOFTWARE\', "HKLM\SOFTWARE\FSlogix\Redirect\$AppName\")
                    Add-Content $OutRedirectFile "$regPath`t`t$destination`t`t0x00000121`t" -Encoding Unicode
                }
            }
        }
        #Remove-RepeatComment
        function Remove-RepeatComment {
            [cmdletbinding()]
            Param (
                [String[]]$Line
            )

            $lastLineFirstLetterHash = $false
            foreach ($item in $Line) {
                $firstLetterHash = $item.StartsWith('#')
                if (-not ($lastLineFirstLetterHash -and $firstLetterHash)) {
                    Write-Output $item
                }

                $lastLineFirstLetterHash = $firstLetterHash
            }

        }
        #Remove-FslHidingRule
        function Remove-FslHidingRule {
            [cmdletbinding()]
            Param (
                [String[]]$DuplicateLine,
                [String[]]$HidableAppHidingRule,
                [String]$OutHidingFile
            )

            $dupes = $DuplicateLine
            $outHidingRules = $HidableAppHidingRule

            foreach ($line in $dupes) {
                $escapeLine = [regex]::Escape("$line")
                $outHidingRules = $outHidingRules | Where-Object {$_ -notmatch $escapeLine }
            }

            $linesWithNoRepeatComments = Remove-RepeatComment -Line $outHidingRules

            if (Test-path $OutHidingFile) {
                Write-Error 'File already exists'
            }
            else {
                Set-Content -Path $OutHidingFile -Value $linesWithNoRepeatComments -Encoding Unicode
            }
        }

        #endregion

    }

    PROCESS {
        $dupelist = Find-DuplicateLine -VisibleAppHidingRule $VisibleAppHidingRule -HidableAppHidingRule $HidableAppHidingRule
        Write-FslRedirectLine -DuplicateLine $dupelist -OutRedirectFile $OutRedirectFile -AppName $AppName
        Remove-FslHidingRule -DuplicateLine $dupelist -HidableAppHidingRule $HidableAppHidingRule -OutHidingFile $OutHidingFile
    }
    END {
    }
}
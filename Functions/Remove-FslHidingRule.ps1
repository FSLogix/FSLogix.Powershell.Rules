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

    $linesWithNoRepeatComments = Remove-RepeatComments -Line $outHidingRules

    if (Test-path $OutHidingFile) {
        Write-Error 'File already exists'
    }
    else {
        Set-Content -Path $OutHidingFile -Value $linesWithNoRepeatComments -Encoding Unicode
    }
}
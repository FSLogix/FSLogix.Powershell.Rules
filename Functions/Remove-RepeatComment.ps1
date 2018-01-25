function Remove-RepeatComment {
        [cmdletbinding()]
    Param (
        [String[]]$Line
    )

    $lastLineFirstLetterHash = $false
    foreach ($item in $Line){
        $firstLetterHash = $item.StartsWith('#')
        if (-not ($lastLineFirstLetterHash -and $firstLetterHash)){
            Write-Output $item
        }

        $lastLineFirstLetterHash = $firstLetterHash
    }

}
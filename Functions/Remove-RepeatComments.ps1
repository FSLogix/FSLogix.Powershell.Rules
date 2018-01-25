function Remove-RepeatComments {
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
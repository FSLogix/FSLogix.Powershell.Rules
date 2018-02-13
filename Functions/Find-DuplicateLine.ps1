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

    #Eliminate non relevant lines
    $visibleRulesOnly = $VisibleAppHidingRule | Where-Object { $_.Startswith('##') -eq $false -and $_ -ne '1' }
    $hidingRulesOnly = $HidableAppHidingRule | Where-Object { $_.Startswith('##') -eq $false -and $_ -ne '1' }

    $rules = $visibleRulesOnly + $hidingRulesOnly

    $dupes = $rules | Group-Object | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Name

    Write-Output $dupes
}
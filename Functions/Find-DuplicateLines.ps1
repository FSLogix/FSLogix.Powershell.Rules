function Find-DuplicateLines {
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
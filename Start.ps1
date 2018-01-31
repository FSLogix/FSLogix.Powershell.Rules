. .\Functions\Add-FslNewRuleFile.ps1
. .\Functions\Find-DuplicateLine.ps1
. .\Functions\Remove-FslHidingRule.ps1
. .\Functions\Remove-RepeatComment.ps1
. .\Functions\Write-FslRedirectLine.ps1

$path = 'Z:\FSLogix\RuleSets'
$AddFSLNewRuleFileParams = @{
    VisibleAppHidingRule = Get-Content -Path ( Join-Path $path 'Office2016.fxr' )
    HidableAppHidingRule = Get-Content -Path (Join-Path $path 'Project2016.fxr' )
    OutHidingFile        = Join-Path $path 'Project2016_H.fxr'
    OutRedirectFile      = Join-Path $path 'Project2016_R.fxr'
    AppName              = 'Project2016'
}

Add-FslNewRuleFile @AddFSLNewRuleFileParams

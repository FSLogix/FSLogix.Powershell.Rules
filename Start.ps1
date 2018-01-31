. .\Functions\Add-FslNewRuleFile.ps1
. .\Functions\Find-DuplicateLine.ps1
. .\Functions\Remove-FslHidingRule.ps1
. .\Functions\Remove-RepeatComment.ps1
. .\Functions\Write-FslRedirectLine.ps1

$path = 'C:\Users\Jim\FieldScripts\Create-Rules-Files\TestFiles'
$AddFSLNewRuleFileParams = @{
    VisibleAppHidingRule = Get-Content -Path ( Join-Path $path 'AppRule_Office2013.fxr' )
    HidableAppHidingRule = Get-Content -Path (Join-Path $path 'AppRule_Visio2013Pro.fxr' )
    OutHidingFile        = Join-Path $path 'AppRule_Visio2013Pro_H.fxr'
    OutRedirectFile      = Join-Path $path '\AppRule_Visio2013Pro_R.fxr'
    AppName              = 'Visio2013Pro'
}

Add-FslNewRuleFile @AddFSLNewRuleFileParams

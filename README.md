# Create-Rules-Files

Function to create hiding and redirect files for FSLogix App Masking when hiding part of a suite or part of an app.  e.g Project and Office

Example:

$path = 'C:\Users\Jim\FieldScripts\Create-Rules-Files\TestFiles'

$AddFSLNewRuleFileParams = @{

    VisibleAppHidingRule = Get-Content -Path ( Join-Path $path 'AppRuleOffice2013.fxr' )

    HidableAppHidingRule = Get-Content -Path (Join-Path $path 'AppRuleVisio2013Pro.fxr' )

    OutHidingFile        = Join-Path $path 'AppRuleVisio2013Pro_H.fxr'

    OutRedirectFile      = Join-Path $path 'AppRuleVisio2013Pro_R.fxr'

    AppName              = 'Visio2013Pro'

}


Add-FslNewRuleFile @AddFSLNewRuleFileParams

Example:

gci -file | Write-FslFileHidingLine -OutRedirectFile c:\jimm\hiding.fxr

gci -Path c:\madeup\fictional -Recurse -File | Write-FslFileHidingLine -OutRedirectFile c:\jimm\hiding.fxr


Example:

gci -Path c:\madeup\fictional -Recurse -File -Filter *.exe | Add-FslProcessAssignment -$OutAssignmentFile c:\jimm\assignment.fxa
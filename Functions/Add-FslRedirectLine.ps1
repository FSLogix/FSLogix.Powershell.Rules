function Add-FslRedirectLine {

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
        
        foreach ($line in $DuplicateLine) {

            $regPath = $line.split()[0]
            $destination = $regPath.replace('HKLM\SOFTWARE\', "HKLM\SOFTWARE\FSlogix\Redirect\$AppName\")
            Add-Content $OutRedirectFile '##Created by Script' -Encoding Unicode
            Add-Content $OutRedirectFile "$regPath`t`t$destination`t`t0x00000121`t" -Encoding Unicode
        }
    }
}
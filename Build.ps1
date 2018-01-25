function Add-FslRelease {
    [cmdletbinding()]
    param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $false
        )]
        [System.String]$FunctionsFolder = '.\Functions',

        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $false
        )]
        [System.String]$ReleaseFolder = '.\Release',
        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$ControlScript
    )

    $funcs = Get-ChildItem $FunctionsFolder -File | Where-Object {$_.Name -ne $ControlScript}

    $ctrlScript = Get-Content -Path (Join-Path $FunctionsFolder $ControlScript)

    foreach ($funcName in $funcs) {

        $pattern = "#$($funcName.BaseName)"
        $actualFunc = Get-Content (Join-Path $FunctionsFolder $funcName)


        $ctrlScript = $ctrlScript | Foreach-Object {
            $_
            if ($_ -match $pattern ) {
                $actualFunc
            }
        }

        Set-Content (Join-Path )
    }

}

Add-FslRelease -ControlScript 'Add-FslNewRuleFile.ps1'
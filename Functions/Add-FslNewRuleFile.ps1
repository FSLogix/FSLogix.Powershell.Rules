function Add-FslNewRuleFile {
    [CmdletBinding()]
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
        [System.String[]]$HidableAppHidingRule,

        [Parameter(
            Position = 2,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$OutHidingFile,

        [Parameter(
            Position = 3,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$OutRedirectFile,

        [Parameter(
            Position = 4,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$AppName
    )


    BEGIN {
        Set-StrictMode -Version Latest
    }

    PROCESS {
        $dupelist = Find-DuplicateLines -VisibleAppHidingRule $VisibleAppHidingRule -HidableAppHidingRule $HidableAppHidingRule
        Write-FslRedirectLine -DuplicateLine $dupelist -OutRedirectFile $OutRedirectFile -AppName $AppName
        Remove-FslHidingRule -DuplicateLine $dupelist -HidableAppHidingRule $HidableAppHidingRule -OutHidingFile $OutHidingFile
    }
    END {
    }
}
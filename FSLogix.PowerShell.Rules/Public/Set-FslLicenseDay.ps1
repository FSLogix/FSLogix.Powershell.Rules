function Set-FslLicenseDay {

    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [Alias('AssignmentFilePath')]
        [System.String]$Path

        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [int]$LicenseDay
        
    )

    BEGIN {
        Set-StrictMode -Version Latest
        $version = 1
    } # Begin
    PROCESS {

        if (-not (Test-Path $Path)) {
            Write-Error "$Path not found."
            break
        }

        If ((Get-ChildItem -Path $Path).Extension -ne '.fxa') {
            Write-Warning 'Assignment file extension should be .fxa'
        }

        $content = Get-Content -Path $Path | Select-Object -Skip 1

        Set-Content -Path $Path -Value "$version`t$LicenseDay"

        Add-Content -Path $Path -Value $content

    } #Process
    END {} #End
}  #function Set-FslLicenseDay
function Get-FslLicenseDay {
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
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {
        if (-not (Test-Path $Path)) {
            Write-Error "$Path not found."
            break
        }

        If ((Get-ChildItem -Path $Path).Extension -ne '.fxa') {
            Write-Warning 'Assignment file extension should be .fxa'
        }

        $firstLine = Get-Content -Path $Path -TotalCount 1

        try {
            [int]$licenseDay = $firstLine.Split("`t")[-1]
        }
        catch {
            Write-Error "Bad data on first line of $Path"
            break
        }

        $output = [pscustomobject]@{
            LicenseDay = $licenseDay
        }

        Write-Output $output

    } #Process
    END { } #End
}  #function Get-FslLicenseDay
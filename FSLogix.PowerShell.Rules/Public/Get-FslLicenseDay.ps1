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
            exit
        }

        $firstLine = Get-Content -Path $Path -TotalCount 1

        [int]$licenseDay = $firstLine.Split("`t")[-1]

        if ($null -eq $licenseDay){
            Write-Error "Bad data on first line of $path"
        }

        $output = [pscustomobject]@{
            LicenseDay = $licenseDay
        }

        Write-Output $output

    } #Process
    END {} #End
}  #function Get-FslLicenseDay

Get-FslLicenseDay -Path 'D:\PoSHCode\GitHub\FSLogix.Powershell.Rules\FSLogix.PowerShell.Rules\tests\QA\TestFiles\AllAssign\Assign.fxa'
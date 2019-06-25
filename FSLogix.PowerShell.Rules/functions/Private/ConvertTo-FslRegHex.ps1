function ConvertTo-FslRegHex {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String]$RegData,

        [Parameter(
            Mandatory = $true,
            ValuefromPipelineByPropertyName = $true
        )]
        [ValidateSet('String', 'DWORD', 'QWORD', 'Multi-String', 'ExpandableString')]
        [string]$RegValueType
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {

        $hexOnly = @()

        if ($RegValuetype -eq 'DWORD') {
            try {
                [int]$RegData = $RegData
            }
            catch {
                Write-Error "Unable to convert $Regdata to a 32 bit Integer (DWORD)"
            }
        }

        if ($RegValuetype -eq 'QWORD') {
            try {
                [int64]$RegData = $RegData
            }
            catch {
                Write-Error "Unable to convert $Regdata to a 64 bit Integer (QWORD)"
            }
        }

        $hexUniCode = $RegData | Format-Hex -Encoding UniCode
        $hexToLine = $hexUniCode.ToString() -split [environment]::NewLine

        $hexToLine | ForEach-Object {
            if ($_ -match "^\d{8,20}\s{3}((?:[0-9|A-F]{2}\s){1,16})\s+.*$") {
                $hexOnly += $Matches[1]
                $Matches.clear()
            }
        }
        $joined = [string]::join('', $hexOnly)
        $joinedNoSpaces = $joined.Replace(' ', '')

        switch ($RegValueType) {
            String { $output = '01' + $joinedNoSpaces + '0000'; break }
            DWORD {
                while ($joinedNoSpaces.length -lt 8) {
                    $joinedNoSpaces = $joinedNoSpaces + '0'
                }
                $output = '04' + $joinedNoSpaces
                break
            }
            Default { }
        }

        Write-Output $output

    } #Process
    END { } #End
}  #function ConvertTo-FslRegHex

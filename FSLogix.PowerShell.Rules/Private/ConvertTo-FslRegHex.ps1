function ConvertTo-FslRegHex {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String]$RegStringData
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {

        $hexOnly = @()
        $hexUniCode = $RegStringData | format-hex -Encoding UniCode
        $hexToLine = $hexUniCode.ToString() -split [environment]::NewLine

        $hexToLine | ForEach-Object {
            if ($_ -match "^\d{8,20}\s{3}((?:\d[0-9|A-F]\s){1,16})\s+(?:\w\.)+\s{0,9}$") {
                $hexOnly += $Matches[1]
            }
            $Matches.clear()
        }
        $joined = [string]::join('', $hexOnly)
        $joinedNoSpaces = $joined.Replace(' ', '')
        $output = '01' + $joinedNoSpaces + '0000'

        Write-Output $output
        
    } #Process
    END {} #End
}  #function ConvertTo-FslRegHex


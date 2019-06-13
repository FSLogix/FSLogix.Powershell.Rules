function ConvertFrom-FslRegHex {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String]$HexString,

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
        $ascii = $null
        switch ($RegValueType) {
            String { $hexLong = $HexString.substring(2, $HexString.length - 6) ; break }
            DWORD { $hexLong = $HexString.substring(2, 8) ; break }
            Default {}
        }
        $hex = $hexLong -Split '(.{4})'
        $hex | ForEach-Object {
            if ($_ -ne '') {
                $byte = $_.substring(0, 2)
                $ascii += [CHAR]([CONVERT]::toint16($byte, 16)) 
            }
        }
        Write-Output $ascii
    } #Process
    END {} #End
}  #function ConvertFrom-FslRegHex
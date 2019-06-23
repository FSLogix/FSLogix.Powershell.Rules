function ConvertFrom-FslRegHex {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String]$HexString
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {

        #TODO Combine with next switch
        switch ($HexString.Substring(0,2)) {
            01 { $RegValueType = String ; break }
            04 { $RegValueType = DWORD ; break}
            Default {
                Write-Error "Could not determine the type of registry value form the Hex Code $($HexString.Substring(2))"
                exit
            }
        }

        $ascii = $null
        switch ($RegValueType) {
            String { $hexLong = $HexString.substring(2, $HexString.length - 6) ; break }
            DWORD { $hexLong = $HexString.substring(2, 8) ; break }
            Default { }
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
    END { } #End
}  #function ConvertFrom-FslRegHex
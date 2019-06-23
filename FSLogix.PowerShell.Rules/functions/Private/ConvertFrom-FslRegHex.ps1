function ConvertFrom-FslRegHex {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 1,
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
        $ascii = $null

        switch ($HexString.Substring(0, 2)) {
            01 {
                $regValueType = 'String'
                $hexLong = $HexString.substring(2, $HexString.length - 6)
                break
            }
            04 {
                $regValueType = 'DWORD'
                $hexLong = $HexString.substring(2, 8)
                break
            }
            Default {
                Write-Error "Could not determine the type of registry value form the Hex Code $($HexString.Substring(0,2))"
                exit
            }
        }

        $hex = $hexLong -Split '(.{4})'
        $hex | ForEach-Object {
            if ($_ -ne '') {
                $byte = $_.substring(0, 2)
                $ascii += [CHAR]([CONVERT]::toint16($byte, 16))
            }
        }
        $output = [PSCustomObject]@{
            Data         = $ascii
            RegValueType = $regValueType
        }
        Write-Output $output
    } #Process
    END { } #End
}  #function ConvertFrom-FslRegHex
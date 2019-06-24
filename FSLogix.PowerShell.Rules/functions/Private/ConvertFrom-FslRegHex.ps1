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
        $outputData = $null

        switch ($HexString.Substring(0, 2)) {
            '01' {
                $regValueType = 'String'
                $hexLong = $HexString.substring(2, $HexString.length - 6)
                $hex = $hexLong -Split '(.{4})'
                $hex | ForEach-Object {
                    if ($_ -ne '') {
                        $byte = $_.substring(0, 2)
                        $outputData += [CHAR]([CONVERT]::toint16($byte, 16))
                    }
                }
                break
            }
            '04' {
                $regValueType = 'DWORD'
                #Grab relevant characters
                $hexLong = $HexString.substring(2, 8)
                #Split into bytes
                $hex = $hexLong -Split '(.{2})'
                #Need to make current little endian into big endian in oder for [convert] to work
                [System.Array]::Reverse($hex)
                $bEndian = $hex -join ''
                $int32 = [convert]::ToInt32($bEndian, 16)
                #everything is a string in output - maybe change
                $outputData = $int32.ToString()
                break
            }
            Default {
                Write-Error "Could not determine the type of registry value form the Hex Code $($HexString.Substring(0,2))"
                exit
            }
        }

        $output = [PSCustomObject]@{
            Data         = $outputData
            RegValueType = $regValueType
        }
        Write-Output $output
    } #Process
    END { } #End
}  #function ConvertFrom-FslRegHex
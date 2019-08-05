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
                        $outputData += [char]([convert]::toint16($byte, 16))
                    }
                }
                break
            }
            '04' {
                $regValueType = 'DWORD'
                #Grab relevant characters
                $hexLong = $HexString.substring(2, 8)
                #Split into bytes
                $hex = $hexLong -Split '(..)'
                #Need to make current little endian into big endian in order for [convert] to work
                [System.Array]::Reverse($hex)
                $bEndian = $hex -join ''
                $int32 = [convert]::ToUInt32($bEndian, 16)
                #everything is a string in output - maybe change
                $outputData = $int32.ToString()
                break
            }
            '0B' {
                $regValueType = 'QWORD'
                #Grab relevant characters
                $hexLong = $HexString.substring(2, 16)
                #Split into bytes
                $hex = $hexLong -Split '(..)'
                #Need to make current little endian into big endian in order for [convert] to work
                [System.Array]::Reverse($hex)
                $bEndian = $hex -join ''
                $int64 = [convert]::ToUInt64($bEndian, 16)
                #everything is a string in output - maybe change
                $outputData = $int64.ToString()
                break
            }
            '07' {
                $regValueType = 'Multi-String'
                $outputData = @()
                
                $splitStrings = $HexString.substring(2, $HexString.length - 10) -split '000000'

                foreach ($string in $splitStrings) {
                    $outputLine = @()
                    $string = $string + '00'
                    $hex = $string -Split '(.{4})'
                    $hex | ForEach-Object {
                        if ($_ -ne '') {
                            $byte = $_.substring(0, 2)
                            $outputLine += [char]([convert]::toint16($byte, 16))
                        }
                        
                    }
                    $outputData += $outputLine -Join ''
                }
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
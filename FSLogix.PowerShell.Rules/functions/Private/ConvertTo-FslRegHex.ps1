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
        $hex = ''

        switch ($RegValueType) {
            String { 
                $regDataChars = $RegData.ToCharArray()
                foreach ($character in $regDataChars) { 
                    $hex = $hex + [System.String]::Format("{0:X4}", [System.Convert]::ToUInt16($character))
                }
                $hexInRegFormat = ($hex -replace "^00", '01') + '000000'
            }
            DWORD {
                try {
                    $hex = ConvertTo-FslHexDword -RegData $RegData -ErrorAction Stop
                }
                catch {
                    Write-Error "$Error[0]"
                    exit
                }

                $hexInRegFormat = '04' + $hex.ToString()

            }
            QWORD {

                try {
                    [Uint64]$RegData = $RegData[0]
                }
                catch {
                    Write-Error "Unable to convert $Regdata to a QWORD Unsigned 64 bit Integer"
                    exit
                }

                try {
                    $hex = [String]::Format("{0:x}", $regdata)

                    while ($hex.length -lt 16) {
                        $hex = '0' + $hex
                    }

                    $hexArray = $hex -split "(..)"
                    [array]::Reverse($hexArray)              

                    $hexInRegFormat = '0B' + [system.String]::Join("", $hexArray)  
                }
                catch {
                    Write-Error "Unable to convert $Regdata to Hex"
                    exit
                }
            }
            Multi-String {
                $combinedHex = @()
                foreach ($string in $RegData) {
                    $regDataChars = $string.ToCharArray()
                    foreach ($character in $regDataChars) { 
                        $hex = $hex + [System.String]::Format("{0:X4}", [System.Convert]::ToUInt16($character))
                    }
                    $hexWithZeros = $hex.Substring(2) + '000000'
                    $hex = $null
                    $combinedHex = $combinedHex + $hexWithZeros
                    
                }
                $combinedHex = $combinedHex -join ''
                $hexInRegFormat = '07' + $combinedHex + '000000'
            }
            ExpandableString {}
            Default { }
        }

        Write-Output $hexInRegFormat

    } #Process
    END { } #End
}  #function ConvertTo-FslRegHex
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
        [ValidateSet('String', 'DWORD', 'QWORD', 'ExpandableString')]
        [string]$RegValueType
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {
        $hex = ''

        switch ($RegValueType) {
            String { 
                try {
                    $hex = ConvertTo-FslHexString -RegData $RegData -ErrorAction Stop
                }
                catch {
                    Write-Error "$Error[0]"
                    exit
                }

                $hexInRegFormat = '01' + $hex.ToString() + '0000'
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
                    $hex = ConvertTo-FslHexQword -RegData $RegData -ErrorAction Stop
                }
                catch {
                    Write-Error "Unable to convert $Regdata to a QWORD Unsigned 64 bit Integer"
                    exit
                }

                $hexInRegFormat = '0B' + $hex.ToString()
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
            ExpandableString { }
            Default { }
        }

        Write-Output $hexInRegFormat

    } #Process
    END { } #End
}  #function ConvertTo-FslRegHex
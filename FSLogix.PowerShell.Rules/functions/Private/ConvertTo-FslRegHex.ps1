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
                    #[Uint32]$RegData = $RegData
                }
                catch {
                    Write-Error "Unable to convert $Regdata to a DWORD Unsigned 32 bit Integer $([uint32]::MinValue) - $([uint32]::MaxValue)"
                    exit
                }

                try {
                    $hex = [convert]::ToString($RegData, 16)

                    while ($hex.length -lt 8) {
                        $hex = '0' + $hex
                    }

                    $hexArray = $hex -split "(..)"
                    [array]::Reverse($hexArray)              

                    $hexInRegFormat = '04' + -join $hexArray
                }
                catch {
                    Write-Error "Unable to convert $Regdata to Hex"
                    exit
                }
            }
            QWORD {
                try {
                    [UInt64]$RegData = $RegData
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
            Multi-String {}
            ExpandableString {}
            Default { }
        }

        Write-Output $hexInRegFormat

    } #Process
    END { } #End
}  #function ConvertTo-FslRegHex

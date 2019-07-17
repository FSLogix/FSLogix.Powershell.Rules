function ConvertTo-FslHexMultiString {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [String[]]$RegData
    )
    
    begin {
    }
    
    process {
        $combinedHex = $null
        foreach ($string in $RegData) {
            $regDataChars = $string.ToCharArray()
            foreach ($character in $regDataChars) { 
                $hex = $hex + [System.String]::Format("{0:X4}", [System.Convert]::ToUInt16($character))
            }
            $hexWithZeros = $hex.Substring(2) + '000000'
            $hex = $null
            $combinedHex = $combinedHex + $hexWithZeros
            
        }
        $output = $combinedHex -join ''
        Write-Output $output
    }
    
    end {
    }
}
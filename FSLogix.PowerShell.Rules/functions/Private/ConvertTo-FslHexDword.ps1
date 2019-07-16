function ConvertTo-FslHexDword {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [uInt32]$RegData
    )
    
    begin {
    }
    
    process {
        try {
            $hex = [convert]::ToString($RegData, 16)

            while ($hex.length -lt 8) {
                $hex = '0' + $hex
            }

            $hexArray = $hex -split "(..)"
            [array]::Reverse($hexArray)

            $output = $hexArray -join ''
        }
        catch {
            Write-Error "Unable to convert $Regdata from uInt64 to Hex"
            exit
        }

        Write-Output $output
    }
    
    end {
    }
}
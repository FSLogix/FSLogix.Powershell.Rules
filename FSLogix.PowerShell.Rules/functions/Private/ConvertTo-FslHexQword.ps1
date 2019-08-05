function ConvertTo-FslHexQword {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [uInt64]$RegData
    )
    
    begin {
    }
    
    process {
        $hex = $null
        try {
            $hex = [String]::Format("{0:x}", $regdata)

            while ($hex.length -lt 16) {
                $hex = '0' + $hex
            }

            $hexArray = $hex -split "(..)"
            [array]::Reverse($hexArray)              

        }
        catch {
            Write-Error "Unable to convert $Regdata to Hex"
            exit
        }
        $output = $hexArray -join ''
        
        Write-Output $output
    }
    
    end {
    }
}
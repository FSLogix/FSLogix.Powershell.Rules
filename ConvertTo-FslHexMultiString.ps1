function ConvertTo-FslHexMultiString {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String[]]$RegData
    )
    
    begin {
    }
    
    process {
        $stringHex = @()
        foreach ($string in $RegData) {
            $hex = ConvertTo-FslHexString -RegData $string
            $stringHex += $hex + '0000'
        }
        $output = '07' + $stringHex + '0000'
        Write-Output $output
    }
    
    end {
    }
}
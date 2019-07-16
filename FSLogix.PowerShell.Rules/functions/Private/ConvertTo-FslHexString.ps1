function ConvertTo-FslHexString {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String]$RegData
    )
    
    begin {
    }
    
    process {
        $regDataChars = $RegData.ToCharArray()

        foreach ($character in $regDataChars) { 
            $hex = $hex + [System.String]::Format("{0:X4}", [System.Convert]::ToUInt16($character))
        }

        $hexJoined = $hex -join ''
        $output = $hexJoined.SubString(2) + '00'

        Write-Output $output
    }
    
    end {
    }
}
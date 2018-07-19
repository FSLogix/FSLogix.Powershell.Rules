function Reset-PSBoundParameters {
    #From https://github.com/PowerShell/PowerShell/issues/5202
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [Bootstraps.Metaprogramming.ParameterHashtable]
        $CommandLineParameters,

        [Parameter(Mandatory, Position = 1)]
        [System.Collections.Generic.IDictionary[System.String, System.Object]]
        $ThisPSBoundParameters
    )
    process {
        $output = [hashtable]$ThisPSBoundParameters
        $keys = if ( $ThisPSBoundParameters.Count ) {
            $ThisPSBoundParameters.get_Keys().Clone()
        }
        $keys |
            Where-Object { $CommandLineParameters.Hashtable.get_Keys() -notcontains $_ } |
            ForEach-Object { [void]$ThisPSBoundParameters.Remove($_) }
        Write-Output $output
    }
}
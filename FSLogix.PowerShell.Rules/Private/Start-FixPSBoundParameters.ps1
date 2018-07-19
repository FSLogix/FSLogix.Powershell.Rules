function Start-FixPSBoundParameters {
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Collections.Generic.IDictionary[System.String, System.Object]]
        $ThisPSBoundParameters
    )
    process {
        [Bootstraps.Metaprogramming.ParameterHashtable][hashtable]$ThisPSBoundParameters
    }
}
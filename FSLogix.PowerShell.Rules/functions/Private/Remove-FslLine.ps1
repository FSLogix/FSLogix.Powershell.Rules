function Remove-FslLine {
    [CmdletBinding()]

    Param (
        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$Path,
        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$Category,

        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [System.String]$Name,

        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [ValidateSet('Assignment', 'Rule')]
        [System.String]$Type
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {

        switch ($Type) {
            Assignment {
                Get-FslAssignment $Path | Where-Object {$_.$Category -ne $Name} | Set-FslAssignment $Path
            }
            Rule {
                Get-FslRule $Path | Where-Object {$_.$Category -ne $Name} | Set-FslRule $Path
            }
            Default {}
        }

    } #Process
    END {} #End
}  #function Remove-FslLine
function Remove-FslRule {
    [CmdletBinding(SupportsShouldProcess = $true)]

    Param (
        [Parameter(
            Position = 1,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [alias('RuleFilePath')]
        [System.String]$Path,

        [Parameter(
            Position = 2,
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [alias('FullName')]
        [System.String]$Name
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {

        If (-not (Test-Path -Path $Path)) {
            Write-Error "$Path Not found"
            break
        }

        if ($Path -notlike "*.fxr") {
            Write-Warning 'Rule files should have an fxr filename extension'
        }

        $rules = Get-FslRule -Path $Path

        if ( $rules.FullName -notcontains $Name ) {
            Write-Error "Could not find rule with name $Name in file $Path"
            break
        }
        else {
            $lines = $rules | Where-Object {$_.FullName -eq $Name}
            foreach ($line in $lines) {
                If ($PSCmdlet.ShouldProcess("Rule $Name")) {
                    Remove-FslLine -Path $Path -Category FullName -Name $Name -Type Rule
                }
            }
        }
    } #Process
    END {} #End
}  #function Remove-FslRule
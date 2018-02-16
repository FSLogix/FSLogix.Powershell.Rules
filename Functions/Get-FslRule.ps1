function Get-FslRule {
    [CmdletBinding()]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String]$Path
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {
        if (-not (Test-Path $Path)) {
            Write-Error "$Path not found."
            exit
        }
        #Grab txt file contaents apart from first line
        $lines = Get-Content -Path $Path | Select-Object -Skip 1 

        foreach ($line in $lines) {
            switch ($true) {
                #Grab comment if this line is one.
                $line.StartsWith('##') { 
                    $comment = $line.TrimStart('#')
                    break 
                }
                #If line matches tab separated data with 5 columns. 
                { $line -match "([^\t]*\t){5}" } { 
                    #Create a powershell object from the columns
                    $lineObj = $line | ConvertFrom-String -Delimiter `t -PropertyNames SrcParent, Src, DestParent, Dest, FlagDec, Binary
                    #ConvertFrom-String converts the hex value in flag to decimal, need to convert back to a hex string. Add in the comment and output it.
                    $rulePlusComment = $lineObj | Select-Object -Property SrcParent, Src, DestParent, Dest, @{n='Flag';e={'0x' + "{0:X8}" -f $lineObj.FlagDec}}, Binary, @{n='Comment';e={$comment}}
                    Write-Output $rulePlusComment 
                    break
                }
                Default { 
                    Write-Error "Rule file element: $line Does not match a comment or a rule format" 
                }
            }
        }
    } #Process
    END {} #End
}  #function Get-FslRule

Get-FslRule -Path "E:\Users\Jim\FieldScripts\Create-Rules-Files\TestFiles\AppRule_Office2013.fxr"
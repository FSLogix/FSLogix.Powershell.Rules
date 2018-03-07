function Get-FslAssignment {
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
                    $lineObj = $line | ConvertFrom-String -Delimiter `t -PropertyNames FlagsDec, DistinguishedName, NotUsed, FriendlyName, AssignmentTime, Zero
                    #ConvertFrom-String converts the hex value in flag to decimal, need to convert back to a hex string. Add in the comment and output it.
                    $AssignmentPlusComment = $lineObj | Select-Object -Property DistinguishedName, Notused, FriendlyName, AssignmentTime, Zero, @{n = 'Flags'; e = {'0x' + "{0:X8}" -f $lineObj.FlagsDec}}, Binary, @{n = 'Comment'; e = {$comment}}

                    $poshFlags = $AssignmentPlusComment.Flags | ConvertFrom-FslAssignmentCode

                    <#$output = [PSCustomObject]@{
                        FullName         = Join-Path $AssignmentPlusComment.DistinguishedName # $AssignmentPlusComment.FriendlyName
                        HidingType       = if ($poshFlags.Hiding) {
                            switch ( $true ) {
                                $poshFlags.Font {'Font'; break}
                                $poshFlags.Printer {'Printer'; break}
                                $poshFlags.FolderOrKey {'FolderOrKey'; break}
                                $poshFlags.FileOrValue {'FileOrValue'; break}
                            }
                        }
                        else { $null }
                        RedirectDestPath = if ($poshFlags.Redirect) { $destPath } else {$null}
                        RedirectType     = if ($poshFlags.Redirect) {
                            switch ( $true ) {
                                $poshFlags.FolderOrKey {'FolderOrKey'; break}
                                $poshFlags.FileOrValue {'FileOrValue'; break}
                            }
                        }
                        else { $null }
                        CopyObject       = if ($poshFlags.CopyObject) { $poshFlags.CopyObject } else {$null}
                        DiskFile         = if ($poshFlags.VolumeAutoMount) { $destPath } else {$null}
                        Binary           = $AssignmentPlusComment.Binary
                        Comment          = $AssignmentPlusComment.Comment
                        Flags            = $AssignmentPlusComment.Flags#>
                    #}

                    $output | ForEach-Object {
                        $Properties = $_.PSObject.Properties
                        @( $Properties | Where-Object { -not $_.Value } ) | ForEach-Object { $Properties.Remove($_.Name) }
                        Write-Output $_
                    }

                    break
                }
                Default {
                    Write-Error "Assignment file element: $line Does not match a comment or a Assignment format"
                }
            }
        }
    } #Process
    END {} #End
}  #function Get-FslAssignment

#. D:\PoSHCode\GitHub\Create-Rules-Files\Functions\Private\ConvertFrom-FslRuleCode.ps1

#Get-FslRule -Path 'C:\Users\jsmoy\OneDrive\Documents\FSLogix Rule Sets\redirect.fxr'
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
                #If line matches tab separated data with 5 columns.
                { $line -match "([^\t]*\t){5}" } {
                    #Create a powershell object from the columns
                    $lineObj = $line | ConvertFrom-String -Delimiter `t -PropertyNames FlagsDec, IdString, DistinguishedName, FriendlyName, AssignedTime, UnAssignedTime
                    #ConvertFrom-String converts the hex value in flag to decimal, need to convert back to a hex string. Add in the comment and output it.
                    $assignment = $lineObj | Select-Object -Property  IdString, DistinguishedName, FriendlyName, AssignmentTime, UnAssignedTime, @{n = 'Flags'; e = {'0x' + "{0:X8}" -f $lineObj.FlagsDec}}

                    $poshFlags = $assignment.Flags | ConvertFrom-FslAssignmentCode

                    $output = [PSCustomObject]@{
                        
                        RuleSetApplies = switch ( $true ) {
                            $poshFlags.Remove { $false }
                            $poshFlags.Apply { $true }
                        }
                        UserName = if ( $poshFlags.User ) { $assignment.IdString } else { $null }
                        GroupName = if ( $poshFlags.Group ) { $assignment.IdString } else { $null }
                        ProcessName = if ( $poshFlags.Process ) { $assignment.IdString } else { $null }
                        IncludeChildProcess =  $poshFlags.ApplyToProcessChildren
                        ProcessId = $poshFlags.ProcessId
                        IPAddress = if ( $poshFlags.Network ) { $assignment.IdString } else { $null }
                        ComputerName = if ( $poshFlags.Computer ) { $assignment.IdString } else { $null }
                        ADDistinguishedName = if ( $poshFlags.ADDistinguishedName ) { $assignment.DistinguishedName } else { $null }
                        EnvironmentVariable = if ( $poshFlags.EnvironmentVariable ) { $assignment.IdString } else { $null }
                        
                }


                    <#    FullName         = Join-Path $AssignmentPlusComment.DistinguishedName # $AssignmentPlusComment.FriendlyName
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
                        $_ #| Format-List
                    }

                    break
                }
                Default {
                    Write-Error "Assignment file element: $line Does not match a comment or a Assignment format"
                }
            } #switch
        } #foreach
    } #Process
    END {} #End
}  #function Get-FslAssignment

#. D:\PoSHCode\GitHub\Create-Rules-Files\Functions\Private\ConvertFrom-FslRuleCode.ps1

Get-FslAssignment -Path 'C:\poshcode\github\FSLogix.Powershell.Rules\TestFiles\Assign.fxa'
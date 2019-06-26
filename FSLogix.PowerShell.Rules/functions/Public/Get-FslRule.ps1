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
        #Grab txt file contents apart from first line
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
                    #Create a powershell object from the columns only works on full PowerShell, not core
                    $lineObj = $line | ConvertFrom-String -Delimiter `t -PropertyNames SrcParent, Src, DestParent, Dest, FlagsDec, Binary
                    #ConvertFrom-String converts the hex value in flag to decimal, need to convert back to a hex string. Add in the comment and output it.
                    $rulePlusComment = $lineObj | Select-Object -Property SrcParent, Src, DestParent, Dest, @{n = 'Flags'; e = { '0x' + "{0:X8}" -f $lineObj.FlagsDec } }, Binary, @{n = 'Comment'; e = { $comment } }

                    $poshFlags = $rulePlusComment.Flags | ConvertFrom-FslRuleCode
                    if ($rulePlusComment.DestParent) {
                        $destPath = try {
                            (Join-Path $rulePlusComment.DestParent $rulePlusComment.Dest -ErrorAction Stop).TrimEnd('\')
                        }
                        catch {
                            [system.io.fileinfo]($rulePlusComment.DestParent.TrimEnd('\', '/') + '\' + $rulePlusComment.Dest.TrimStart('\', '/').TrimEnd('\'))
                        }
                    }
                    $fullnameJoin = try {
                        (Join-Path $rulePlusComment.SrcParent $rulePlusComment.Src -ErrorAction Stop).TrimEnd('\')
                    }
                    catch {
                        [system.io.fileinfo]($rulePlusComment.SrcParent.TrimEnd('\', '/') + '\' + $rulePlusComment.Src.TrimStart('\', '/')).TrimEnd('\')
                    }

                    if ($rulePlusComment.Binary) {
                        $SpecificData = ConvertFrom-FslRegHex -HexString $rulePlusComment.Binary
                    }
                    else{
                        $SpecificData = [PSCustomObject]@{
                            Data = $null
                            RegValueType = $null
                        }
                    }

                    $output = [PSCustomObject]@{
                        PSTypeName       = "FSLogix.Rule"
                        FullName         = $fullnameJoin

                        HidingType       = if ($poshFlags.Hiding -or $poshFlags.HideFont -or $poshFlags.Printer) {
                            switch ( $true ) {
                                $poshFlags.HideFont { 'Font'; break }
                                $poshFlags.Printer { 'Printer'; break }
                                $poshFlags.FolderOrKey { 'FolderOrKey'; break }
                                $poshFlags.FileOrValue { 'FileOrValue'; break }
                            }
                        }
                        else { $null }
                        RedirectDestPath = if ($poshFlags.Redirect) { $destPath } else { $null }
                        RedirectType     = if ($poshFlags.Redirect) {
                            switch ( $true ) {
                                $poshFlags.FolderOrKey { 'FolderOrKey'; break }
                                $poshFlags.FileOrValue { 'FileOrValue'; break }
                            }
                        }
                        else { $null }

                        CopyObject       = if ($poshFlags.CopyObject) { $poshFlags.CopyObject } else { $null }
                        DiskFile         = if ($poshFlags.VolumeAutoMount) { $destPath } else { $null }
                        #Binary           = $rulePlusComment.Binary
                        Data             = $SpecificData.Data
                        RegValueType     = $SpecificData.RegValueType
                        Comment          = $rulePlusComment.Comment
                        #Flags            = $rulePlusComment.Flags
                    }

                    Write-Output $output
                    break

                }
                Default {
                    Write-Error "Rule file element: $line Does not match a comment or a rule format"
                }
            }
        }
    } #Process
    END { } #End
}  #function Get-FslRule
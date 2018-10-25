function Remove-FslAssignment {
    [CmdletBinding(SupportsShouldProcess = $true)]

    Param (
        [Parameter(
            Position = 0,
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [alias('AssignmentFilePath')]
        [System.String]$Path,

        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [alias('FullName')]
        [System.String]$Name,


        [Parameter(
            ValuefromPipelineByPropertyName = $true
        )]
        [Switch]$Force
    )

    BEGIN {
        Set-StrictMode -Version Latest
    } # Begin
    PROCESS {

        If (-not (Test-Path -Path $Path)) {
            Write-Error "$Path Not found"
            break
        }

        if ($Path -notlike "*.fxa") {
            Write-Warning 'Assignment files should have an fxa filename extension'
        }

        $licenceDay = (Get-FslLicenseDay -Path $Path).LicenseDay

        $assignments = Get-FslAssignment -Path $Path



        switch ($true) {
            {$assignments.UserName -contains $Name} {
                $lines = $assignments | Where-Object {$_.Username -eq $Name}
                foreach ($line in $lines) {
                    If ($PSCmdlet.ShouldProcess("UserName Assignment $Name")) {
                        Remove-FslLine -Path $Path -Category Username -Name $Name -Type Assignment
                    }
                }
            }
            {$assignments.GroupName -contains $Name} { $category = 'GroupName' }
            {$assignments.ProcessName -contains $Name} { $category = 'ProcessName' }
            {$assignments.IPAddress -contains $Name} { $category = 'IPAddress' }
            {$assignments.ComputerName -contains $Name} { $category = 'ComputerName' }
            {$assignments.OU -contains $Name} { $category = 'OU' }
            {$assignments.EnvironmentVariable -contains $Name} {
                $lines = $assignments | Where-Object {$_.EnvironmentVariable -eq $Name}

                foreach ($line in $lines) {

                    if (-not $line.AssignedTime -eq 0) {
                        $unassignMinimum = $line.AssignedTime.AddDays($licenceDay)
                    }
                    $now = Get-Date

                    switch ($true) {

                        {$line.AssignedTime -eq 0} {
                            If ($PSCmdlet.ShouldProcess("Environment Variable Assignment $Name")) {
                                Remove-FslLine -Path $Path -Category EnvironmentVariable -Name $Name -Type Assignment
                            }
                            break
                        }
                        {$licenceDay -ne 0 -and
                            $line.AssignedTime -ne 0 -and
                            $unassignMinimum -gt $now -and
                            $Force -eq $false
                        } {
                            #If check for license time has failed and force isn't present, throw an error.
                            $daysLeft = ($unassignMinimum - $line.AssignedTime).Days
                            Write-Error "License agreement violation detected $daysLeft days left out of $licenceDay days before license can be reassigned."
                            break
                        }

                        Default {
                            If ($PSCmdlet.ShouldProcess("Environment Variable Assignment $Name")) {
                                Remove-FslLine -Path $Path -Category EnvironmentVariable -Name $Name -Type Assignment
                                $line.UnAssignedTime = Get-Date
                                $line | Add-FslAssignment -Path $Path
                            }
                        }
                    }
                }
            }

            Default {}
        }

        $licenceDay | Set-FslLicenseDay -Path $Path

    } #Process
    END {} #End
}  #function Remove-FslAssignment
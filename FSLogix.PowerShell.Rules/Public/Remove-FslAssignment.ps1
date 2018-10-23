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

        $licenceDay = Get-FslLicenseDay -Path $Path

        $assignments = Get-FslAssignment -Path $Path



        switch ($true) {
            {$assignments.UserName -contains $Name} { 
                $lines = $assignments | Where-Object {$_.Username -eq $Name}
                foreach ($line in $lines) {
                    If ($PSCmdlet.ShouldProcess("UserName Assignment $Name")) {
                        Remove-FslIndividualLine -Path $Path -Category Username -Name $Name -Type Assignment
                    }
                }
            }
            {$assignments.GroupName -contains $Name} { $category = 'GroupName' }
            {$assignments.ProcessName -contains $Name} { $category = 'ProcessName' }
            {$assignments.IPAddress -contains $Name} { $category = 'IPAddress' }
            {$assignments.ComputerName -contains $Name} { $category = 'ComputerName' }
            {$assignments.OU -contains $Name} { $category = 'OU' }
            {$assignments.EnvironmentVariable -contains $Name} { $category = 'EnvironmentVariable' }

            Default {}
        }

        If ($PSCmdlet.ShouldProcess("$category Assignment $name")) {
            Write-Output 'Should'
        }


        $licenceDay | Set-FslLicenseDay -Path $Path 

        
    } #Process
    END {} #End
}  #function Remove-FslAssignment
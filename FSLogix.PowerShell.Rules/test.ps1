#. FSLogix.PowerShell.Rules\functions\Private\ConvertTo-FslRegHex.ps1
#. FSLogix.PowerShell.Rules\functions\Private\ConvertFrom-FslRegHex.ps1
#ConvertTo-FslRegHex -Regdata 0 -RegValueType QWORD
# 1844674407370955161
#ConvertFrom-FslRegHex -HexString 11ffffffffffffffff

Import-module C:\PoShCode\GitHub\FSLogix.Powershell.Rules\FSLogix.PowerShell.Rules\FSLogix.PowerShell.Rules.psd1 -Force

Add-FslRule -Path c:\jimm\SpecifyValue.fxr -FullName HKLM\Software\FSLogix\Testing\PoShDWORD -RegValueType DWORD -ValueData 42

Add-FslRule -Path c:\jimm\SpecifyValue.fxr -FullName HKLM\Software\FSLogix\Testing\PoShString -RegValueType String -ValueData Jim

Add-FslRule -Path c:\jimm\SpecifyValue.fxr -FullName HKLM\Software\FSLogix\Testing\PoShQWORD -RegValueType QWORD -ValueData 18446744073709551615

$Multi = 'line one', 'line two', 'line three'

Add-FslRule -Path c:\jimm\SpecifyValue.fxr -FullName HKLM\Software\FSLogix\Testing\PoShMulti -RegValueType Multi-String -ValueData $Multi

Add-FslRule -Path c:\jimm\SpecifyValue.fxr -FullName HKLM\Software\FSLogix\Testing\PoShExpand -RegValueType ExpandableString -ValueData '%PATH%'

#Copy-Item c:\jimm\SpecifyValue.fxr 'C:\Program Files\FSLogix\Apps\Rules\SpecifyValue.fxr' -Force

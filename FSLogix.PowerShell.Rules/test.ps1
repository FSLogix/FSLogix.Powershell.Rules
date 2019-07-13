. FSLogix.PowerShell.Rules\functions\Private\ConvertTo-FslRegHex.ps1
$a = "JimString";
$b = $a.ToCharArray();
Foreach ($element in $b) { 
    $c = $c + [System.String]::Format("{0:X4}", [System.Convert]::ToUInt16($element))
}
$c
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$funcType = Split-Path $here -Leaf
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$here = $here | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
. "$here\$funcType\$sut"

Describe $sut.TrimEnd('.ps1') {
    It 'Hides Folder or Key 0x00000221' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00000221'

        $result.FolderOrKey     | Should -BeTrue
        $result.FileOrValue     | Should -BeFalse
        $result.CopyObject      | Should -BeFalse
        $result.Redirect        | Should -BeFalse
        $result.Hiding          | Should -BeTrue
        $result.Printer         | Should -BeFalse
        $result.SpecificData    | Should -BeFalse
        $result.Java            | Should -BeFalse
        $result.VolumeAutoMount | Should -BeFalse
        $result.Font            | Should -BeFalse
    }

    It 'Hides Value or File 0x00000222' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00000222'

        $result.FolderOrKey     | Should -BeFalse
        $result.FileOrValue     | Should -BeTrue
        $result.CopyObject      | Should -BeFalse
        $result.Redirect        | Should -BeFalse
        $result.Hiding          | Should -BeTrue
        $result.Printer         | Should -BeFalse
        $result.SpecificData    | Should -BeFalse
        $result.Java            | Should -BeFalse
        $result.VolumeAutoMount | Should -BeFalse
        $result.Font            | Should -BeFalse
    }

    It 'Hides Font 0x00004020' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00004020'

        $result.FolderOrKey     | Should -BeFalse
        $result.FileOrValue     | Should -BeFalse
        $result.CopyObject      | Should -BeFalse
        $result.Redirect        | Should -BeFalse
        $result.Hiding          | Should -BeFalse
        $result.Printer         | Should -BeFalse
        $result.SpecificData    | Should -BeFalse
        $result.Java            | Should -BeFalse
        $result.VolumeAutoMount | Should -BeFalse
        $result.Font            | Should -BeTrue
    }

    It 'Hides Printer 0x00000420' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00000420'

        $result.FolderOrKey     | Should -BeFalse
        $result.FileOrValue     | Should -BeFalse
        $result.CopyObject      | Should -BeFalse
        $result.Redirect        | Should -BeFalse
        $result.Hiding          | Should -BeFalse
        $result.Printer         | Should -BeTrue
        $result.SpecificData    | Should -BeFalse
        $result.Java            | Should -BeFalse
        $result.VolumeAutoMount | Should -BeFalse
        $result.Font            | Should -BeFalse
    }

    It 'Is Java 0x00001000' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00001000'

        $result.FolderOrKey     | Should -BeFalse
        $result.FileOrValue     | Should -BeFalse
        $result.CopyObject      | Should -BeFalse
        $result.Redirect        | Should -BeFalse
        $result.Hiding          | Should -BeFalse
        $result.Printer         | Should -BeFalse
        $result.SpecificData    | Should -BeFalse
        $result.Java            | Should -BeTrue
        $result.VolumeAutoMount | Should -BeFalse
        $result.Font            | Should -BeFalse
    }

    It 'Redirects Value or File 0x00000122' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00000122'

        $result.FolderOrKey     | Should -BeFalse
        $result.FileOrValue     | Should -BeTrue
        $result.CopyObject      | Should -BeFalse
        $result.Redirect        | Should -BeTrue
        $result.Hiding          | Should -BeFalse
        $result.Printer         | Should -BeFalse
        $result.SpecificData    | Should -BeFalse
        $result.Java            | Should -BeFalse
        $result.VolumeAutoMount | Should -BeFalse
        $result.Font            | Should -BeFalse
    }

    It 'Redirects Folder or Key 0x00000121' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00000121'

        $result.FolderOrKey     | Should -BeTrue
        $result.FileOrValue     | Should -BeFalse
        $result.CopyObject      | Should -BeFalse
        $result.Redirect        | Should -BeTrue
        $result.Hiding          | Should -BeFalse
        $result.Printer         | Should -BeFalse
        $result.SpecificData    | Should -BeFalse
        $result.Java            | Should -BeFalse
        $result.VolumeAutoMount | Should -BeFalse
        $result.Font            | Should -BeFalse
    }

    It 'Redirects Value or File with copy 0x00000132' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00000132'

        $result.FolderOrKey     | Should -BeFalse
        $result.FileOrValue     | Should -BeTrue
        $result.CopyObject      | Should -BeTrue
        $result.Redirect        | Should -BeTrue
        $result.Hiding          | Should -BeFalse
        $result.Printer         | Should -BeFalse
        $result.SpecificData    | Should -BeFalse
        $result.Java            | Should -BeFalse
        $result.VolumeAutoMount | Should -BeFalse
        $result.Font            | Should -BeFalse
    }

    It 'Redirects Folder or Key with copy 0x00000131' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00000131'

        $result.FolderOrKey     | Should -BeTrue
        $result.FileOrValue     | Should -BeFalse
        $result.CopyObject      | Should -BeTrue
        $result.Redirect        | Should -BeTrue
        $result.Hiding          | Should -BeFalse
        $result.Printer         | Should -BeFalse
        $result.SpecificData    | Should -BeFalse
        $result.Java            | Should -BeFalse
        $result.VolumeAutoMount | Should -BeFalse
        $result.Font            | Should -BeFalse
    }

    It 'Redirects Folder or Key with copy 0x00000131' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00000131'

        $result.FolderOrKey     | Should -BeTrue
        $result.FileOrValue     | Should -BeFalse
        $result.CopyObject      | Should -BeTrue
        $result.Redirect        | Should -BeTrue
        $result.Hiding          | Should -BeFalse
        $result.Printer         | Should -BeFalse
        $result.SpecificData    | Should -BeFalse
        $result.Java            | Should -BeFalse
        $result.VolumeAutoMount | Should -BeFalse
        $result.Font            | Should -BeFalse
    }

    It 'Specifies Value or File 0x00000822' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00000822'

        $result.FolderOrKey     | Should -BeFalse
        $result.FileOrValue     | Should -BeTrue
        $result.CopyObject      | Should -BeFalse
        $result.Redirect        | Should -BeFalse
        $result.Hiding          | Should -BeFalse
        $result.Printer         | Should -BeFalse
        $result.SpecificData    | Should -BeTrue
        $result.Java            | Should -BeFalse
        $result.VolumeAutoMount | Should -BeFalse
        $result.Font            | Should -BeFalse
    }

    It 'Specifies Value or File 0x00002020' {
        $result = ConvertFrom-FslRuleCode -RuleCode '0x00002020'

        $result.FolderOrKey     | Should -BeFalse
        $result.FileOrValue     | Should -BeFalse
        $result.CopyObject      | Should -BeFalse
        $result.Redirect        | Should -BeFalse
        $result.Hiding          | Should -BeFalse
        $result.Printer         | Should -BeFalse
        $result.SpecificData    | Should -BeFalse
        $result.Java            | Should -BeFalse
        $result.VolumeAutoMount | Should -BeTrue
        $result.Font            | Should -BeFalse
    }
}
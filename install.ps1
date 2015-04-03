
function install
{
    param(
        [Parameter(Position = 0)]
        [string]$targetDirectory,
        [switch]$silent
    )

    $ErrorActionPreference = "Stop"

    if (!$targetDirectory)
    {
        $targetDirectory = Read-Host -Prompt "Specify the directory for the installation [default: '$($env:ProgramFiles)\powerfull-shell']"
        if (!$targetDirectory) { $targetDirectory = "$($env:ProgramFiles)\powerfull-shell" }
    }
    
    write "Installing powerfull-shell to directory '$targetDirectory' ..."
    if (!(Test-Path $targetDirectory)) { mkdir $targetDirectory  }

    $archiveFile = "$($env:TEMP)\powerfull-shell.zip"
    $tempDirectory = "$($env:TEMP)\powerfull-shell-master"

    Invoke-WebRequest "https://github.com/raeffs/powerfull-shell/archive/master.zip" -OutFile $archiveFile
    $shell = New-Object -ComObject Shell.Application
    foreach ($item in $shell.Namespace($archiveFile).items())
    {
        $shell.Namespace($env:TEMP).copyhere($item, 20)
    }

    gci $tempDirectory | % { move $_.FullName $targetDirectory -Force }

    rm $tempDirectory -Recurse -Force
    rm $archiveFile

    if (!$silent.IsPresent)
    {
        $caption = "Create shortcut"
        $message = "Do you want to create a desktop shortcut?"
        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Creates a shortcut to powerfull-shell on your desktop."
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Does not create a shortcut."
        $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
        $createShortcut = $Host.UI.PromptForChoice($caption, $message, $options, 0)
        if ($createShortcut -eq 0)
        {
            $wscript = New-Object -ComObject WScript.Shell
            $shortcut = $wscript.CreateShortcut("$env:USERPROFILE\Desktop\PowerfullShell.lnk")
            $shortcut.TargetPath = "$targetDirectory\Console.exe"
            $shortcut.WorkingDirectory = "$targetDirectory"
            $shortcut.IconLocation = "$targetDirectory\powershell.ico,0"
            $shortcut.Save()
        }
    }

    write "Successfully installed powerfull-shell!"
}

install @args
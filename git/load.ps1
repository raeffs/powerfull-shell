
function GitIsInstalled
{
    CommandExists git
}

function LoadGit
{
    Set-Alias git "$installDir\git\bin\cmd\git.exe" -Scope Global
    Set-Alias ssh-agent "$installDir\git\bin\bin\ssh-agent.exe" -Scope Global
    Set-Alias ssh-add "$installDir\git\bin\bin\ssh-add.exe" -Scope Global
}

function InstallGit
{
    $install = PromptForConfirmation `
        "Git Installation" `
        "It seems that Git is not installed on this system. Do you want to install Git now?" `
        "Install the latest version of Git." `
        "Do not install Git. Git will not be available in powerfull shell."

    if (!$install) { return }

    $gitVersion = "Git-1.9.5-preview20150319"
    $downloadUrl = "https://github.com/msysgit/msysgit/releases/download/$gitVersion/Portable$gitVersion.7z"

    write "Downloading Git ..."
    Invoke-WebRequest $downloadUrl -OutFile "$env:TEMP\git.7z"
    write "Extracting Git ..."
    7za x -y "-o$installDir\git\bin" "$env:TEMP\git.7z" > $null

    LoadGit
    write "Git successfully installed."
}

if (GitIsInstalled) 
{
    Write-Verbose "Git is already installed."
    return 
}

if (Test-Path "$installDir\git\bin\cmd\git.exe")
{
    LoadGit
    return
}

InstallGit

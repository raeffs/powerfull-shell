
function LoadGitExtrasWindows
{
    $env:Path += ";$installDir\git-extras-windows\bin"
}

function InstallGitExtrasWindows
{
    $install = PromptForConfirmation `
        "Git Extras for Windows Installation" `
        "Do you want to install Git Extras for Windows now?" `
        "Install the latest version of Git Extras for Windows." `
        "Do not install Git Extras for Windows."

    if (!$install) { return }

    $downloadUrl = "https://raw.githubusercontent.com/raeffs/git-extras-windows/master/install.ps1"

    write "Downloading Git Extras for Windows ..."
    Invoke-WebRequest $downloadUrl -OutFile "$env:TEMP\git-extras-windows.ps1"
    write "Installing Git Extras for Windows ..."
    . "$env:TEMP\git-extras-windows.ps1" "$installDir\git-extras-windows\bin" -SkipPath > $null

    LoadGitExtrasWindows
    write "Git Extras for Windows successfully installed."
}

if (!(GitIsInstalled))
{
    Write-Verbose "Git is not installed. Git Extras for Windows cannot be used."
    return
}

if (Test-Path "$installDir\git-extras-windows\bin\git-extras.exe")
{
    LoadGitExtrasWindows
    return
}

InstallGitExtrasWindows


function PoshGitIsInstalled
{
    Test-Path "$installDir\posh-git\bin\posh-git.psm1"
}

function LoadPoshGit
{
    Import-Module "$installDir\posh-git\bin\posh-git"

    function global:prompt {
        $realLASTEXITCODE = $LASTEXITCODE

        # Reset color, which can be messed up by Enable-GitColors
        $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

        Write-Host("[$env:COMPUTERNAME] ") -NoNewline -ForegroundColor Magenta
        Write-Host($pwd.ProviderPath) -NoNewline

        Write-VcsStatus

        $global:LASTEXITCODE = $realLASTEXITCODE
        return "> "
    }

    Enable-GitColors
}

function InstallPoshGit
{
    # $install = PromptForConfirmation `
    #     "Posh Git Installation" `
    #     "Do you want to install Posh Git now?" `
    #     "Install the latest version of Posh Git." `
    #     "Do not install Posh Git."

    # if (!$install) { return }

    write "Downloading Posh Git ..."
    Invoke-WebRequest "https://github.com/dahlbyk/posh-git/archive/master.zip" -OutFile "$env:TEMP\posh-git.zip"
    write "Extracting Posh Git ..."
    7za x -y "-o$env:TEMP" "$env:TEMP\posh-git.zip" > $null
    mkdir "$installDir\posh-git\bin"
    gci "$env:TEMP\posh-git-master" | % { move $_.FullName "$installDir\posh-git\bin" }

    LoadPoshGit
    write "Posh Git successfully installed."
}

if (!(GitIsInstalled))
{
    Write-Verbose "Git is not installed. Posh Git cannot be used."
    return
}

if (PoshGitIsInstalled)
{
    LoadPoshGit
    return
}

InstallPoshGit

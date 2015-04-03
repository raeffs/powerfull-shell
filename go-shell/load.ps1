
function LoadGoShell
{
    Import-Module "$installDir\go-shell\bin\go"
    $Global:GoDataDirectory = "$HOME\.go\"
}

function InstallGoShell
{
    $install = PromptForConfirmation `
        "Go Shell Installation" `
        "Do you want to install Go Shell now?" `
        "Install the latest version of Go Shell." `
        "Do not install Go Shell. Go Shell will not be available in powerfull shell."

    if (!$install) { return }

    $downloadUrl = "https://github.com/cameronharp/Go-Shell/archive/master.zip"

    write "Downloading Go Shell ..."
    Invoke-WebRequest $downloadUrl -OutFile "$env:TEMP\go-shell.zip"
    write "Extracting Go Shell ..."
    7za x -y "-o$env:TEMP" "$env:TEMP\go-shell.zip" > $null
    mkdir "$installDir\go-shell\bin"
    gci "$env:TEMP\Go-Shell-master" | % { move $_.FullName "$installDir\go-shell\bin" }

    LoadGoShell
    write "Go Shell successfully installed."
}

if (Test-Path "$installDir\go-shell\bin\go.psm1")
{
    LoadGoShell
    return
}

InstallGoShell

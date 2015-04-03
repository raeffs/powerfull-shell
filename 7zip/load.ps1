
function Load7zip
{
    Set-Alias 7za "$installDir\7zip\7za.exe" -Scope Global
}

if (CommandExists 7za) 
{
    Write-Verbose "7zip is already installed."
    return 
}

Load7zip

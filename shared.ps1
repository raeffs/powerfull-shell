
function CommandExists
{
    param(
        $command
    )
    $currentPreference = $ErrorActionPreference
    $ErrorActionPreference = "Stop"
    try
    {
        if (Get-Command $command) { return $true }
    }
    catch
    {
        return $false
    }
    finally
    {
        $ErrorActionPreference = $currentPreference
    }
}

function PromptForConfirmation
{
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$caption,
        [Parameter(Position = 1, Mandatory = $true)]
        [string]$message,
        [Parameter(Position = 2)]
        [string]$yesHelp,
        [Parameter(Position = 3)]
        [string]$noHelp
    )

    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", $yesHelp
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", $noHelp
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    $result = $Host.UI.PromptForChoice($caption, $message, $options, 0)
    return $result -eq 0
}

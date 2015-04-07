
$Global:ColoredLs = @{}
$Global:ColoredLs.ColorMap = @{
    "Blue" = "DarkBlue";
    "DarkBlue" = "Magenta";
    "Green" = "DarkGreen";
    "DarkGreen" = "DarkCyan";
    "Red" = "DarkRed";
    "Orange" = "Red";
    "Yellow" = "DarkYellow";
    "Pink" = "DarkMagenta";
    "Gray" = "Blue";
    "White" = "White";
}
$Global:ColoredLs.GreenExtensions = @('exe')
$Global:ColoredLs.DarkGreenExtensions = @('txt','cfg','conf','config','ini','csv','log','cs','css','xml','html','cshtml','bat','cmd','ps1','psm1','vbs','reg','md','m3u')
$Global:ColoredLs.YellowExtensions = @('zip','tar','gz','rar','jar','war','iso','img','7z','bin','cab')
$Global:ColoredLs.PinkExtensions = @('png','jpg','jpeg','gif','bmp','ico')
$Global:ColoredLs.OrangeExtensions = @('mp3','wmv','m4a','flac')
$Global:ColoredLs.RedExtensions = @('avi','mkv','mp4','mov','m4v')

function WriteLs
{
    param(
        [string]$color, 
        $file
    )

    if ($Global:ColoredLs.ColorMap.ContainsKey($color))
    {
        $color = $Global:ColoredLs.ColorMap[$color]
    }

    Write-Host ("{0,-7} {1,25} {2,10} {3}" -f $file.mode, ([String]::Format("{0,10}  {1,8}", $file.LastWriteTime.ToString("d"), $file.LastWriteTime.ToString("t"))), $file.length, $file.name) -ForegroundColor $color 
}

function BuildRegex
{
    param(
        $extensionArray
    )

    return New-Object System.Text.RegularExpressions.Regex([String]::Format('\.({0})$', [String]::Join('|', $extensionArray)), [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
}

New-CommandWrapper Out-Default `
    -Process {

        if (($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
        {
            $greenFiles = BuildRegex $Global:ColoredLs.GreenExtensions
            $darkGreenFiles = BuildRegex $Global:ColoredLs.DarkGreenExtensions
            $yellowFiles = BuildRegex $Global:ColoredLs.YellowExtensions
            $pinkFiles = BuildRegex $Global:ColoredLs.PinkExtensions
            $orangeFiles = BuildRegex $Global:ColoredLs.OrangeExtensions
            $redFiles = BuildRegex $Global:ColoredLs.RedExtensions
            $grayFiles = New-Object System.Text.RegularExpressions.Regex('^\.', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

            if ($_ -is [System.IO.DirectoryInfo])
            {
                if(-not ($notfirst))
                {
                    Write-Host
                    Write-Host "    Directory: " -noNewLine
                    Write-Host " $(pwd)`n" -foregroundcolor "DarkBlue"           
                    Write-Host "Mode                LastWriteTime     Length Name"
                    Write-Host "----                -------------     ------ ----"
                    $notfirst=$true
                }
                WriteLs "Blue" $_
            }
            else
            {
                if ($greenFiles.IsMatch($_.Name))
                {
                    WriteLs "Green" $_
                }
                elseif ($darkGreenFiles.IsMatch($_.Name))
                {
                    WriteLs "DarkGreen" $_
                }
                elseif ($yellowFiles.IsMatch($_.Name))
                {
                    WriteLs "Yellow" $_
                }
                elseif ($pinkFiles.IsMatch($_.Name))
                {
                    WriteLs "Pink" $_
                }
                elseif ($orangeFiles.IsMatch($_.Name))
                {
                    WriteLs "Orange" $_
                }
                elseif ($redFiles.IsMatch($_.Name))
                {
                    WriteLs "Red" $_
                }
                elseif ($grayFiles.IsMatch($_.Name))
                {
                    WriteLs "Gray" $_
                }
                else
                {
                    WriteLs "White" $_
                }
            }
            $_ = $null
        }
    }

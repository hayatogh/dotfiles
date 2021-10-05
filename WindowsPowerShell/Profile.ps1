Set-PSReadLineOption -EditMode "Vi" -HistoryNoDuplicates -BellStyle "None" -ViModeIndicator "Prompt"

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Set-PSReadlineKeyHandler -Key Ctrl+h -Function BackwardDeleteChar
Set-PSReadlineKeyHandler -Key Ctrl+w -Function BackwardDeleteWord
Set-PSReadlineKeyHandler -Key Ctrl+k -Function ForwardDeleteLine

Set-PSReadlineKeyHandler -Key Ctrl+b -Function BackwardChar
Set-PSReadlineKeyHandler -Key Ctrl+f -Function ForwardChar
Set-PSReadlineKeyHandler -Key Alt+b -Function BackwardWord
Set-PSReadlineKeyHandler -Key Alt+f -Function ForwardWord
Set-PSReadlineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key Ctrl+e -Function EndOfLine

Set-PSReadlineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key Ctrl+n -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Ctrl+[ -Function ViCommandMode

function ee {
  exit
}

function Color-Console {
  $hosttime = (Get-ChildItem -Path $PSHOME\PowerShell.exe).CreationTime
  $hostversion="$($Host.Version.Major)`.$($Host.Version.Minor)"
  $Host.UI.RawUI.WindowTitle = "PowerShell $hostversion ($hosttime)"
}
Color-Console

function prompt {
  $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' } else { '' }) +
    "$env:USERNAME@$env:COMPUTERNAME " + $(Get-Location) +
    $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
}

function choco_install {
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

  choco feature enable -n allowGlobalConfirmation
  $pin = "aquasnap", "discord.install", "drawio", "slack", "steam", "thunderbird", "zotero"
  $ins = "7zip.install", "autohotkey.install", "fd", "flac", "fontforge", "foobar2000",
    "inkscape", "lavfilters", "lockhunter", "mpc-be", "pdfxchangeeditor", "ripgrep",
    "strawberryperl", "sumatrapdf.install", "vcxsrv", "vim", "winscp.install", "wsltty"
  choco install $ins $pin
  $pin | % { choco pin add --name $_ }
  choco_remove_links
}
function choco_remove_links {
  $desktop = [Environment]::GetFolderPath("Desktop")
  $lnk = "Discord.lnk", "Inkscape.lnk", "Kindle.lnk", "MPC-BE x64.lnk", "SumatraPDF.lnk"
  $lnk | % {
    $path = Join-Path $desktop $_
    if (Test-Path $path) {
      Remove-Item $path
    }
  }
  Get-Item "$env:PUBLIC\Desktop\*.lnk" | Remove-Item
}
function choco_upgrade {
  choco upgrade all
  choco_remove_links
}

Set-PSReadLineOption -EditMode "Vi" -HistoryNoDuplicates -BellStyle "None" -ViModeIndicator "Prompt"

Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

Set-PSReadlineKeyHandler -Chord Ctrl+h -Function BackwardDeleteChar
Set-PSReadlineKeyHandler -Chord Ctrl+w -Function BackwardDeleteWord
Set-PSReadlineKeyHandler -Chord Ctrl+k -Function ForwardDeleteLine

Set-PSReadlineKeyHandler -Chord Ctrl+b -Function BackwardChar
Set-PSReadlineKeyHandler -Chord Ctrl+f -Function ForwardChar
Set-PSReadlineKeyHandler -Chord Alt+b -Function BackwardWord
Set-PSReadlineKeyHandler -Chord Alt+f -Function ForwardWord
Set-PSReadlineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Chord Ctrl+e -Function EndOfLine

Set-PSReadlineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Chord Ctrl+n -Function HistorySearchForward
Set-PSReadlineKeyHandler -Chord Ctrl+[ -Function ViCommandMode

Set-PSReadlineKeyHandler -Chord Alt+w -ScriptBlock { param($key, $arg) _regex_rubout('[^ ]* *$') }
Set-PSReadlineKeyHandler -Chord Alt+/ -ScriptBlock { param($key, $arg) _regex_rubout('[^/\\ ]*(/|\\)? *$') }

function _regex_rubout() {
  param($re)
  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $cursor, ($line.SubString(0, $cursor) -replace $re, ''))
}

function ee {
  exit
}
function _type {
  param ([switch]$a)
  $params = @{}
  if ($a) {
    $params = @{ All = $true }
  }
  Get-Command @params @Args | % {
    Write-Output $_
    if ($_.GetType().Name -eq "FunctionInfo") {
      Write-Output "" ("function " + $_.Name + " {" + $_.ScriptBlock + "}")
    }
  }
}
set-alias type _type
function ls-all {
    Get-ChildItem -Force
}
Set-Alias ll Get-ChildItem
Set-Alias la ls-all
Set-Alias al ls-all

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
  $pin = "aquasnap", "discord.install", "drawio", "slack", "steam-client", "zotero"
  $ins = "7zip.install", "autohotkey.install", "fd", "flac", "fontforge", "foobar2000",
    "inkscape", "lavfilters", "lockhunter", "mpc-be", "pdfxchangeeditor", "ripgrep",
    "strawberryperl", "sumatrapdf.install", "vim", "winscp.install", "wsltty"
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

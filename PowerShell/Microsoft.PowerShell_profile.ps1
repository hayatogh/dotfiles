Set-PSReadLineOption -EditMode "Vi" -HistoryNoDuplicates -BellStyle "None" -ViModeIndicator "Prompt"

Set-PSReadlineKeyHandler Tab MenuComplete

Set-PSReadlineKeyHandler Ctrl+h BackwardDeleteChar
Set-PSReadlineKeyHandler Ctrl+w BackwardDeleteWord
Set-PSReadlineKeyHandler Ctrl+k ForwardDeleteLine

Set-PSReadlineKeyHandler Ctrl+b BackwardChar
Set-PSReadlineKeyHandler Ctrl+f ForwardChar
Set-PSReadlineKeyHandler Alt+b BackwardWord
Set-PSReadlineKeyHandler Alt+f ForwardWord
Set-PSReadlineKeyHandler Ctrl+a BeginningOfLine
Set-PSReadlineKeyHandler Ctrl+e EndOfLine

Set-PSReadlineKeyHandler Ctrl+p HistorySearchBackward
Set-PSReadlineKeyHandler Ctrl+n HistorySearchForward
Set-PSReadlineKeyHandler Ctrl+[ ViCommandMode

Set-PSReadlineKeyHandler Alt+w { _regex_rubout('[^ ]* *$') }
Set-PSReadlineKeyHandler Alt+/ { _regex_rubout('[^/\\ ]*(/|\\)? *$') }

function _regex_rubout {
  param($re)
  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $cursor, ($line.SubString(0, $cursor) -replace $re, ''))
}

function ee {
  exit
}
function which {
  param ([switch]$a)
  $params = @{}
  if ($a) {
    $params = @{ All = $true }
  }
  Get-Command @params @args | % {
    $_ | Format-Table Name, CommandType, Definition -AutoSize -Wrap | Out-String -Width 512
  }
}
Set-Alias ll Get-ChildItem
function _ls_all {
  Get-ChildItem -Force @args
}
Set-Alias la _ls_all
Set-Alias al _ls_all
function open {
  param ([string[]]$a)
  if ($a.Length -eq 0) {
    Invoke-Item .
  } else {
    Invoke-Item $a
  }
}
Set-Alias e open
function sudo {
  Start-Process -Verb RunAs @args
}
function su {
  Start-Process -Verb RunAs wt
}

function prompt {
  $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' } else { '' }) +
    "$env:USERNAME@$env:COMPUTERNAME " + $(Get-Location) +
    $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
}

function winget_install {
  winget install --no-upgrade Discord.Discord NurgoSoftware.AquaSnap Valve.Steam
  winget install 7zip.7zip AutoHotkey.AutoHotkey MPC-BE.MPC-BE Mintty.WSLtty PeterPawlowski.foobar2000 PeterPawlowski.foobar2000.EncoderPack TrackerSoftware.PDF-XChangeEditor vim.vim
  # BurntSushi.ripgrep.MSVC JGraph.Draw sharkdp.fd
  winget_remove_links
}
function winget_remove_links {
  $desktop = [Environment]::GetFolderPath("Desktop")
  $lnk = "Discord.lnk", "Inkscape.lnk", "Kindle.lnk", "MPC-BE x64.lnk", "SumatraPDF.lnk", "WSL Terminal.lnk"
  $lnk | % {
    $path = Join-Path $desktop $_
    if (Test-Path $path) {
      Remove-Item $path
    }
  }
  Get-Item "$env:PUBLIC\Desktop\*.lnk" | Remove-Item
}

Invoke-Command -ScriptBlock {
  $local_profile = Join-Path $([System.Environment]::GetFolderPath("MyDocuments")) "\PowerShell\local_profile.psm1"
  if (Test-Path $local_profile) {
    Import-Module $local_profile
  }
}

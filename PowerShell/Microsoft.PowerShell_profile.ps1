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

Set-Alias upgrade winget_install
function winget_install {
  winget install --no-upgrade Discord.Discord MSYS2.MSYS2 Microsoft.PowerToys NurgoSoftware.AquaSnap Valve.Steam
  winget install 7zip.7zip Debian.Debian ImageLine.FLStudio MPC-BE.MPC-BE MichaelTippach.ASIO4ALL Microsoft.MouseandKeyboardCenter Microsoft.WindowsTerminal PeterPawlowski.foobar2000 SteelSeries.GG Streamlink.Streamlink TrackerSoftware.PDF-XChangeEditor Zoom.Zoom
  # BurntSushi.ripgrep.MSVC Git.Git JGraph.Draw sharkdp.fd

  _winget_install_ahk
  _winget_install_vim
  _winget_install_if_outdated "Mintty.WSLtty" '[0-9]\.[0-9]\.[0-9]' "$env:LOCALAPPDATA\wsltty\winget_version"
  _winget_install_if_outdated "PeterPawlowski.foobar2000.EncoderPack" '20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]' "$env:ProgramFiles\foobar2000\encoders\winget_version"

  _winget_remove_links

  winget install Microsoft.PowerShell
}

function _winget_install_ahk {
  $scripts = (Get-Process -Name AutoHotkey64).CommandLine
  winget install AutoHotkey.AutoHotkey
  if ($?) {
    $scripts | % {
      pwsh -NoProfile -Command "& $_"
    }
  }
}

function _winget_install_vim {
  $vim = "$env:ProgramFiles\Vim"
  winget install vim.vim
  if ($?) {
    $runtime_dir = (Get-ChildItem $vim -Attributes Directory | Select-Object -Last 1).Name
    Get-ChildItem $vim -Attributes Directory | Select-Object -SkipLast 1 | % {
      Remove-Item -Recurse $_
      New-Item -ItemType SymbolicLink -Name $_.Name -Path $vim -Target "$vim\$runtime_dir"
    }
    & "$vim\$runtime_dir\install.exe" -create-batfiles vim view vimdiff -install-popup -install-openwith -add-start-menu
  }
}

function _winget_install_if_outdated {
  param(
    [Parameter(Mandatory)] [string]$package,
    [Parameter(Mandatory)] [string]$ver_regex,
    [Parameter(Mandatory)] [string]$ver_file
  )
  Write-Output "$package"
  if ("$(winget search --exact $package)" -match $ver_regex) {
    $installed = "0"
    if (Test-Path $ver_file) {
      $installed = Get-Content $ver_file
    }
    $remote = $Matches[0]

    if ($installed -eq "0") {
      Write-Output "Installed    : Not installed"
    } else {
      Write-Output "Installed    : $installed"
    }
    Write-Output "Remote latest: $remote"
    if ($remote -gt $installed) {
      Write-Output "Installing.."
      winget install $package
      if ($?) {
        $remote | Out-File $ver_file
      }
    } else {
      Write-Output "Not installing."
    }
  } else {
    Write-Output "$ver_regex regex failed"
  }
}

function _winget_remove_links {
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

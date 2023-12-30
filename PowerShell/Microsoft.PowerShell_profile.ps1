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
  if (!(is_admin)) {
    Write-Output "Permission denied"
    return
  }
  winget install --no-upgrade Discord.Discord MSYS2.MSYS2 Microsoft.PowerToys NurgoSoftware.AquaSnap Valve.Steam
  winget install 7zip.7zip Debian.Debian ImageLine.FLStudio MPC-BE.MPC-BE MichaelTippach.ASIO4ALL Microsoft.MouseandKeyboardCenter Microsoft.WindowsTerminal PeterPawlowski.foobar2000 SteelSeries.GG Streamlink.Streamlink TrackerSoftware.PDF-XChangeEditor Zoom.Zoom
  # BurntSushi.ripgrep.MSVC Git.Git JGraph.Draw sharkdp.fd

  _winget_install_ahk
  _winget_install_vim
  _winget_install_wsltty
  _winget_install_foobar2000encoderpack

  _winget_remove_links

  winget install Microsoft.PowerShell
}

function _winget_install_ahk {
  if (!(is_admin)) {
    Write-Output "Permission denied"
    return
  }
  $scripts = (Get-Process -Name AutoHotkey64).CommandLine
  winget install AutoHotkey.AutoHotkey
  if ($?) {
    $scripts | % {
      pwsh -NoProfile -Command "& $_"
    }
  }
}

function _winget_install_vim {
  if (!(is_admin)) {
    Write-Output "Permission denied"
    return
  }
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

function _winget_install_wsltty {
  _winget_install_if_outdated "Mintty.WSLtty" '[0-9]\.[0-9]\.[0-9]' "$env:LOCALAPPDATA\wsltty\winget_version"
}
function _winget_install_foobar2000encoderpack {
  _winget_install_if_outdated "PeterPawlowski.foobar2000.EncoderPack" '20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]' "$env:ProgramFiles\foobar2000\encoders\winget_version"
}

function _winget_install_if_outdated {
  param(
    [Parameter(Mandatory)] [string]$package,
    [Parameter(Mandatory)] [string]$ver_regex,
    [Parameter(Mandatory)] [string]$ver_file
  )
  if (!(is_admin)) {
    Write-Output "Permission denied"
    return
  }
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

function register_shell_all {
  if (!(is_admin)) {
    Write-Output "Permission denied"
    return
  }
  _register_shell_wsltty
  _register_shell_mingw64
}

function _register_shell_wsltty {
  if (!(is_admin)) {
    Write-Output "Permission denied"
    return
  }
  $mintty = $env:LOCALAPPDATA + '\wsltty\bin\mintty.exe'
  $bg  = '"' + $mintty + '" -i "' + $mintty + '" --WSL=Debian -'
  $dir = '"' + $mintty + '" -i "' + $mintty + '" --dir "%1" --WSL=Debian -'
  _register_shell 'wsltty' 'WSL &Shell' $bg $dir $mintty
}

function _register_shell_mingw64 {
  if (!(is_admin)) {
    Write-Output "Permission denied"
    return
  }
  $mingw64 = 'C:\msys64\mingw64.exe'
  $bg  = '"' + $mingw64 + '" exec /usr/bin/env CHERE_INVOKING=1 /usr/bin/bash -l'
  $dir = '"' + $mingw64 + '" exec /usr/bin/env CHERE_INVOKING=1 /usr/bin/bash -l'
  _register_shell 'mingw64' '&MinGW64' $bg $dir $mingw64
}

function _register_shell {
  param(
    [Parameter(Mandatory)] [string]$entry,
    [Parameter(Mandatory)] [string]$value,
    [Parameter(Mandatory)] [string]$bg_cmd,
    [Parameter(Mandatory)] [string]$dir_cmd,
    [Parameter(Mandatory)] [string]$icon
  )
  $reg_bg = 'HKCU:Software\Classes\Directory\Background\shell\' + $entry
  $reg_bg_cmd = $reg_bg + '\command'
  New-Item  -Force -Path $reg_bg -Value $value
  New-ItemProperty -Path $reg_bg -PropertyType String -Name 'Icon' -Value $icon
  New-Item  -Force -Path $reg_bg_cmd -Value $bg_cmd
  $reg_dir = 'HKCU:Software\Classes\Directory\shell\' + $entry
  $reg_dir_cmd = $reg_dir + '\command'
  New-Item  -Force -Path $reg_dir -Value $value
  New-ItemProperty -Path $reg_dir -PropertyType String -Name 'Icon' -Value $icon
  New-Item  -Force -Path $reg_dir_cmd -Value $dir_cmd
}

function adb_all {
  ./adb kill-server
  ./adb devices
  ./adb shell settings put secure show_rotation_suggestions 0
}

function setup_windows_sshd {
  if (!(is_admin)) {
    Write-Output "Permission denied"
    return
  }
  $programdata = 'C:\ProgramData'
  if (-not [System.Environment]::GetEnvironmentVariable('PROGRAMDATA', 'Machine')) {
    [System.Environment]::SetEnvironmentVariable('PROGRAMDATA', $programdata, 'Machine')
  }
  if (-Not (Select-String -Quiet "^AuthenticationMethods publickey$" "$programdata\ssh\sshd_config")) {
    Add-Content "$programdata\ssh\sshd_config" "`r`nAuthenticationMethods publickey"
  }
  New-Item "$programdata\ssh\administrators_authorized_keys"
  Get-Acl "$programdata\ssh\ssh_host_rsa_key" | Set-Acl "$programdata\ssh\administrators_authorized_keys"

  New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\system32\wsl.exe" -PropertyType String -Force

  Set-Service sshd -StartupType Automatic
  Start-Service sshd
}

function register_vimmize {
  if (!(is_admin)) {
    Write-Output "Permission denied"
    return
  }
  $name     = "vimmizekbd"
  $action   = New-ScheduledTaskAction -Execute "`"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe`"" -Argument "`"C:\Users\$env:USERNAME\Box Sync\configs\F13.ahk`""
  $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopOnIdleEnd -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
  $trigger  = New-ScheduledTaskTrigger -AtLogon -User "$env:COMPUTERNAME\$env:USERNAME"

  Unregister-ScheduledTask -TaskName $name -Confirm:$false -ErrorAction SilentlyContinue
  Register-ScheduledTask -TaskName $name -Action $action -Settings $settings -Trigger $trigger -RunLevel Highest
}

function fontlink {
  if (!(is_admin)) {
    Write-Output "Permission denied"
    return
  }
  New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink\" -Name Consolas -Value 'HGRGM.TTC,HGRGM' -PropertyType MultiString -Force
}

function create_shortcuts {
  $document = [Environment]::GetFolderPath("MyDocuments")
  $box = $env:USERPROFILE + "\Box Sync"

  $shortcuts = @(
    @{
      name   = $document + "\System StartMenu.lnk";
      target = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs";
    };
    @{
      name   = $document + "\StartMenu.lnk";
      target = $env:APPDATA + "\Microsoft\Windows\Start Menu\Programs";
    };
    @{
      name   = $document + "\Startup.lnk";
      target = $env:APPDATA + "\Microsoft\Windows\Start Menu\Programs\Startup";
    };
    @{
      name   = $document + "\TaskBar.lnk";
      target = $env:APPDATA + "\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar";
    };
    @{
      name   = $document + "\firefox - 2.lnk";
      target = "C:\Program Files\Firefox Developer Edition\firefox.exe";
      args   = "-P X";
    };
    @{
      name   = $document + "\F13.ahk.lnk";
      target = $box + "\configs\F13.ahk";
    };
    @{
      name   = $document + "\ToggleSpeaker.lnk";
      target = "C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe";
      args   = "-ExecutionPolicy Bypass -NoProfile -File `"" + $box + "\configs\ToggleSpeaker.ps1`"";
      style  = 7;
    };
    @{
      name   = $document + "\WSL.lnk";
      target = $env:LOCALAPPDATA + "\wsltty\bin\mintty.exe"
      args   = "--WSL -~ -";
    };
  )

  $shell = New-Object -ComObject "WScript.Shell"
  $shortcuts | % {
    $s = $shell.CreateShortcut($_.name)
    $s.TargetPath = $_.target
    if ($_.ContainsKey('args')) {
      $s.Arguments = $_.args
    }
    if ($_.ContainsKey('wd')) {
      $s.WorkingDirectory = $_.wd
    }
    if ($_.ContainsKey('style')) {
      $s.WindowStyle = $_.style
    }
    $s.Save()
  }
}

function is_admin {
  (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Invoke-Command -ScriptBlock {
  $local_profile = Join-Path $([System.Environment]::GetFolderPath("MyDocuments")) "\PowerShell\local_profile.psm1"
  if (Test-Path $local_profile) {
    Import-Module $local_profile
  }
}

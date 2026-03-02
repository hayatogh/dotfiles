Set-PSReadlineKeyHandler Ctrl+b BackwardChar
Set-PSReadlineKeyHandler Ctrl+f ForwardChar
Set-PSReadlineKeyHandler Alt+b BackwardWord
Set-PSReadlineKeyHandler Alt+f ForwardWord
Set-PSReadlineKeyHandler Ctrl+a BeginningOfLine
Set-PSReadlineKeyHandler Ctrl+e EndOfLine
Set-PSReadlineKeyHandler Ctrl+u BackwardDeleteLine
Set-PSReadlineKeyHandler Ctrl+k ForwardDeleteLine
Set-PSReadlineKeyHandler Ctrl+d ViAcceptLineOrExit
Set-PSReadlineKeyHandler Ctrl+n HistorySearchForward
Set-PSReadlineKeyHandler Ctrl+p HistorySearchBackward
Set-PSReadlineKeyHandler Tab MenuComplete
function _regex_rubout {
  param($re)
  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $cursor, ($line.SubString(0, $cursor) -replace $re, ''))
}
Set-PSReadlineKeyHandler Ctrl+Alt+w { _regex_rubout('[^ ]* *$') }
Set-PSReadlineKeyHandler Alt+/ { _regex_rubout('[^/\\ ]*(/|\\)? *$') }

function prompt {
  $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }) + "$env:USERNAME@$env:COMPUTERNAME " + $(Get-Location) + $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
}

function ee {
  exit
}
Remove-Alias type
function type {
  param ([switch]$a)
  $params = @{}
  if ($a) {
    $params = @{ All = $true }
  }
  Get-Command @params @args | % {
    $_ | Format-Table Name, CommandType, Definition -AutoSize -Wrap | Out-String -Width 512
  }
}
function ll {
  Get-ChildItem -Force @args
}
function open {
  param ([string[]]$a)
  if ($a.Length -eq 0) {
    Invoke-Item .
  } else {
    Invoke-Item $a
  }
}
Set-Alias e open
function su {
  Start-Process -Verb RunAs wt
}

function create_shortcuts {
  $document = [Environment]::GetFolderPath("MyDocuments")
  $shortcuts = @(
    @{
      name   = $document + "\firefox - 2.lnk"
      target = "C:\Program Files\Mozilla Firefox ESR\firefox.exe"
      args   = "-P X"
    }
    @{
      name   = $document + "\WSL.lnk"
      target = $env:LOCALAPPDATA + "\wsltty\bin\mintty.exe"
      args   = "--WSL -~ -"
    }
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

if ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  function register_ahk {
    $name     = "ahk"
    $action   = New-ScheduledTaskAction -Execute "`"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe`"" -Argument ("`"" + [Environment]::GetFolderPath("MyDocuments") + "\base.ahk`"")
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopOnIdleEnd -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
    $trigger  = New-ScheduledTaskTrigger -AtLogon -User "$env:COMPUTERNAME\$env:USERNAME"

    Unregister-ScheduledTask -TaskName $name -Confirm:$false -ErrorAction SilentlyContinue
    Register-ScheduledTask -TaskName $name -Action $action -Settings $settings -Trigger $trigger -RunLevel Highest
  }

  function fontlink {
    New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink\" -Name Consolas -Value 'HGRGM.TTC,HGRGM' -PropertyType MultiString -Force
  }
  function fontlink1 {
    New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink\" -Name Consolas -Value 'BIZ-UDGOTHICR.TTC,BIZ UDGothic R' -PropertyType MultiString -Force
  }
}

Set-ExecutionPolicy Bypass -Scope Process
Invoke-Command -ScriptBlock {
  $local_profile = [System.Environment]::GetFolderPath("MyDocuments") + "\PowerShell\local_profile.psm1"
  if (Test-Path $local_profile) {
    Import-Module $local_profile
  }
}

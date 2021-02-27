$rlopt = @{
  BellStyle = "None"
  EditMode = "Vi"
  HistoryNoDuplicates = $true
  ViModeIndicator = "Prompt"
}
Set-PSReadLineOption @rlopt

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

function ee{exit}

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

# vim: shiftwidth=2

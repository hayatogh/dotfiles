@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

REM <YOUR BATCH SCRIPT HERE>
choco upgrade all
del "%USERPROFILE%\Desktop\Discord.lnk" ^
	"%USERPROFILE%\Desktop\Kindle.lnk" ^
	"%USERPROFILE%\Desktop\MPC-BE x64.lnk" ^
	"%USERPROFILE%\Desktop\Inkscape.lnk" ^
	"%USERPROFILE%\Desktop\SumatraPDF.lnk" ^
	"%PUBLIC%\Desktop\*.lnk" ^
	>nul 2>&1
	:: "%USERPROFILE%\Desktop\Twitch.lnk" ^
:: >nul 2>&1 reg add HKCR\Directory\Background\shell\git_gui /d "Git GUI Here" /f
:: >nul 2>&1 reg add HKCR\Directory\Background\shell\git_shell /d "Git Bash Here" /f
:: >nul 2>&1 reg add HKCR\Directory\shell\git_gui /d "Git GUI Here" /f
:: >nul 2>&1 reg add HKCR\Directory\shell\git_shell /d "Git Bash Here" /f
:: >nul 2>&1 reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.sh /f
:: >nul 2>&1 reg delete HKCR\sh_auto_file /f
pause

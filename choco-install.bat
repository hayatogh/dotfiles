@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
choco feature enable -n allowGlobalConfirmation

choco install 7zip.install
choco install aquasnap
choco install au
choco install audacity
choco install autohotkey.install
choco install discord.install
choco pin add --name discord.install
choco install drawio
choco pin add --name drawio
choco install fd
choco install flac
choco install fontforge
choco install foobar2000
:: choco install fzf
:: choco install git
choco install inkscape
:: choco install kindle
choco install lavfilters
choco install lockhunter
choco install mpc-be
choco install pdfxchangeeditor
:: choco install php
:: choco install python
choco install ripgrep
choco install skype
choco pin add --name skype
choco install slack
choco pin add --name slack
choco install steam
choco pin add --name steam
choco install strawberryperl
choco install sumatrapdf.install
choco install thunderbird
choco pin add --name thunderbird
:: choco install twitch
:: choco install universal-ctags
:: choco install vagrant
choco install vcxsrv
choco install vim
:: choco install virtualbox
choco install waterfox
choco install winscp.install
:: choco install wkhtmltopdf
choco install wsltty
choco install zotero
choco pin add --name zotero

choco-upgrade.bat

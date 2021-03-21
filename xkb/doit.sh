#!/usr/bin/env bash
set -euo pipefail

xkb=$(realpath $(dirname $0))
if [[ -f /usr/share/X11/xkb/rules/evdev.xml.old ]]; then
	echo "evdev.xml already edited."
	exit 1
fi

n=$(($(grep -n "<layoutList>" /usr/share/X11/xkb/rules/evdev.xml | cut -d : -f1) + 1))
sudo sed --in-place=.old "$n i \\
    <layout>\\
      <configItem>\\
        <name>hhkb</name>\\
        <shortDescription>en</shortDescription>\\
        <description>hhkb</description>\\
        <languageList>\\
          <iso639Id>eng</iso639Id>\\
        </languageList>\\
      </configItem>\\
    </layout>\\
    <layout>\\
      <configItem>\\
        <name>mac</name>\\
        <shortDescription>en</shortDescription>\\
        <description>mac</description>\\
        <languageList>\\
          <iso639Id>eng</iso639Id>\\
        </languageList>\\
      </configItem>\\
    </layout>" /usr/share/X11/xkb/rules/evdev.xml
sudo cp $xkb/hhkb /usr/share/X11/xkb/symbols/
sudo cp $xkb/mac /usr/share/X11/xkb/symbols/

#!/usr/bin/env bash
if [[ ! $MSYS == "winsymlinks:nativestrict" ]]; then
	echo "Couldn't installed. Run from MSYS."
	exit
fi
rm -rf emojis
mkdir -p emojis
cd emojis
wget -q -O getemojis https://github.com/mintty/mintty/wiki/getemojis
# Check md5sum to ensure that the script accepts the same option.
echo "83989d0ff7836d35b60c867cfb007dca *getemojis" | md5sum -c --status
if [[ $? != 0 ]]; then
	echo "Script changed. Manually run and update me."
	exit
fi
./getemojis -d windows

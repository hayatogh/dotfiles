#!/usr/bin/env bash
whichver=$(wget -q -O - 'http://carlowood.github.io/which/' | grep -P -m1 -o '(?<=HREF=")which-[0-9.]+(?=\.tar\.gz")')

if [[ $1 == '-n' ]]; then
	echo "Installed:     $(which --version | head -n1 | grep -P -o '(?<=v)[0-9.]+')"
	echo "Remote latest: $(grep -E -o '[0-9.]+' <<<$whichver)"
	exit
fi

mkdir -p /usr/local/src
cd /usr/local/src
wget -q -O $whichver.tar.gz https://carlowood.github.io/which/$whichver.tar.gz
rm -rf $whichver
tar -xf $whichver.tar.gz
cd $whichver
./configure --prefix=/usr/local
make -j4
make install

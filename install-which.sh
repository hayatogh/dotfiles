#!/usr/bin/env bash
whichver=$(wget -q -O - 'http://carlowood.github.io/which/' | grep -Pom1 '(?<=HREF=")which-[0-9.]+(?=\.tar\.gz")')

if [[ $1 == '-n' ]]; then
	echo "Installed:     $(which --version | grep -Po '(?<=v)[0-9.]+')"
	echo "Remote latest: $(grep -Eo '[0-9.]+' <<<$whichver)"
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

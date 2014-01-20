#!/bin/bash

gdbskip=tmp
gdbinit=~/.gdbinit
srcdir=~/Projects/clone/develop/gw/Gateway6/source
stdcdir=/usr/include
boostdir=/usr/include
linuxgnu=/usr/include/x86_64-linux-gnu

for line in $(grep --include=*.{h,cpp} -r --no-filename '#include.*\(\([<|"]boost\).\|<\)' $srcdir | sed 's/.*include.*[<\|"]\(.*\)[>\|"].*/\1/' | sort -u); do
	[[ $line == *.h ]] && [[ $line != */* ]] && {
		[[ `find $stdcdir -maxdepth 1 -name $line -print -quit` ]] && echo "$stdcdir/$line" && continue
	}
	[[ $line == boost* ]] && {
		echo "$boostdir/$line" && continue
	}
	[[ $line == sys/* ]] && {
		line=`basename $line`
		[[ `find $linuxgnu/sys/ $line -print -quit` ]] && echo "$linuxgnu/sys/$line" && continue
	}
	[[ $line == asm/* ]] && {
		line=`basename $line`
		[[ `find $linuxgnu/asm/ $line -print -quit` ]] && echo "$linuxgnu/asm/$line" && continue
	}
	echo "$line NO CATEGORY"
done

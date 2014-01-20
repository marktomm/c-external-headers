#!/bin/bash

cpp_compiler_version=`g++ -dumpversion`

gdbskip=tmp
gdbinit=~/.gdbinit

includedir=/usr/include
srcdir=/home/mark/Projects/telem-gw6/Gateway6/source/
stdcdir=$includedir
boostdir=$includedir
linuxgnu=$includedir/x86_64-linux-gnu
linuxdir=$includedir/linux
log4cxx=$includedir/log4cxx
cppdir=$includedir/c++/$cpp_compiler_version

for line in $(grep --include=*.{h,cpp} -r --no-filename '#include.*\(\([<|"]boost\).\|<\)' $srcdir | sed 's/.*include.*[<\|"]\(.*\)[>\|"].*/\1/' | sort -u); do
	[[ $line == *.h ]] && [[ $line != */* ]] && {
		findres=`find $stdcdir -maxdepth 1 -name $line -print`
		[[ ! -z "$findres" ]] && echo "$findres" && continue
	}
	[[ $line == sys/* ]] && {
# 		findres=`basename $line`
		findres=`find $linuxgnu/sys/ -name "$(basename $line)" -print`
		[[ ! -z "$findres" ]] && echo "$findres" && continue
	}
	[[ $line == asm/* ]] && {
# 		findres=`basename $line`
		findres=`find $linuxgnu/asm/ -name "$(basename $line)" -print`
		[[ ! -z "$findres" ]] && echo "$findres" && continue
	}
	[[ $line == *.h ]] && [[ $line != */* ]] && {
		findres=`find $linuxdir -name "$line" -print`
		[[ ! -z "$findres" ]] && echo "$findres" && continue
	}
	
# 	Other Libs
	[[ $line == log4cxx* ]] && {
# 		line=`basename $line`
		findres=`find $log4cxx -name "$(basename $line)" -print`
		[[ ! -z $findres ]] && echo "$findres" && continue
	}
	[[ $line == boost* ]] && {
		echo "$boostdir/$line" && continue
	}
# 	Other End

#	STL
	[[ $line != */* ]] && {
		findres=`find $cppdir -name $line -print` 
		[[ ! -z $findres ]] && echo "$findres	" && continue
	}
# 	STL End

# 	Custom
	[[ $line == microhttpd.h ]] && {
		echo "/usr/local/include/microhttpd.h" && continue
	}
	
# 	There were some more header files, but they were irrelevant in my current situation, so ignore
# 	Custom End

# 	echo "$line NO CATEGORY" 
done

#!/bin/bash

cpp_compiler_version=`g++ -dumpversion`

gdbskip=~/.gdbskip
gdbinit=~/.gdbinit  	# unused

includedir=/usr/include
srcdir=/home/mark/Projects/clone/develop/gw/Gateway6/source/
stdcdir=$includedir
boostdir=$includedir
linuxgnu=$includedir/x86_64-linux-gnu
linuxdir=$includedir/linux
log4cxx=$includedir/log4cxx
cppdir=$includedir/c++/$cpp_compiler_version
custom_dir1=/home/mark/Projects/clone/develop/gw/Gateway6/source/libcpp

rm -f $gdbskip

for line in $(grep --include=*.{h,cpp} -r --no-filename '#include.*\(\([<|"]boost\).\|<\)' $srcdir | sed 's/.*include.*[<\|"]\(.*\)[>\|"].*/\1/' | sort -u); do
	[[ $line == *.h ]] && [[ $line != */* ]] && {
		findres=`find $stdcdir -maxdepth 1 -name $line -print`
		[[ ! -z "$findres" ]] && echo "$findres" >> $gdbskip && continue
	}
	[[ $line == sys/* ]] && {
# 		findres=`basename $line`
		findres=`find $linuxgnu/sys/ -name "$(basename $line)" -print`
		[[ ! -z "$findres" ]] && echo "$findres" >> $gdbskip && continue
	}
	[[ $line == asm/* ]] && {
# 		findres=`basename $line`
		findres=`find $linuxgnu/asm/ -name "$(basename $line)" -print`
		[[ ! -z "$findres" ]] && echo "$findres" >> $gdbskip && continue
	}
	[[ $line == *.h ]] && [[ $line != */* ]] && {
		findres=`find $linuxgnu -name "$line" -print`
		[[ ! -z "$findres" ]] && echo "$findres" >> $gdbskip && continue
	}
	[[ $line == *.h ]] && [[ $line != */* ]] && {
		findres=`find $linuxdir -name "$line" -print`
		[[ ! -z "$findres" ]] && echo "$findres" >> $gdbskip && continue
	}
	
# 	Other Libs
	[[ $line == log4cxx* ]] && {
# 		line=`basename $line`
		findres=`find $log4cxx -name "$(basename $line)" -print`
		[[ ! -z $findres ]] && echo "$findres" >> $gdbskip && continue
	}
	[[ $line == boost* ]] && {
		echo "$boostdir/$line" >> $gdbskip && continue
	}
# 	Other End

#	STL
	[[ $line != */* ]] && {
		findres=`find $cppdir -name $line -print` 
		[[ ! -z $findres ]] && echo "$findres" >> $gdbskip && continue
	}
# 	STL End

# 	Custom
	[[ $line == microhttpd.h ]] && {
		echo "/usr/local/include/microhttpd.h" >> $gdbskip && continue
	}
	[[ $line == libcpp* ]] && {
		findres=`find $custom_dir1 -name "$(basename $line)" -print`
		[[ ! -z $findres ]] && echo "$findres" >> $gdbskip && continue
	}
	
# 	There were some more header files, but they were irrelevant in my current situation, so ignore
# 	Custom End

# 	echo "$line NO CATEGORY" 
done

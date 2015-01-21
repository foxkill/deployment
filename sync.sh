#!/bin/bash
cd "$(dirname "$0")"

SRC_DIR=/root/bin
DST_DIR=.

function doIt() {
	
	for F in $SRC_DIR/main.sh $SRC_DIR/exclude/. $SRC_DIR/include/.; 
	do 
		rsync --delete --exclude ".git/" --exclude ".DS_Store" --exclude "sync.sh" --exclude "README.md" -av \
			$F \
			$(dirname ${F/$SRC_DIR/$DST_DIR})
	done
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi

unset doIt

#!/bin/sh

F=$(basename $0)
FILENAME=${F%.sh}

PRIVATE_EXCLUDE=--exclude-from=exclude/${FILENAME}.exc

source include/main.opt
source include/$FILENAME.opt
source include/openvpn.opt

DOIT=0
DOFILES=0
DOVPN=0

while getopts ":fot" opt; do
	case $opt in
		f)
			DOFILES=1
		;;
		o)
			DOVPN=1
		;;
		t)
			DOIT=1
		;;
	esac
done

[ -s $FROMFILE ] && {
	FROM=--files-from=$FROMFILE
}

if [ $DOIT = 1 ]; then
	DRYRUN=""
fi

OPTS="${DRYRUN} ${GENARAL_OPTS} ${FROM} ${GENERAL_EXCLUDE} ${PRIVATE_EXCLUDE}"

if !((DOIT+DOVPN+DOFILES)); then
	DOFILES=1	
fi

if [ $DOFILES = 1 ]; then
	$RSYNC $OPTS $OPENVPN_EXCLUDE $SRCDIR $SERVER:$DSTDIR
fi

if [ $DOVPN = 1 ]; then
	for i in $OPENVPN_FILES; do
		LEFTSIDE=$OPENVPN_BASEDIR/$i
		RIGHTSIDE=OPENVPN/$i
		if [ -d $LEFTSIDE ]; then
			LEFTSIDE=$LEFTSIDE/.
			RIGHTSIDE=$RIGHTSIDE/.
		fi
		$RSYNC $OPTS $LEFTSIDE $SERVER:$RIGHTSIDE
	done
fi

#if [ $? -eq 0 ] && [ $DOIT == "-t" ]; then
#	echo "doing sync on $SERVER"
#	$SSH $SERVER $SCRIPT
#fi

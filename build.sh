#!/bin/bash
set -e

PLATFORM="sun8iw8p1_spinand_emmc"
MODULE=""
TOOLSPATH=`pwd`

show_help()
{
	printf "\nbuild.sh - Top level build scritps\n"
	echo "Valid Options:"
	echo "  -h  Show help message"
	echo "  -p <platform> platform, e.g. sun8iw8p1_spinand_emmc sun8iw8p1_nor sun8iw8p1"
	printf "  -m <module> module\n\n"
}

while getopts hp:m: OPTION
do
	case $OPTION in
	h) show_help
	;;
	p) PLATFORM=$OPTARG
	;;
	m) MODULE=$OPTARG
	;;
	*) show_help
	;;
esac
done

if [ -z "$PLATFORM" ]; then
	show_help
	exit 1
fi

if [ -z "$MODULE" ]; then
	MODULE="all"
fi


if [ 'x${UBOOT_CROSS_COMPILE}' = 'x' ]; then
    UBOOT_CROSS_COMPILE=arm-linux-gnueabi-
#   UBOOT_CROSS_COMPILE=${TOOLSPATH}/../tools/external-toolchain/bin/arm-linux-gnueabi-    
fi    

CROSS_COMPILE=${UBOOT_CROSS_COMPILE}

if [ "sun8iw8p1" == ${PLATFORM} ]; then
    make CROSS_COMPILE=${CROSS_COMPILE} distclean && \
	make -j 6 CROSS_COMPILE=${CROSS_COMPILE} $PLATFORM && \
	make -j 6 CROSS_COMPILE=${CROSS_COMPILE} boot0 && \
	make -j 6 CROSS_COMPILE=arm-linux-gnueabi- fes
elif [ "sun8iw8p1_nor" == ${PLATFORM} ]; then
    make CROSS_COMPILE=${CROSS_COMPILE} distclean && \
	make -j 6 CROSS_COMPILE=${CROSS_COMPILE} $PLATFORM
elif [ "sun8iw8p1_spinand_emmc" == ${PLATFORM} ]; then
    make CROSS_COMPILE=${CROSS_COMPILE} distclean && \
	make -j 6 CROSS_COMPILE=${CROSS_COMPILE} $PLATFORM && \
	make -j 6 CROSS_COMPILE=${CROSS_COMPILE} fes && \
    	make -j 6 CROSS_COMPILE=${CROSS_COMPILE} boot0
fi

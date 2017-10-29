#! /bin/bash

echo "Setting Environmental Variables..."
export ARCH=arm64
export CROSS32CC=arm-linux-gnueabi-gcc
#TX_BASE_DIR=${PWD}
TX_BASE_DIR=/home/cospan/Projects/nvidia_3.1
export KERNEL_SOURCE=$TX_BASE_DIR/Linux_for_Tegra/sources/kernel/kernel-4.4
export CROSS_COMPILE=$TX_BASE_DIR/toolchain/bin/aarch64-unknown-linux-gnu-
export TEGRA_KERNEL_OUT=$TX_BASE_DIR/Linux_for_Tegra/kernel
ROOTFS_PATH=$TX_BASE_DIR/Linux_for_Tegra/rootfs
KERNEL_VERSION=4.4.38+
KERNEL_VERSION_OLD=4.4.38-tegra

MODULE_OUT_PATH=$TEGRA_KERNEL_OUT/module_deploy
HEADER_OUT_PATH=$TEGRA_KERNEL_OUT/header_deploy

DEFAULT_CONFIG=tegra18_defconfig

echo "Parsing Inputs"

COMMAND="BUILD"

#Parse the Inputs
echo "Key: $1"

while [[ $# > 0 ]]
do
key="$1"

case $key in
    -r|--rebuild)
    COMMAND="REBUILD"
    shift # past argument
    ;;
    -m|--menu)
    COMMAND="MENU"
    shift # past argument
    ;;
    *)
    # unknown option
    ;;
esac
shift
done

sudo echo "Finished parsing inputs"
sudo rm -rf $MODULE_OUT_PATH/*

cd $KERNEL_SOURCE

if [ "$COMMAND" == "BUILD" ]; then
  echo "Build"
  make O=$TEGRA_KERNEL_OUT -j4

fi
if [ "$COMMAND" == "REBUILD" ]; then
  echo "Re-Build"
  make O=$TEGRA_KERNEL_OUT -j4 mrproper
  make O=$TEGRA_KERNEL_OUT -j4 distclean
  make O=$TEGRA_KERNEL_OUT -j4 $DEFAULT_CONFIG
fi

if [ "$COMMAND" == "REBUILD" -o "$COMMAND" == "BUILD" ]; then
	echo "Build Kernel Image"
  make O=$TEGRA_KERNEL_OUT -j4 zImage

	echo "Build Device Database File"
  make O=$TEGRA_KERNEL_OUT -j4 dtbs

	echo "Build Modules"
  make O=$TEGRA_KERNEL_OUT -j4 modules

	echo "Install the new modules into the rootfs"
  make O=$TEGRA_KERNEL_OUT -j4 modules_install INSTALL_MOD_PATH=$MODULE_OUT_PATH

	#echo "Create kernel headers"
  make O=$TEGRA_KERNEL_OUT -j4 headers_install INSTALL_HDR_PATH=$HEADER_OUT_PATH

	echo "Copy over zImage to base of kernel output directory"
	sudo cp $TEGRA_KERNEL_OUT/arch/arm64/boot/zImage $TEGRA_KERNEL_OUT/zImage

	echo "Copy over Image to base of kernel output directory"
	sudo cp $TEGRA_KERNEL_OUT/arch/arm64/boot/Image $TEGRA_KERNEL_OUT/Image

	echo "Copy over dtc to base of kernel output directory"
	sudo cp $TEGRA_KERNEL_OUT/scripts/dtc/dtc $TEGRA_KERNEL_OUT/dtc

	echo "Copy all of the DTBs from  to the dtb directory"
	sudo cp $TEGRA_KERNEL_OUT/arch/arm64/boot/dts/*.dtb $TEGRA_KERNEL_OUT/dtb/

	echo "Create Kernel Supplement"
	cd $MODULE_OUT_PATH/lib/modules/$KERNEL_VERSION
	rm -f build
	rm -f source

	echo "Change to: $MODULE_OUT_PATH"
	cd $MODULE_OUT_PATH
	tar --owner root --group root -cjf kernel_supplements.tbz2 ./*
	mv kernel_supplements.tbz2 $TEGRA_KERNEL_OUT/

	sudo chown -R root:root ./*
	sudo cp -a ./* $ROOTFS_PATH/
	#Install the kernel modules
	#cd $ROOTFS_PATH
	#tar --owner root --group root -cjf $TEGRA_KERNEL_OUT/kernel_supplements.tbz2 .

	echo "Create Kernel Headers"
	cd $HEADER_OUT_PATH
	echo "Change to $HEADER_OUT_PATH"
	#tar -cjf kernel_headers.tbz2 ./*
	#mv kernel_headers.tbz2 $TEGRA_KERNEL_OUT/
	#tar xvf kernel_headers.tbz2
	#mv linux-headers-$KERNEL_VERSION_OLD linux-headers-$KERNEL_VERSION
	#tar -cjf kernel_headers.tbz2 linux-headers-$KERNEL_VERSION
	tar -cjf kernel_headers.tbz2 ./*
	mv kernel_headers.tbz2 $TEGRA_KERNEL_OUT/

fi

if [ "$COMMAND" == "MENU" ]; then
  echo "Menu Config"
  make O=$TEGRA_KERNEL_OUT -j4 menuconfig
fi

echo "Kernel Build Finished"


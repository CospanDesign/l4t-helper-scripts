#! /bin/bash

echo "Setting Environmental Variables..."
TX_BASE_DIR=${PWD}

export ARCH=arm64
export CROSS_COMPILE=$TX_BASE_DIR/toolchain/bin/aarch64-unknown-linux-gnu-
export PLATFORM=blackbird
export TEGRA_UBOOT_OUT=$TX_BASE_DIR/Linux_for_Tegra/bootloader/t186ref/$PLATFORM
export ROOTFS_PATH=$TX_BASE_DIR/Linux_for_Tegra/rootfs
export UBOOT_SOURCE=$TX_BASE_DIR/Linux_for_Tegra/sources/u-boot
export CONFIG_NAME=blackbird_defconfig

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

echo "Finished parsing inputs"

cd $UBOOT_SOURCE

if [ "$COMMAND" == "BUILD" ]; then
  echo "Build"
  make O=$TEGRA_UBOOT_OUT -j4
fi
if [ "$COMMAND" == "REBUILD" ]; then
  echo "Re-Build"
  make mrproper
  make O=$TEGRA_UBOOT_OUT -j4 distclean
  make O=$TEGRA_UBOOT_OUT -j4 $CONFIG_NAME
  make O=$TEGRA_UBOOT_OUT -j4
fi
if [ "$COMMAND" == "MENU" ]; then
  echo "Menu Config"
  make O=$TEGRA_UBOOT_OUT -j4 menuconfig
fi

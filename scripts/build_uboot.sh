#! /bin/bash

echo "Setting Environmental Variables..."
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS32CC=arm-linux-gnueabi-gcc
export TX_BASE_DIR=${PWD}
export TEGRA_UBOOT_OUT=$TX_BASE_DIR/Linux_for_Tegra/bootloader/t210ref/quokka-2180
export ROOTFS_PATH=$TX_BASE_DIR/Linux_for_Tegra/rootfs
export UBOOT_SOURCE=$TX_BASE_DIR/Linux_for_Tegra/sources/u-boot_source


COMMAND="BUILD"

#Parse the Inputs

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

cd $UBOOT_SOURCE

if [ "$COMMAND" == "BUILD" ]; then
  echo "Build"
  make O=$TEGRA_UBOOT_OUT -j4
fi
if [ "$COMMAND" == "REBUILD" ]; then
  echo "Re-Build"
  make mrproper
  make O=$TEGRA_UBOOT_OUT -j4 distclean
  make O=$TEGRA_UBOOT_OUT -j4 quokka-2180_defconfig
  make O=$TEGRA_UBOOT_OUT -j4
fi
if [ "$COMMAND" == "MENU" ]; then
  echo "Menu Config"
  make O=$TEGRA_UBOOT_OUT -j4 menuconfig
fi

echo "Copy output files to base bootloader directory"
cp ~/Projects/tx1/Linux_for_Tegra/bootloader/t210ref/quokka-2180/u-boot-dtb.bin ~/Projects/tx1/Linux_for_Tegra/bootloader/u-boot-dtb.bin



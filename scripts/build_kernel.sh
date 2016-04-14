#! /bin/bash

echo "Setting Environmental Variables..."
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS32CC=arm-linux-gnueabi-gcc
export TX_BASE_DIR=${PWD}
export KERNEL_SOURCE=$TX_BASE_DIR/Linux_for_Tegra/sources/kernel_source
export TEGRA_KERNEL_OUT=$TX_BASE_DIR/Linux_for_Tegra/kernel
export MODULE_OUT_PATH=$TEGRA_KERNEL_OUT/module_deploy

echo "Parsing Inputs"

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

echo "Change to the kernel output directory and erase all the current output"
cd $KERNEL_SOURCE

if [ "$COMMAND" == "MENU" ]; then
  echo "Menu Config"
  make O=$TEGRA_KERNEL_OUT -j4 menuconfig
  exit
fi

if [ "$COMMAND" == "REBUILD" ]; then
  echo "Re-Build"
  make O=$TEGRA_KERNEL_OUT mrproper
  make O=$TEGRA_KERNEL_OUT -j4 distclean
  echo "Setup Conifguration File"
  make O=$TEGRA_KERNEL_OUT tegra21_defconfig
fi

echo "Build Image"
make O=$TEGRA_KERNEL_OUT -j4 zImage
echo "Build device database files"
make O=$TEGRA_KERNEL_OUT -j4 dtbs
echo "Build Modules"
make O=$TEGRA_KERNEL_OUT -j4 modules
echo "Install the new modules"
make O=$TEGRA_KERNEL_OUT -j4 modules_install INSTALL_MOD_PATH=$MODULE_OUT_PATH

echo "Copy over zImage to base of kernel output directory"
cp $TEGRA_KERNEL_OUT/arch/arm64/boot/zImage $TEGRA_KERNEL_OUT/zImage
echo "Copy over Image to base of kernel output directory"
cp $TEGRA_KERNEL_OUT/arch/arm64/boot/Image $TEGRA_KERNEL_OUT/Image
echo "Copy over dtc to base of kernel output directory"
cp $TEGRA_KERNEL_OUT/scripts/dtc/dtc $TEGRA_KERNEL_OUT/dtc
echo "Copy all of the DTBs from  to the dtb directory"
cp $TEGRA_KERNEL_OUT/arch/arm64/boot/dts/* $TEGRA_KERNEL_OUT/dtb/


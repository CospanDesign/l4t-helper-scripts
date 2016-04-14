#! /bin/bash

BOARD_NAME=quokka-2180
DTSI_FILE=tegra210-quokka-pinmux.dtsi

PINMUX_FILE=pinmux-config-${BOARD_NAME}.h

BASE_DIR=$PWD
CONFIG_DIR=$BASE_DIR/quokka_config_files
PINMUX_DIR=$BASE_DIR/tegra-pinmux-scripts
UBOOT_BASE_DIR=$BASE_DIR/Linux_for_Tegra/sources/u-boot_source
UBOOT_BOARD_DIR=$UBOOT_BASE_DIR/board/nvidia/$BOARD_NAME
KERNEL_BASE_DIR=$BASE_DIR/Linux_for_Tegra/sources/kernel_source
KERNEL_DTS_DIR=$KERNEL_BASE_DIR/arch/arm64/boot/dts/tegra210-platforms



echo "Change to pinmux script directory"
cd $PINMUX_DIR

echo "Run CSV to board..."
./csv-to-board.py $BOARD_NAME
echo "finished"

echo "Generate a new pinmux configuration for u-boot"
./board-to-uboot.py $BOARD_NAME > $UBOOT_BOARD_DIR/$PINMUX_FILE
echo "finished"

echo "Copy the DTS file generated by the pinmux tool to the appropraite kernel directory"
#printf "cp %s %s\n" $CONFIG_DIR/$DTSI_FILE $KERNEL_DTS_DIR/$DTSI_FILE
cp $CONFIG_DIR/$DTSI_FILE $KERNEL_DTS_DIR/$DTSI_FILE
echo "finished"

#! /bin/bash

echo "Reading a kernel panic address in return the source code address"

BASE_DIR=$(dirname "$SCRIPT")
VMLINUX_PATH=$BASE_DIR/Linux_for_Tegra/kernel/vmlinux


./aarch-64-toolchain/bin/aarch64-unknown-linux-gnu-addr2line -e $VMLINUX_PATH $1


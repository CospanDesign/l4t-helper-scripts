#! /bin/bash

NAME="backup.tx2.img"

printf "Storing backup to: ${NAME}\n"

cd Linux_for_Tegra
sudo ./flash.sh -r -k APP -G my_backup.img jetson-tx2 mmcblk0p1 


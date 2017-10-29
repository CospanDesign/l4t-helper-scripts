# l4t-helper-scripts

Scripts that help in the process of building Linux for Tegra

Instructions:

  * Add these scripts to the BASE DIRECTORY of your L4T Projects, the BASE DIRECTORY is the directory just above the 'Linux_for_Tegra' directory

```bash
<BASE DIRECTORY>/Linux_for_Tegra
```


  * Modify the name of the scripts to point to your board use the following command line


```bash
cd <BASE DIRECTORY>
grep -rIn 'blackbird' | xargs sed -i 's/quokka/<your board name>/g'
```


## Script Usage:

build-uboot.sh: Builds uboot, use the '-r' flag to rebuild and the '-m' flag for menu, no flags will build normally
build-kernel.sh: Builds the kernel, use the '-r' flag to rebuild and the '-m' flag for menu, no flags will build normally
flash-blackbird.sh: Perform a full flash for the blackbird board
flash-tx2.sh: full flash for the normal TX2 board.
get-kernel-source-line.sh: When a kernel panic happens copy the hex address at the top of the panic and feed it into this script to return the associated kernel file, source line.

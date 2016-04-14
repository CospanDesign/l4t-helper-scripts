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
grep -rIn 'quokka' | xargs sed -i 's/quokka/<your board name>/g'
```


  * Add a directory where you can store the output of the excel pinmux tool (both the csv and generated dtsi files)


```bash
cd <BASE DIRECTORY>
mkdir <your board name>\_config\_files
```


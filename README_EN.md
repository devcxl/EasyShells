# EasyShell

EasyShell aims to make the use of Linux systems more convenient and simplify complex operations.

> Why bother typing so many commands when a single script can do the job?

## Directory

* [One-click installation and configuration of Aria2](src/aria2install)
* [One-click installation and configuration of FRP](src/frpinstall)
* [One-click generation of SSH private keys](src/keygen)
* [One-click installation and configuration of proxies](src/v2rayinstall)
* [One-click installation/update of VsCode](/src/vscode-update)

* [Script for installing Docker on Ubuntu](/src/ubuntu-install-docker.sh)
* [Script for installing VsCode with PPA source on Ubuntu](/src/ubuntu-install-vscode-ppa.sh)
* [Script for parsing YAML files](/src/parse_yaml.sh)
* [Script for Termux initialization](/src/termux_init.sh)

## Merge

The main function of this script is to merge the scripts marked with `#deps:` as dependencies with `main.sh` into a release script.

It reduces unnecessary workload and optimizes the script writing experience, just like importing packages in Python, very comfortable.

Here are some examples:

* Merge frpinstall and output to the releases directory

    `bash merge -d frpinstall -release frpinstall`

* Merge keygen and run 'keygen server -C root@192.168.1.1'

    `bash merge -d keygen -r 'server -C root@192.168.1.1'`
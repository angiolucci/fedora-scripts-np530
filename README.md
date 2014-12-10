Fedora scripts for Samsung series 5 (NP530U3C)
==============================================

 My personal collection of scripts to configure
Samsung series 5 Ultra for Fedora Linux 
(or was it the other way around?).

It contains scripts and source code from myself and
other authors (referecend at the source-code ).


What does it do?
---------------
* Add support for fn + {F11,F12} keys (silent mode and wi-fi switch)
* Changes screen brightness and performance mode if switch from/to {battery, ac}
* Power saving enhancements 

How to install:
----------------
Ensure that you have `gcc` installed and run `install.sh` with
root privileges

How to use:
------------
The `install.sh` script should place all files in the proper folder,
so there's no need to aditional configuration.

The only exception are the fn+F11 and fn+F12 keys. 
Just bind them to ` sudo performance.sh` and
`sudo rfkill.sh` scripts.



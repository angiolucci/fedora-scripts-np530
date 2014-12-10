#!/bin/bash
# this simple script takes care of toggling wifi and bt on Samsung series 9 (and possible other Samsung) laptops.
# it's written by Jos Poortvliet and licensed public domain cuz its brain-dead simple to write, even for him :D
#
# This script requires the wifi and bt files to be accessible by the user.
# To make that happen, add the lines below (without the first #'s) in your /etc/sudoers file.
# This will ensure access to this script. Be sure to make this script owned by root (chown root rfkill.sh)
# to protect it from modifications.
#
# Cmnd_Alias rfkill = /home/YOUR USERNAME/bin/rfkill.sh
# Defaults!rfkill !requiretty
# YOUR USERNAME    ALL=(ALL)   NOPASSWD: rfkill
#
# Of course, you now want to assign the wifi key (Fn F12) to this script. The easiest way is to
# go to the KDE systemsettings and open 'Shortcuts and Gestures'. Then follow these steps:
# 1. Create a new global shortcut (on the bottom: edit > new > global shortcut > command/URL)
# 2. As trigger, assign the Fn-F12 key
# 3. As Action, simply browse for where you put this script (for example /home/jospoortvliet/bin/rfkill.sh)
# the script should now work (provided you have already executed the chmod!)
#
# Or, instead of making the hotkeys, import the khotkeys file I created instead:
# https://dl.dropbox.com/u/29347181/NP900X3C.khotkeys
#

# the wlan and bt rfkill name changes sometimes, so some magic to find the right ones:

wlan="$(grep -l "wlan" /sys/devices/platform/samsung/rfkill/rfkill*/name)"
if [[ -f "$wlan" ]]; then
wlan_state="$(echo "$wlan" | sed 's/name$/state/')"
fi

bt="$(grep -l "bluetooth" /sys/devices/platform/samsung/rfkill/rfkill*/name)"
if [[ -f "$bt" ]]; then
bt_state="$(echo "$bt" | sed 's/name$/state/')"
fi


if cat $wlan_state | grep 1; 
then echo 0 > $wlan_state;
echo 0 > $bt_state;
else echo 1 > $wlan_state;
echo 1 > $bt_state;
exit 0
fi

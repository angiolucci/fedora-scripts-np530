#!/bin/bash
# this simple script takes care of toggling the performance mode on Samsung series 9 (and possible other samsung) laptops.
# it's written by Jos Poortvliet and licensed public domain cuz its brain-dead simple to write, even for him :D
#
# This script requires the performance_level file to be accessible by the user.
# To make that happen, add the three lines below (without the first #'s) in your /etc/rc.c/boot.local file.
# This will ensure these lines get executed on each boot!
#
# --
#
# # allow changing performance level
# chgrp users /sys/devices/platform/samsung/performance_level
# chmod 664 /sys/devices/platform/samsung/performance_level
#
# --
#
# Of course, you now want to assign the ventilator (Fn F11) to this script.
# You first need to ensure the Fn keys work. Go to the link below and follow instructions if they don't work already:
# https://bugzilla.redhat.com/show_bug.cgi?id=838036
#
# Now you have to connect the keys to actions which trigger the script. The easiest way is to
# go to the KDE systemsettings and open 'Shortcuts and Gestures'. Then follow these steps:
# 1. Create a new global shortcut (on the bottom: edit > new > global shortcut > command/URL)
# 2. As trigger, assign the Fn-F11 key
# 3. As Action, simply browse for where you put this script (for example /home/jospoortvliet/bin/performance.sh)
# the script should now work (provided you have already executed the chmod!)
#
# Or, instead of making the hotkeys, import the khotkeys file I created instead:
# https://dl.dropbox.com/u/29347181/NP900X3C.khotkeys
#
# Check also the wlan script for the S9!
#

profiler=/sys/devices/platform/samsung/performance_level
n_level="normal"
s_level="silent"
level=`cat "$profiler"`

if [ -n "$1" ]; then
	if [ "$1" = "$s_level" -o "$1" = "$n_level" ]; then
		echo "$1" > "$profiler"
	else
		if [ "$1" = "query" ]; then
			if [ "$level" = "$n_level" ]; then
				n_level="[$n_level]"
			else
				s_level="[$s_level]"
			fi
			echo "Current performance level: " "$s_level" "  " "$n_level"
		fi
	fi
else
	if  [ "$level" = "$s_level" ]; 	then
		echo "$n_level" > "$profiler"
	else
		echo "$s_level" > "$profiler"
	fi
fi
exit 0

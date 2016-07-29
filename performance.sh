#!/bin/bash

# Heavily modified by Vinícius Angiolucci Reis (angiolucci)
# based on the original work of Jos Poortvliet [http://blog.jospoortvliet.com/]
# -----------------------------------------------------------------------------

# Original text from Jos Poortvliet:

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


# Setup
fan_profiler="/sys/devices/platform/samsung/performance_level"
cpu_profiler="/sys/devices/system/cpu/cpu*/cpufreq/scaling_governor"
gpu_profiler="/sys/module/i915/parameters/powersave"

if [ ! -f "$gpu_profiler" ]; then
  gpu_profiler=/dev/null
fi

# main status, based on fan and cpu stats.
#   0 - means that fan is in silent mode and cpu is in powersave mode
#   1 - means that fan is in performance mode and cpu is in powersave mode
#   2 - means that fan is in performance mode and cpu is in performance mode
silent_level="0"
normal_level="1"
gaming_level="2"

fan_string_normal="normal"
fan_string_silent="silent"
cpu_string_powersave="powersave"
cpu_string_performance="performance"


# Which state are we now?
fan_level=$(cat "$fan_profiler")
cpu_level=$(cat $cpu_profiler | head -n 1)


# Reads fan/cpu states and sets a consistent main state
current_power_state="$normal_level"
case "$fan_level" in
  "$fan_string_silent")
    current_power_state="$silent_level"
  ;;

  "$fan_string_normal")
    case "$cpu_level" in

      "$cpu_string_performance")
        current_power_state="$gaming_level"
      ;;

    esac
  ;;
esac


# Parse the new power state based on user args.
new_power_state="$current_power_state"
case "$1" in
  "query")
    #echo $current_power_state
  ;;

  "silent" | "0")
    new_power_state="$silent_level"
  ;;

  "normal" | "1")
    new_power_state="$normal_level"
  ;;

  "gaming" | "2")
    new_power_state="$gaming_level"
  ;;

  *)
    if test -n "$1"
    then
      echo "Helping is coming soon =)"
      exit 1
    else
      # Switch state 
      case "$current_power_state" in
        "0")
          new_power_state=1
        ;;

        "1")
          new_power_state=0
        ;;

        "2")
          new_power_state=0
        ;;

        *)
          new_power_state=1
        ;;
      esac
    fi
  ;;

esac

# Write the new power state (inconditionally, due to
# consistency).
case "$new_power_state" in
  "$silent_level")
    echo "$fan_string_silent" > "$fan_profiler"
    echo "$cpu_string_powersave" | tee $cpu_profiler >/dev/null
    echo 1 > "$gpu_profiler"
  ;;

  "$normal_level")
      echo "$fan_string_normal" > "$fan_profiler"
      echo "$cpu_string_powersave" | tee $cpu_profiler >/dev/null
      echo 1 > "$gpu_profiler"
  ;;

  "$gaming_level")
      echo "$fan_string_normal" > "$fan_profiler"
      echo "$cpu_string_performance" | tee $cpu_profiler >/dev/null
      echo 0 > "$gpu_profiler"
  ;;
esac
echo "$new_power_state"

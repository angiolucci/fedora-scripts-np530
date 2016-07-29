#!/bin/bash

performance_script=$(which performance.sh)
performance_new_state=$(sudo $performance_script $*)
error_level=$?

notify_title="Perfil de desempenho"
notify_args="-h int:transient:1"


if [ $error_level == 0 ]; then
  case "$performance_new_state" in
    0)
      notify_icon="face-shutmouth-symbolic"
      notify_msg="Silencioso"
    ;;
  
    1)
      notify_icon="face-smile-symbolic"
      notify_msg="Normal"
    ;;

    2)
      notify_icon="face-devilish-symbolic"
      notify_msg="Gaming"
    ;;
  esac
  notify-send $notify_args -i "$notify_icon" "$notify_title" "$notify_msg"
fi


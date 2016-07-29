#!/bin/bash

rfkill_script=$(which rfkill.sh)
rfkill_new_state=$(sudo $rfkill_script)
notify_title="Adaptador de rede sem fio"
notify_args="-h int:transient:1"

if [ "$rfkill_new_state" == "0" ]; then
  notify_icon="network-wireless-offline-symbolic.symbolic"
  notify_msg="Desativado"
else
  notify_icon="network-wireless-signal-excellent-symbolic.symbolic"
  notify_msg="Ativado"
fi

notify-send $notify_args -i "$notify_icon" "$notify_title" "$notify_msg"


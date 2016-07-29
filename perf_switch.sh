#!/bin/bash
MIN_VALUE=0
MAX_VALUE=2
CMD_PATH=$(which performance.sh)
TEXT="Selecione o nível de desempenho:"

if [ "$?" == "1" ]; then
  echo "Can't read performance level!"
  exit 1
fi

CUR_VALUE=$(sudo $CMD_PATH query)

if [ $CUR_VALUE -lt 0 -o $CUR_VALUE -gt 2 ]; then
  CUR_VALUE=0
fi

NEW_VALUE=$(zenity --scale --value $CUR_VALUE --min-value $MIN_VALUE \
            --max-value $MAX_VALUE --text "$TEXT" 2> /dev/null)
if [ -z $NEW_VALUE ]; then
  exit 0
fi

CMD_PATH=$(which performance_ost_wrapper.sh)
if [ "$?" == "1" ]; then
  echo "Can't find wrapper executable!"
  exit 1
fi

sh $CMD_PATH $NEW_VALUE
exit 0



#!/bin/bash

# Install script
# author: angiolucci
# Yes, I know. It's a mess. A lot to be improved :)

USERNAME=`whoami`
if [ $USERNAME = "root" ]; then
   echo "What is the default user? (not root!)"
   read USERNAME
fi

SUDOCONFIG="$USERNAME ALL=(ALL) ALL, NOPASSWD: /usr/local/bin/performance.sh, /usr/local/bin/rfkill.sh"

sudo cp -f 30-local.rules /etc/udev/rules.d
sudo cp -f performance.sh /usr/local/bin
sudo cp -f rfkill.sh /usr/local/bin
sudo cp -r performance.sh /usr/local/bin
sudo cp -r rc.local /etc/rc.d

if [ ! -s "/usr/bin/gcc" ]; then
    sudo yum install gcc -y
fi

sudo gcc set-backlight.c -o set-backlight
sudo mv set-backlight /usr/local/bin

sudo chmod +x /usr/local/bin/performance.sh
sudo chmod +x /usr/local/bin/rfkill.sh
sudo chmod +x /usr/local/bin/set-backlight
sudo chown root /usr/local/bin/set-backlight
sudo chmod u+s /usr/local/bin/set-backlight
sudo chmod +x /etc/rc.d/rc.local

sudo cp /etc/sudoers ./sudoers.tmp

if [ ! -f "sudoers.tmp" ]; then
    echo "Could not open sudoers file. Is sudo installed?"
    exit 1
fi

echo "$SUDOCONFIG" > /tmp/npconfig.tmp
sudo sh -c 'cat /tmp/npconfig.tmp >> sudoers.tmp'
sudo visudo -c -f sudoers.tmp
rm -fr /tmp/npconfig.tmp
if [ "$?" -eq "0" ]; then
    sudo mv sudoers.tmp /etc/sudoers
fi

echo "DONE!"
echo "Please, reboot to changes take effect"

#!/bin/bash

# Install script
# author: angiolucci
# Yes, I know. It's a mess. A lot to be improved :)

RELEASE=`cat /etc/fedora-release | cut -d " " -f 3`

USERNAME=`whoami`
if [ $USERNAME = "root" ]; then
   echo "What is the default user? (not root!)"
   read USERNAME
fi

SUDOCONFIG="$USERNAME ALL=(ALL) ALL, NOPASSWD: /usr/local/bin/performance.sh, /usr/local/bin/rfkill.sh"

if [ "$RELEASE" = "21" ]; then
  sudo cp -f 30-local-r21.rules /etc/udev/rules.d/30-local.rules
else
  sudo cp -f 30-local-r20.rules /etc/udev/rules.d/30-local.rules
fi

sudo cp -f performance.sh /usr/local/bin
sudo cp -f rfkill.sh /usr/local/bin
sudo cp -r performance.sh /usr/local/bin
sudo cp -r rc.local /etc/rc.d
sudo cp -f custom.sh /etc/profile.d

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
sudo chmod +x /etc/profile.d/custom.sh

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

su -c 'yum localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'

echo "DONE!"
echo "Please, reboot to changes take effect"

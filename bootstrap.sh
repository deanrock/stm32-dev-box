#!/bin/bash

#Add PPA for gnu arm embedded toolchain
sudo apt-get update
sudo apt-get -y install python-software-properties
sudo add-apt-repository -y ppa:terry.guo/gcc-arm-embedded
sudo apt-get update

#Install packages
sudo apt-get -y install flex bison libgmp3-dev libmpfr-dev libncurses5-dev \
    libmpc-dev autoconf texinfo build-essential libftdi-dev git python-yaml \
    unzip pkg-config libusb-1.0-0-dev gcc-arm-none-eabi




sudo mkdir -p /temp/
cd /temp/


echo "Checking installation"
arm-none-eabi-gcc --version

if hash st-flash 2>/dev/null; then
	echo "stlink already installed"
else
	#install stlink
	echo "Installing stlink"
	cd ~
	git clone git://github.com/texane/stlink.git
	cd stlink
	./autogen.sh
	./configure
	make

	echo "export PATH=$PATH:~/stlink" >> ~/.profile
fi

echo "Setting up udev ules"
cd ~/stlink
sudo cp ~/stlink/49-stlinkv2.rules /etc/udev/rules.d
sudo udevadm control --reload-rules

sudo cp ~/stlink/stlink_v1.modprobe.conf /etc/modprobe.d/
sudo modprobe -r usb-storage && sudo modprobe usb-storage
sudo cp ~/stlink/49-stlinkv1.rules /etc/udev/rules.d
sudo udevadm control --reload-rules

echo "Installation finished"
. ~/.profile


#!/bin/bash

GCC_ARM_EMBEDDED=gcc-arm-none-eabi-4_7-2013q3-20130916-linux



sudo mkdir -p /temp/
cd /temp/

echo "Updating package list"
sudo apt-get update
sudo apt-get -y install git build-essential autoconf libusb-1.0-0 libusb-dev libusb-1.0-0-dev

echo "Installing gcc-arm-embedded"
sudo mkdir -p Downloads
cd Downloads

sudo rm -r /opt/ARM

[[ -f $GCC_ARM_EMBEDDED.tar.bz2 ]] || sudo wget https://launchpad.net/gcc-arm-embedded/4.7/4.7-2013-q3-update/+download/$GCC_ARM_EMBEDDED.tar.bz2
[[ -d gcc-arm-none-eabi-4_7-2013q3 ]] || sudo tar xjvf $GCC_ARM_EMBEDDED.tar.bz2
sudo mv gcc-arm-none-eabi-4_7-2013q3 /opt/ARM
sudo chown vagrant:vagrant -R /opt/ARM/
echo "PATH=$PATH:/opt/ARM/bin" | sudo tee -a /home/vagrant/.bashrc > /dev/null

echo "Checking installation"
arm-none-eabi-gcc --version

echo "Installing stlink"
cd ..
sudo mkdir -p src && cd src
sudo git clone git://github.com/texane/stlink.git
cd stlink
./autogen.sh
sudo ./configure
sudo make

sudo mkdir -p /opt/stlink
cd /opt/stlink
sudo cp /temp/src/stlink/st-flash .
sudo cp /temp/src/stlink/st-util .
echo "PATH=$PATH:/opt/stlink" | sudo tee -a /home/vagrant/.bashrc > /dev/null

echo "Setting up udev ules"
sudo cp /temp/src/stlink/49-stlinkv2.rules /etc/udev/rules.d
sudo udevadm control --reload-rules

sudo cp /temp/src/stlink/stlink_v1.modprobe.conf /etc/modprobe.d/
sudo modprobe -r usb-storage && sudo modprobe usb-storage
sudo cp /temp/src/stlink/49-stlinkv1.rules /etc/udev/rules.d
sudo udevadm control --reload-rules

echo "Installation finished"

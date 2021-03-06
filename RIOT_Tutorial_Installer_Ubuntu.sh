#Bootstrap architecture
ARCH=`uname -m`
if [ ${ARCH} == 'x86_64' ]; then
  echo "64 bit platform detected"
  TOOLCHAIN_URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2?product=GNU%20ARM%20Embedded%20Toolchain,64-bit,,Linux,6-2017-q2-update

  #Required for running native on x86_64 platforms
  sudo apt-get install gcc-multilib -y
else
  echo "32 bit platform detected"
  TOOLCHAIN_URL=https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q3-update/+download/gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2
fi

#Create temp dir
CURR_DIR=$(pwd)
mkdir tmp
cd tmp
RIOT_TMP=$(pwd)

cd $CURR_DIR

#Clone RIOT Tutorials
git clone --recursive https://github.com/RIOT-OS/Tutorials

#Install dependencies
sudo apt-get install build-essential pkg-config autoconf automake libtool libusb-dev libusb-1.0-0-dev libhidapi-dev -y
sudo apt-get install python-pip -y
yes | pip install pyserial

#Install OpenOCD
cd $RIOT_TMP
git clone git://git.code.sf.net/p/openocd/code openocd
cd openocd/
./bootstrap
./configure
make
sudo make install

#Install ARM Toolchain
cd $RIOT_TMP
wget $TOOLCHAIN_URL -O gcc.tar.bz2
mkdir ~/opt
tar -xf gcc.tar.bz2 -C ~/opt/
cd ~/opt/gcc-*
cd bin/
sudo su root -c 'echo "export PATH=\$PATH:$(pwd)" >> /etc/profile'
source /etc/profile && export PATH

#Add udev rule for flashing samr21
echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"'     | sudo tee -a /etc/udev/rules.d/99-usb.rules
sudo service udev restart

#Remove tmp dir
cd $CURR_DIR
rm -rf $RIOT_TMP

#Add dialout and plugdev permissions to current user
sudo usermod -a -G dialout $USER
sudo usermod -a -G plugdev $USER

echo -n "Setup finished."
echo "Please reboot. Happy coding!"

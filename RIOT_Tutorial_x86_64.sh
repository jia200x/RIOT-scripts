CURR_DIR=$(pwd)
mkdir tmp
cd tmp
RIOT_TMP=$(pwd)

cd $CURR_DIR
#Install git
sudo apt-get install git -y

#Clone RIOT Tutorials
git clone --recursive https://github.com/RIOT-OS/Tutorials

sudo apt-get install build-essential pkg-config autoconf automake libtool libusb-dev libusb-1.0-0-dev libhidapi-dev -y
sudo apt-get install python-pip -y
sudo apt-get install gcc-multilib -y
pip install pyserial -y

cd $RIOT_TMP
git clone git://git.code.sf.net/p/openocd/code openocd
cd openocd/
./bootstrap
./configure
make
sudo make install
cd $RIOT_TMP
wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2?product=GNU%20ARM%20Embedded%20Toolchain,64-bit,,Linux,6-2017-q2-update -O gcc.tar.bz2
mkdir ~/opt
tar -xf gcc.tar.bz2 -C ~/opt/
cd ~/opt/gcc-*
cd bin/
sudo su root -c 'echo "export PATH=\$PATH:$(pwd)" >> /etc/profile'
source /etc/profile && export PATH

echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"'     | sudo tee -a /etc/udev/rules.d/99-usb.rules
sudo service udev restart


cd $CURR_DIR
rm -rf $RIOT_TMP

cd $CURR_DIR/Tutorials/RIOT/examples/default
make BOARD=samr21-xpro all flash
sudo make BOARD=samr21-xpro term


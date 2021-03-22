#!/bin/bash

echo "Installing dependencies"

sudo apt-get install libopencv-dev libopencv-objdetect-dev libopencv-ts-dev libopencv-core-dev libgoogle-glog-dev whiptail
sudo cp /usr/lib/x86_64-linux-gnu/libglog.so /usr/local/lib/libglog.so

if (whiptail --title "Compile Boost?" --yesno "Do you want to download and compile Boost? This is neccessary, but takes quite some time" 8 78); then
	number_of_processors=$(cat /proc/cpuinfo | grep processor | wc -l)
	number_of_processors=$(whiptail --inputbox "How many parallel compiling threads do you want? I've looked at your CPU and found $number_of_processors processors. How many of them do you want to use? (The more, the faster)" 10 60 $number_of_processors --title "How many compile threads" 3>&1 1>&2 2>&3)

	wget https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz
	tar zxvf boost_1_64_0.tar.gz
	cd boost_1_64_0
	./bootstrap.sh --with-libraries=all --with-toolset=gcc
	sudo ./b2 install
	./bootstrap.sh 
	sudo ./b2 -j $number_of_processors
	cd ..
else
	echo "OK, not compiling boost"
fi



git clone https://github.com/NormanTUD/sky-detector.git
cd sky-detector
mkdir build
cd build
sudo cmake ..
sudo make -j

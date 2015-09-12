#! /bin/bash
# commands are expecting you to be logged in as root on raspberry pi running kali.
#
# Chris J. rattis@gmail.com / chrisj@rattis.net @rattis twitter crattis on git

# prep apt, and download needed files.
echo -e "\n"
echo "Downloading and installing triggerhappy and lau5.1 from Kali repositories"
echo -e "\n"
sleep 10
apt-get update
apt-get install -y triggerhappy lua5.1 

echo -e "\n"
echo "Downloading raspi config package from Debian repository, 2015-07-06_all version"
echo -e "\n"
sleep 10
wget http://archive.raspberrypi.org/debian/pool/main/r/raspi-config/raspi-config_20150706_all.deb

echo -e "\n"
echo "installing raspi-config debian package"
echo -e "\n"
sleep 10
dpkg -i raspi-config_20150706_all.deb

echo -e "\n"
echo -e "about to start raspi-config. 2 steps needed."
echo -e "First 1) Expand Filesystem."
echo -e "Second 3)Enable Boot to Desktop/Scratch chagne to commandline"
echo -e "Third select Finish and Reboot"
echo -e "\n"
sleep 10

raspi-config

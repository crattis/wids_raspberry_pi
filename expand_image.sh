!# /bin/bash
# commands are expecting you to be logged in as root on raspberry pi running kali.
#
# Chris J. rattis@gmail.com / chrisj@rattis.net @rattis twitter crattis on git

# prep apt, and download needed files.
echo "Downloading and installing triggerhappy and lau5.1 from Kali repositories"
apt-get update
apt-get install  -y triggerhappy lau5.1 

echo "Downloading raspi config package from Debian repository, 2015-07-06_all version"
wget http://archive.raspberrypi.org/debian/pool/main/r/raspi-config/raspi-config_20150706_all.deb

echo "installing raspi-config debian package"
dpkg -i raspi-config_20150706_all.deb
chmod 755 raspi-config

echo -e "about to start raspi-config. 2 steps needed. First 1) Expand Filesystem. \n Second 3)Enable Boot to Desktop/Scratch chagne to commandline"

sleep 10

./raspi-config

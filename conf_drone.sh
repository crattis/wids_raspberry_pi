#! /bin/bash
#
# File to download needed software and configure the raspberry pi 2
# as a kismet wireless drone. Run expand_image.sh first. apt-get upgrade
# is duplicated here command out of good practice. incase time between
# running the commands.
#
# assumes you are running this as root on Kali 2.0 on Raspberry Pi 2
# 
# Chris J. rattis@gmail.com / chrisj@rattis.net twitter: @rattis git: crattis

echo -e "\n"
echo -e "in a moment I will be asking you some configuration questions"
echo -e "at the very end I will prompt you to reboot"
echo -e "but first, we need to run apt-get".

# prep apt, and download needed files.
echo -e "\n"
echo "Updating repo info, and installing Kismet, NTP, and vim"
echo -e "\n"
apt-get install -y kismet ntp vim
ntpdate pool.ntp.org

# setting up hostname and networking
echo -e "\n"
echo -n "what is the name of this drone? "
read new_hostname

mv /etc/hostname /etc/hostname_orginal
mv /etc/hosts /etc/hosts_orginal

cat <<EOF > /etc/hostname
$new_hostname
EOF

cat <<EOF > /etc/hosts
127.0.0.1       $new_hostname    localhost
::1             localhost ip6-localhost ip6-loopback
fe00::0         ip6-localnet
ff00::0         ip6-mcastprefix
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
EOF

echo -n "What is your static ip address for this device? "
read new_ipaddress
echo -n "What is your netmask in dotted noation? "
read new_netmask

mv /etc/network/interfaces /etc/network/interfaces_orginal

cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
   address $new_ipaddress
   netmask $new_netmask
EOF

# setting up /etc/ksimet/kismet_drone.conf
echo -e "\n"
echo -e "Setting up the short Kismet Drone Configuration"
echo -e "\n"

mv /etc/kismet/kismet_drone.conf /etc/kismet/kismet_drone_orignal.conf
wireless_card=`ifconfig | awk '/wlan/ {print $1}'`a

echo -n "Enter drone server name: "
read drone_name
echo -n "Enter Kismet Server IP: "
read server_address

cat << EOF > /etc/kismet/kistmet_drone.conf
Servername=$drone_name
dronelisten=tcp://$new_ipaddress:2502
allowedhosts=$server_address
droneallowedhosts==127.0.0.1
dronemaxclients=10
droneringlen=65535
gps=false
ncsource=$wireless_card:type=ath5k
EOF

cat <<EOF >> /etc/rc.local
# start kistmet
 /usr/bin/kismet_drone --daemonize
exit 0
EOF

# Kali Raspberry Pi securiy clean-up.i
echo -e "\n"
echo -e "Last steps. Change the root password, and regenerate SSH keys"
echo -e "\n"
echo -n "Enter new root password: " | (passwd --stdin $USER)
echo -e "\n"
echo -e "changeing the ssh keys for security"
echo -e "\n"
rm /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server
service ssh restart

echo 
read -p "press [Enter] key  to reboot to your new Wifi Intrusion Detection System Drone"

reboot


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

echo -n "What is your static ip address for this devcie? "
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


# setting up /etc/kismet_drone.conf
echo -e "\n"
echo -e "Setting up Kismet Drone Configuration"
echo -e "\n"
mv /etc/kisment_drone.conf /etc/kismet_drone_orignal.conf
wireless_card=`ifconfig | awk '/wlan/ {print $1}'`

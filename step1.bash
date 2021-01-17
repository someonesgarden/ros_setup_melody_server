#!/bin/bash -exv

UBUNTU_VER=$(lsb_release -sc)
#ROS_VER=kinetic
ROS_VER=melodic

echo "deb http://packages.ros.org/ros/ubuntu $UBUNTU_VER main" > /tmp/$$-deb
sudo mv /tmp/$$-deb /etc/apt/sources.list.d/ros-latest.list

set +vx
while ! sudo apt-get install -y curl ; do
	echo '***WAITING TO GET A LOCK FOR APT...***'
	sleep 1
done
set -vx


curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add -
# curl -k https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo apt-key add -


sudo apt-get update || echo ""

sudo apt-get install -y ros-${ROS_VER}-ros-base

ls /etc/ros/rosdep/sources.list.d/20-default.list && sudo rm /etc/ros/rosdep/sources.list.d/20-default.list

sudo apt-get install -y python-pip


sudo pip-get install -U -y rosdep

sudo rosdep init 
rosdep update

sudo apt-get install -y python-rosinstall
sudo apt-get install -y build-essential

#[ "$ROS_VER" = "kinetic" ] && sudo apt-get install -y ros-${ROS_VER}-roslaunch

# grep -F "source /opt/ros/$ROS_VER/setup.bash" ~/.bashrc ||
echo "source /opt/ros/$ROS_VER/setup.bash" >> ~/.bashrc

# grep -F "ROS_MASTER_URI" ~/.bashrc ||
echo "export ROS_MASTER_URI=http://localhost:11311" >> ~/.bashrc

# grep -F "ROS_HOSTNAME" ~/.bashrc ||
echo "export ROS_HOSTNAME=localhost" >> ~/.bashrc


### instruction for user ###
set +xv

echo '***INSTRUCTION*****************'
echo '* do the following command    *'
echo '* $ source ~/.bashrc          *'
echo '* after that, try             *'
echo '* $ LANG=C roscore            *'
echo '*******************************'

source ~/.bashrc

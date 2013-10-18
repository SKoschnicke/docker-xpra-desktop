FROM ubuntu:latest
MAINTAINER Sven Koschnicke <sven@koschnicke.de>

# workaround problem with upstart not running
# see https://github.com/dotcloud/docker/issues/1024
# and https://github.com/dotcloud/docker/issues/1724
RUN apt-mark hold initscripts udev plymouth mountall
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# update system
RUN echo "deb http://de.archive.ubuntu.com/ubuntu precise main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://de.archive.ubuntu.com/ubuntu precise-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://de.archive.ubuntu.com/ubuntu precise-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://de.archive.ubuntu.com/ubuntu precise-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade

# add sources for TigerVNC
RUN apt-get -y install wget
RUN wget -O - http://winswitch.org/gpg.asc | apt-key add -
RUN echo "deb http://winswitch.org/ precise main" > /etc/apt/sources.list.d/winswitch.list
RUN apt-get update 

# Fake a fuse install
RUN apt-get install libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

ENV DEBIAN_FRONTEND noninteractive

# install VNC server and XFCE4 as desktop
RUN apt-get -y install tigervnc-server xfce4

# expose VNC port
# WARNING: ensure to firewall this port to deny access from outside
# if docker doesn't run on your local machine, you can tunnel the VNC-connection
# with SSH:
# > ssh <remote-machine> -N -L 10000:localhost:<exposed docker port>
# > vncviewer localhost:10000
EXPOSE 5901

CMD vncserver -fg -SecurityTypes None

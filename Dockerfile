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

# add sources for xpra
RUN apt-get -y install wget
RUN wget -O - http://winswitch.org/gpg.asc | apt-key add -
RUN echo "deb http://winswitch.org/ precise main" > /etc/apt/sources.list.d/winswitch.list
RUN apt-get update

ENV DEBIAN_FRONTEND noninteractive

# install xpra and apps
RUN apt-get -y install xpra xterm vim-gtk

# create user
RUN adduser --disabled-password --gecos "" sven

# expose xpra port
# WARNING: ensure to firewall this port to deny access from outside
# if docker doesn't run on your local machine, you can tunnel the connection
# with SSH:
# > ssh <remote-machine> -N -L 10000:localhost:<exposed docker port>
# > xpra attach tcp:localhost:10000
EXPOSE 10000

CMD xpra start :100 --no-daemon --start-child=xterm --bind-tcp=0.0.0.0:10000

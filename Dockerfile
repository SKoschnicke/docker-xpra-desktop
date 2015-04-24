FROM ubuntu:precise
MAINTAINER Sven Koschnicke <sven@koschnicke.de>

ENV DEBIAN_FRONTEND noninteractive

# add sources for xpra
RUN apt-get -y install wget
RUN wget -O - http://winswitch.org/gpg.asc | apt-key add -
RUN echo "deb http://winswitch.org/ precise main" > /etc/apt/sources.list.d/winswitch.list
RUN apt-get update


# install xpra and apps
RUN apt-get -y install xpra xterm vim-gtk

# create user
RUN adduser --disabled-password --gecos "" dockerx

ADD start.sh /usr/bin/start.sh

EXPOSE 10000

CMD /usr/bin/start.sh
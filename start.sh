#!/bin/sh
echo "you can connect to the graphical session using:"
echo "> xpra attach tcp:localhost:10000"
echo "if the container doesn't run on you local machine, you can tunnel the connection:"
echo "> xpra attach hostname:10000"

xpra start :100 --no-daemon --start-child=xterm --bind-tcp=0.0.0.0:10000

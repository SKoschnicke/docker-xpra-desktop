#/bin/bash
# needs bash 4.x
CONTAINER_ID=$(docker run -d -p 10000 xpra-desktop)
PORT=$(docker port $CONTAINER_ID 10000 | awk -F : '{print $2}')
echo "container startet, you may connect with xpra attach tcp:localhost:$PORT"
read -r -p "Do you want to connect now (you need xpra installed)? [y/N]" response
response=${response,,} # tolower
if [[ $response =~ ^(yes|y)$ ]]
then
  xpra attach tcp:localhost:$PORT
else
  echo "kthxbye"
fi

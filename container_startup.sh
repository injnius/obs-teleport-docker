#!/bin/bash
OUR_IP=$(hostname -i)

# set the global.ini config file for OBS
#Backup global.ini
cp global.ini global.ini.bak
#Set First Run to False
sed --regexp-extended "s/(FirstRun=)\w+/FirstRun=$OBS_FirstRun/gm" global.ini > global.ini.new
mv global.ini.new global.ini
# Disable WebSockets server
sed --regexp-extended "s/(ServerEnabled=)\w+/ServerEnabled=$OBS_ServerEnabled/gm" global.ini > global.ini.new
mv global.ini.new global.ini
## Set Auth
sed --regexp-extended "s/(AuthRequired=)\w+/AuthRequired=$OBS_AuthRequired/gm" global.ini > global.ini.new
mv global.ini.new global.ini
## Set Server Password
sed --regexp-extended "s/(ServerPassword=)\w+/ServerPassword=$OBS_ServerPassword/gm" global.ini > global.ini.new
mv global.ini.new global.ini
## Set Server Port
sed --regexp-extended "s/(ServerPort=)\w+/ServerPort=$OBS_ServerPort/gm" global.ini > global.ini.new
mv global.ini.new global.ini
## Enable/Disable Alerts
sed --regexp-extended "s/(AlertsEnabled=)\w+/AlertsEnabled=$OBS_AlertsEnabled/gm" global.ini > global.ini.new
mv global.ini.new global.ini


# start VNC server (Uses VNC_PASSWD Docker ENV variable)
mkdir -p $HOME/.vnc && echo "$VNC_PASSWD" | vncpasswd -f > $HOME/.vnc/passwd
vncserver :0 -localhost no -nolisten -rfbauth $HOME/.vnc/passwd -xstartup /opt/x11vnc_entrypoint.sh
# start noVNC web server
/opt/noVNC/utils/novnc_proxy --listen 5901 &

echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with $OUR_IP:5900"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://$OUR_IP:5901/?password=$VNC_PASSWD\n"

if [ -z "$1" ]; then
  tail -f /dev/null
else
  # unknown option ==> call command
  echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
  echo "Executing command: '$@'"
  exec $@
fi

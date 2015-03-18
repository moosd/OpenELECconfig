#!/bin/bash
/usr/sbin/sshd -f /storage/.config/sshd_config

keepalive() {
while true; do
#    [[ `pgrep -f kodi` ]] && {
#        sleep 10
#    } || {
        killall nc
        nc -u -l -p 9876 -e /storage/.config/startkodi.sh
#    }
done
}

systemctl stop kodi
keepalive &
/storage/.config/startkodi.sh

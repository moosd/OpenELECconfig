#!/bin/bash
killall -KILL kodi.bin
/usr/lib/kodi/kodi.bin --standalone -fs --lircdev /run/lirc/lircd &

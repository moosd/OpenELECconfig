# OpenELECconfig
Config stored in /storage/.config on my openelec install. All of these fixes can be applied without altering the base image so yay, auto updates will be fine! :)

## What does it do?
I have OpenELEC installed on one of my Raspberry Pis which is connected to the TV. Hooray, I finally have a HTPC! I decided to go with OpenELEC and encountered a few minor issues. Now, I get that it's not meant to be secure but I'm not asking for a military grade install when I don't want randomers to push their own kernel image and system image remotely with no authentication...

 - Anyone can push unsigned updates over a public samba
 - Anyone can log in as root over ssh
 - ssh keys kept getting refused when I tried them
 - I can't use an android remote to actually turn the TV on and off! Why am I forced to use several remotes in 2015?

So I have addressed each of these issues in the config. If you push it to /storage/.config and copy over your ssh key to /storage/.ssh/authorized_keys2

## Fixing samba
Note: To push manual updates, you will need to use scp instead of samba to copy the tar files to /storage/.update/ - no big deal.
1. I used a custom samba.conf which the openelec system reecognised, this basically comments out potentially troublesome samba shares that most people won't need anyway. I certainly don't.
2. Next,from v5+, the NOOBS partitions get automounted. Why is a RECOVERY share accessible as a writable share over samba??? This was fixed by editing udev rules.

## Fixing ssh
1. I turned off ssh access in the settings. This is so that I can use my own config file.
2. Start sshd using own config from autostart.sh
3. Crucially, a bug in openelec was that /storage is set up with all the wrong permissions. It took forever to realise that sshd was throwing up this error that /storage needed not have group write permissions. Changing this will probably get reset on a reboot (since / is mounted in a loop filesystem). So the custom config just disables the strict checking of these permissions.
4. Now I had an ssh server running that would authenticate me before blindly replacing its own kernel :)

Now I had a reasonably secure HTPC install! To make it even better...

##  Fixing CEC
CEC is the protocol used by Kodi to talk to the TV over HDMI. I noticed that telling Kodi to quit would turn off the TV, while not letting me restart it any further. And sometimes, it would just turn the tv back on again! No consistancy here... A little more digging and it turns out that systemd is set to autorestart kodi when it exits, and sometimes it hangs, while at other times it starts up but the TV ignores the CEC signal.

So here, I relieve kodi from systemd control and autostart.sh to launch a thing that starts kodi, allows it to die, and listens on a udp port for a wake-on-lan effect. I added a smali bit of code into the remote app to send a short packet to this udp port when my remote tries to send a wake on lan. I tried to get the wake-on-lan port but it did not work for some reason, and it was 3am so I wanted to get this done quickly. There are probably better solutions, but this now does what I need. :)

1. Get rid of systemd's autorestart
2. Start up kodi
3. When kodi quits, don't autorestart it (turns tv off)
4. When receiving a udp packet on a certain port, start up kodi (turns tv on)

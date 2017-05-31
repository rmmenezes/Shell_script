#!/bin/bash

##sublimeText
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update 
sudo apt-get install sublime-text-installer

#Spotfy
wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/mopidy.list
sudo apt-get update
sudo apt-get install -y libportaudio2 libspotify12 --no-install-recommends
wget https://github.com/fabiofalci/sconsify/releases/download/next-20170213/linux-x86_64-sconsify-0.5.0-next.zip -O sconsify.zip
sudo unzip sconsify.zip -d /usr/local/bin/

#Codeblocks
sudo apt-get install xterm
sudo apt-get install codeblocks

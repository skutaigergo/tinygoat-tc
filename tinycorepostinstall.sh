#!/bin/sh

# Function to install OpenSSH, SSHfs, and SSHPass
install_ssh() {
    echo 'Install OpenSSH, SSHfs and SSHPass'
    tce-load -wi openssh sshfs sshpass

    # Copy configuration files, start service, add to bootlocal and filetool.lst
    cd /usr/local/etc/ssh
    sudo cp ssh_config.orig ssh_config
    sudo cp sshd_config.orig sshd_config
    sudo /usr/local/etc/init.d/openssh start
    echo "usr/local/etc/init.d/openssh start" >> /opt/bootlocal.sh
    echo "usr/local/etc" >> /opt/.filetool.lst
    echo "etc/passwd" >> /opt/.filetool.lst
    echo "etc/shadow" >> /opt/.filetool.lst
    cd
    filetool.sh -b
}

# Function to install ALSA and additional sound-related configurations
install_alsa() {
    echo 'Install ALSA (Advanced Linux Sound Architecture)'
    tce-load -wi alsa alsa-config
    alsactl init

    echo 'Quick sound test'
    speaker-test -c2 -t wav -l1

    # Store ALSA settings and add to bootlocal and filetool.lst
    sudo alsactl store
    echo "alsactl restore" >> /opt/bootlocal.sh
    echo "usr/local/etc/alsa/asound.state" >> /opt/.filetool.lst
    filetool.sh -b
}

# Function to install additional software
install_additional_software() {
    echo 'Install additional software'
    tce-load -wi wget rsync screen mc emelfm2 imagemagick xmms vlc3 filezilla palemoon
}

# Function to copy backgrounds
install_backgrounds() {
	echo 'Copy backgrounds to backgrounds folder'
	cp ./backgrounds/* /opt/backgrounds/
{

clear
# Main menu
echo 'Choose an option:'
echo '1. Install OpenSSH, SSHfs, and SSHPass'
echo '2. Install ALSA (Advanced Linux Sound Architecture)'
echo '3. Install additional software'
echo '4. Copy cutie goat backgrounds'
echo '9. Install all'

read choice

case $choice in
    1) install_ssh;;
    2) install_alsa;;
    3) install_additional_software;;
	4) install_backgrounds;;
    9) 
        install_ssh
        install_alsa
        install_additional_software
		install_backgrounds
        ;;
    *) echo 'Invalid choice';;
esac

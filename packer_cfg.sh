#!/bin/bash
clear

function menu() {
SEL=$(whiptail --title "AutomationPro - Hashicorp Assistant" --menu "Choose an option" 8 78 0 \
   "1" "Install Packer 1.6.2" \
   "2" "Exit" 3>&1 1>&2 2>&3)

case $SEL in
   1)
	CheckSystemRequirements
	CreateRequiredFolders
	DownloadPacker
	ExtractPacker
	Cleanup
	CloneAutomationProPackerGithubPublicRepo
        whiptail --title "Automationpro Configurator" --msgbox "Configuration is complete. For more information please check the github repository and/or its' WIKI" 8 78 0
   ;;
   2)
        exit
   ;;
esac
}

function CheckSystemRequirements() {
  { echo -e "XXX\n0\nInstalling wget via yum\nXXX"
     yum install wget -y
     echo -e "XXX\n25\nInstalling unzip via yum\nXXX"
     yum install unzip -y
     echo -e "XXX\n50\nInstalling nano via yum\nXXX"
     yum install nano -y
     echo -e "XXX\n75\nInstalling git via yum\nXXX"
     yum install git -y
     sleep 2s
  } | whiptail --gauge "Installing any missing requirements" --title "Automationpro Configurator" 8 78 0
}

function CreateRequiredFolders() {
  { echo -e "XXX\n0\nFolders in path '/usr/local/bin/hashicorp/packer162'\nXXX"
     mkdir -p /usr/local/bin/hashicorp/packer162
     sleep 2s
  } | whiptail --gauge "Creating any missing [required] folders" --title "Automationpro Configurator" 8 78 0
}

function DownloadPacker() {
   URL="https://releases.hashicorp.com/packer/1.6.2/packer_1.6.2_linux_amd64.zip"
   wget -P /usr/local/bin/hashicorp/packer162 "$URL" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading packer_1.6.2_linux_amd64.zip" --title "Automationpro Configurator" 8 78 0
}

function ExtractPacker() {
   (pv -n /usr/local/bin/hasicorp/packer162/packer_1.6.2_linux_amd64.zip | unzip /usr/local/bin/hashicorp/packer162/packer_1.6.2_linux_amd64.zip -d /usr/local/bin/hashicorp/packer162/ ) 2>&1 | whiptail --gauge "Extracting packer_1.6.2_linux_amd64.zip" --title "Automationpro Configurator" 8 78 0
}

function Cleanup() {
       rm -r -f /usr/local/bin/hashicorp/packer162/packer_1.6.2_linux_amd64.zip
       sleep 2s | whiptail --gauge "Removing packer_1.6.2_linux_amd64.zip archive" --title "Automationpro Configurator" 8 78 0
}


function CloneAutomationProPackerGithubPublicRepo() {
   git clone https://github.com/pauledavey/AutomationPro_Hashicorp.git /usr/local/bin/hashicorp/automationpro > /dev/null 2>&1 |
   stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' |
   whiptail --gauge "Cloning AutomationPro Packer Github repository" --title "Automationpro Configurator" 8 78 0
}

echo "Making magic.. please wait.."
cd /tmp
wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/pv-1.4.6-1.el7.x86_64.rpm
rpm -Uvh *rpm
clear
menu

#!/bin/bash
clear

function menu() {
SEL=$(whiptail --title "AutomationPro - Hashicorp Assistant" --menu "Choose an option" 8 78 0 \
   "1" "Install Packer 1.6.2" \
   "2" "Install Vault 1.5.3" \
   "3" "Clone AutomationPro Hashicorp Public Repo" \
   "4" "Exit" 3>&1 1>&2 2>&3)

case $SEL in
   1)
	CheckSystemRequirements
	CreateRequiredPackerFolders
	DownloadPacker
	ExtractPacker
	CleanupPacker
	whiptail --title "Automationpro Configurator" --msgbox "Configuration is complete. For more information please check the github repository and/or its' WIKI" 8 78 0
   ;;
   2)
        InstallVault
   ;;
   3)
        CloneAutomationProPackerGithubPublicRepo
   ;;
   4)
        exit
   ;;
esac
}

######### Common
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


function InstallVault() {
    DownloadVault
    UnzipVault
    CreateVaultFolders
    DownloadConfigJson
    EditConfigJsonFile
    ConfigureVaultExports
    CreateVaultServiceFile
    StartVaultService
    EnableForBootup
    InitiateVaultServer
}

#########VAULT
function DownloadVault() {
  VAULTURL="https://releases.hashicorp.com/vault/1.5.3/vault_1.5.3_linux_amd64.zip"
  wget -P /tmp/ "$VAULTURL" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading vault_1.5.3_linux_amd64.zip" --title "Automationpro Configurator" 8 78 0
}

function UnzipVault() {
  (pv -n /tmp/vault_1.5.3_linux_amd64.zip | unzip /tmp/vault_1.5.3_linux_amd64.zip -d /usr/bin/ ) 2>&1 | whiptail --gauge "Extracting vault_1.5.3_linux_amd64.zip" --title "Automationpro Configurator" 8 78 0
}

function CreateVaultFolders() {
   { echo -e "XXX\n0\nCreating /etc/vault\nXXX"
     mkdir /etc/vault
     echo -e "XXX\n25\nCreating /vault-data\nXXX"
     mkdir /vault-data
     echo -e "XXX\n50\n/logs/vault/\nXXX"
     mkdir -p /logs/vault/
     sleep 2s
  } | whiptail --gauge "Creating required folders" --title "Automationpro Configurator" 8 78 0
}

function DownloadConfigJson() {
  VAULTCFG="https://raw.githubusercontent.com/pauledavey/AutomationPro_Hashicorp/master/config.json"
  wget -P /etc/vault/ "$VAULTCFG" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading config.json file" --title "Automationpro Configurator" 8 78 0
}

function EditConfigJsonFile() {
  sed -i "s/<IPADDRESS>/$(hostname -I|awk '{print $1}')/g" /etc/vault/config.json
}

function ConfigureVaultExports() {
  export VAULT_ADDR='http://$(hostname -I):8200'
  echo "export VAULT_ADDR=http://$(hostname -I|awk '{print $1}'):8200" >> ~/.bashrc
}

function CreateVaultServiceFile() {
  VAULTSERVICE="https://raw.githubusercontent.com/pauledavey/AutomationPro_Hashicorp/master/vault.service"
  wget -P /etc/systemd/system/ "$VAULTSERVICE" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading config.json file" --title "Automationpro Configurator" 8 78 0
}

function StartVaultService() {
  systemctl start vault.service
}

function EnableForBootup() {
  systemctl enable vault.service
}

function InitiateVaultServer() {
  vault operator init > /tmp/init.file
}

############ Packer
function CreateRequiredPackerFolders() {
  { echo -e "XXX\n0\nFolders in path '/usr/local/bin/hashicorp/packer162'\nXXX"
     mkdir -p /usr/local/bin/hashicorp/packer162
     sleep 2s
  } | whiptail --gauge "Creating any missing [required] folders" --title "Automationpro Configurator" 8 78 0
}

function DownloadPacker() {
   PACKERURL="https://releases.hashicorp.com/packer/1.6.2/packer_1.6.2_linux_amd64.zip"
   wget -P /usr/local/bin/hashicorp/packer162 "$URL" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading packer_1.6.2_linux_amd64.zip" --title "Automationpro Configurator" 8 78 0
}

function ExtractPacker() {
   (pv -n /usr/local/bin/hasicorp/packer162/packer_1.6.2_linux_amd64.zip | unzip /usr/local/bin/hashicorp/packer162/packer_1.6.2_linux_amd64.zip -d /usr/local/bin/hashicorp/packer162/ ) 2>&1 | whiptail --gauge "Extracting packer_1.6.2_linux_amd64.zip" --title "Automationpro Configurator" 8 78 0
}

function CleanupPacker() {
       rm -r -f /usr/local/bin/hashicorp/packer162/packer_1.6.2_linux_amd64.zip
       sleep 2s | whiptail --gauge "Removing packer_1.6.2_linux_amd64.zip archive" --title "Automationpro Configurator" 8 78 0
}

function CleanupVault() {
       rm -r -f /usr/local/bin/hashicorp/vault153/vault_1.5.3_linux_amd64.zip
       sleep 2s | whiptail --gauge "Removing vault_1.5.3_linux_amd64.zip archive" --title "Automationpro Configurator" 8 78 0
}

## Github Clone Option
function CloneAutomationProPackerGithubPublicRepo() {
   git clone https://github.com/pauledavey/AutomationPro_Hashicorp.git /usr/local/bin/hashicorp/automationpro > /dev/null 2>&1 |
   stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' |
   whiptail --gauge "Cloning AutomationPro Packer Github repository" --title "Automationpro Configurator" 8 78 0
}


#### 
echo "Making magic.. please wait.."
cd /tmp
wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/pv-1.4.6-1.el7.x86_64.rpm
rpm -Uvh *rpm
clear
menu
clear
systemctl status vault





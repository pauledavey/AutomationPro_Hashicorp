#!/bin/bash
clear

# URLs
PACKERURL="https://releases.hashicorp.com/packer/1.6.2/packer_1.6.2_linux_amd64.zip"
VAULTURL="https://releases.hashicorp.com/vault/1.5.3/vault_1.5.3_linux_amd64.zip"
VAULTCFG="https://raw.githubusercontent.com/pauledavey/AutomationPro_Hashicorp/master/vaultSetup/config.json"
VAULTSERVICE="https://raw.githubusercontent.com/pauledavey/AutomationPro_Hashicorp/master/vaultSetup/vault.service"

function menu() {
SEL=$(whiptail --title "AutomationPro - Hashicorp Assistant" --menu "Choose an option" 8 78 0 \
   "1" "Install Packer 1.6.2" \
   "2" "Install Vault 1.5.3" \
   "3" "Install Packer 1.6.2 & Vault 1.5.3" \
   "4" "Clone AutomationPro Hashicorp Public Repo" \
   "5" "Exit" 3>&1 1>&2 2>&3)

case $SEL in
   1)
	InstallPacker
   ;;
   2)
        InstallVault
   ;;
   3)
        InstallPacker
	      InstallVault
   ;;
   4)
        CloneAutomationProPackerGithubPublicRepo
   ;;
   5)
        exit
   ;;
esac
}

function InstallPacker() {
    DownloadPacker
    UnzipPacker
    CleanupPacker
}

#########PACKER
function DownloadPacker() {
  wget -P /tmp/ "$PACKERURL" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading packer_1.6.2_linux_amd64.zip" --title "AutomationPro - Hashicorp Assistant" 8 78 0
}

function UnzipPacker() {
  (pv -n /tmp/packer_1.6.2_linux_amd64.zip | unzip /tmp/packer_1.6.2_linux_amd64.zip -d /usr/bin/ ) 2>&1 | whiptail --gauge "Extracting packer_1.6.2_linux_amd64.zip" --title "AutomationPro - Hashicorp Assistant" 8 78 0
}

function CleanupPacker() {
       rm -r -f /tmp/packer_1.6.2_linux_amd64.zip
       sleep 2s | whiptail --gauge "Removing packer_1.6.2_linux_amd64.zip archive" --title "AutomationPro - Hashicorp Assistant" 8 78 0
}

function InstallVault() {
    firewall-cmd --permanent --add-port=8200/tcp
    firewall-cmd --reload
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

    # tell user where things are
    echo "Your Hashicorp Vault is running. It should NOT be used in Production"
    echo "This utility is designed to help you setup lab environments with a basic configuration"
    echo "In the following file is the information you need to unseal your vault and start using it - tmp/init.file"
    echo "You can access the web interface for vault by pointing your browser at http://$(hostname -I|awk '{print $1}'):8200/ui"
    echo "You should probably consider sorting our ssl and https access next!"
    echo ""
}

#########VAULT
function DownloadVault() {
  wget -P /tmp/ "$VAULTURL" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading vault_1.5.3_linux_amd64.zip" --title "AutomationPro - Hashicorp Assistant" 8 78 0
}

function UnzipVault() {
  (pv -n /tmp/vault_1.5.3_linux_amd64.zip | unzip /tmp/vault_1.5.3_linux_amd64.zip -d /usr/bin/ ) 2>&1 | whiptail --gauge "Extracting vault_1.5.3_linux_amd64.zip" --title "AutomationPro - Hashicorp Assistant" 8 78 0
}

function CreateVaultFolders() {
   { echo -e "XXX\n0\nCreating /etc/vault\nXXX"
     mkdir /etc/vault
     echo -e "XXX\n25\nCreating /vault-data\nXXX"
     mkdir /vault-data
     echo -e "XXX\n50\n/logs/vault/\nXXX"
     mkdir -p /logs/vault/
     sleep 2s
  } | whiptail --gauge "Creating required folders" --title "AutomationPro - Hashicorp Assistant" 8 78 0
}

function DownloadConfigJson() {
  wget -P /etc/vault/ "$VAULTCFG" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading config.json file" --title "AutomationPro - Hashicorp Assistant" 8 78 0
}

function EditConfigJsonFile() {
  sed -i "s/<IPADDRESS>/$(hostname -I|awk '{print $1}')/g" /etc/vault/config.json
}

function ConfigureVaultExports() {
  export VAULT_ADDR="http://$(hostname -I|awk '{print $1}'):8200"
  echo 'export VAULT_ADDR="http://$(hostname -I|awk '{print $1}'):8200" >> ~/.bashrc'
}

function CreateVaultServiceFile() {
  wget -P /etc/systemd/system/ "$VAULTSERVICE" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading config.json file" --title "AutomationPro - Hashicorp Assistant" 8 78 0
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

function CleanupVault() {
       rm -r -f /usr/local/bin/hashicorp/vault153/vault_1.5.3_linux_amd64.zip
       sleep 2s | whiptail --gauge "Removing vault_1.5.3_linux_amd64.zip archive" --title "AutomationPro - Hashicorp Assistant" 8 78 0
}

######### Github Clone Option
function CloneAutomationProPackerGithubPublicRepo() {
   mkdir --parent /home/git
   git clone https://github.com/pauledavey/AutomationPro_Hashicorp.git /home/git > /dev/null 2>&1 |
   stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' |
   whiptail --gauge "Cloning AutomationPro_Hasicorp Repository" --title "AutomationPro - Hashicorp Assistant" 8 78 0

   # tell user where things are
    echo "The Automationpro_Hashiscorp Repository has been cloned to /home/git/"
}


#### 
clear
echo "Making magic.. please wait.."
yum install wget -y
yum install unzip -y
yum install nano -y
yum install git -y
cd /tmp
wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/pv-1.4.6-1.el7.x86_64.rpm
rpm -Uvh *rpm
menu

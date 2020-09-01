#!/bin/bash
clear

VAULTURL="https://releases.hashicorp.com/vault/1.5.3/vault_1.5.3_linux_amd64.zip"
wget -P /tmp/ "$VAULTURL" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p'
unzip /tmp/vault_1.5.3_linux_amd64.zip -d /usr/bin/
mkdir /etc/vault
mkdir /vault-data
mkdir -p /logs/vault/
VAULTCFG="https://raw.githubusercontent.com/pauledavey/AutomationPro_Hashicorp/master/config.json"
wget -P /etc/vault/ "$VAULTCFG" 2>&1
sed -i "s/<IPADDRESS>/$(hostname -I)/g" /etc/vault/config.json
export VAULT_ADDR='http://$(hostname -I):8200'
VAULTSERVICE="https://raw.githubusercontent.com/pauledavey/AutomationPro_Hashicorp/master/vault.service"
wget -P /etc/systemd/system/vault.service "$VAULTSERVICE" 2>&1
systemctl start vault.service
systemctl enable vault.service
vault operator init

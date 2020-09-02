#!/bin/bash
clear

echo "Executing Windows Server 2019 build utilising Packer & Vault"
/usr/bin/packer build -var-file=../packerRepo/win2019.base/win2019.vars ../packerRepo/win2019.base/win2019.base.json

# AutomationPro Hashicorp Repository
This repository contains helpers and examples as per documented at http://automationpro.co.uk relating to Hashicorp products.

To get started
1. Build a Centos 7 machine (virtual or otherwise)
2. Login and navigate to your home folder. Choose an option to follow below. Both will give you the same result

#Option 1
3a. Download the packer_cfg.sh script using the following command
     curl https://raw.githubusercontent.com/pauledavey/AutomationPro_Hashicorp/master/packer_cfg.sh -o packer_cfg.sh
4a. Make sure the file is executable, by running the following command
     chmod +x packer_cfg.sh
5a. Execute the script using the command below. Make your choices from the menu, then kick back and relax until it completes
     ./packer_cfg.sh

#Option 2
3b. Run the script direct from the github repository, by executing the following command. Kick back and relax until it completes
     bash <(curl -s https://raw.githubusercontent.com/pauledavey/AutomationPro_Hashicorp/master/packer_cfg.sh)

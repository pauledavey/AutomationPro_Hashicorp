#!/bin/bash
#-----------------------------------------------------------------
# The spinner in this script:
#   Copyright of KatworX© Tech. Developed by Arjun Singh Kathait
#   and Debugged by the Stack Overflow Community
#-----------------------------------------------------------------

spinner() {
    local PROC="$1"
    local str="${2:-'Copyright of KatworX© Tech. Developed by Arjun Singh Kathait and Debugged by the ?Stack Overflow Community?'}"
    local delay="0.1"
    tput civis  # hide cursor
    printf "\033[1;34m"
    while [ -d /proc/$PROC ]; do
        printf '\033[s\033[u[ / ] %s\033[u' "$str"; sleep "$delay"
        printf '\033[s\033[u[ — ] %s\033[u' "$str"; sleep "$delay"
        printf '\033[s\033[u[ \ ] %s\033[u' "$str"; sleep "$delay"
        printf '\033[s\033[u[ | ] %s\033[u' "$str"; sleep "$delay"
    done
    printf '\033[s\033[u%*s\033[u\033[0m' $((${#str}+6)) " "  # return to normal
    tput cnorm  # restore cursor
    return 0
}
clear
echo "AutomationPro Packer Install & Config Script"
echo "--------------------------------------------"

sleep 3 & spinner $! "Install wget, nano, git & unzip"
sudo yum install wget nano unzip -y > /dev/null 2>&1

sleep 3 & spinner $! "Updating OS and components"
sudo yum update -y > /dev/null 2>&1

sleep 3 & spinner $! "Create the /usr/bin/hashicorp folder"
mkdir -p /usr/local/bin/hashicorp > /dev/null 2>&1

sleep 3 & spinner $! "Create the /usr/bin/hashicorp/packer folder"
mkdir -p /usr/local/bin/hashicorp/packer > /dev/null 2>&1

sleep 3 & spinner $! "Navigate to directory"
cd /usr/local/bin/hashicorp/packer > /dev/null 2>&1

sleep 3 & spinner $! "Download Packer [version 1.6.2]"
wget https://releases.hashicorp.com/packer/1.6.2/packer_1.6.2_linux_amd64.zip > /dev/null 2>&1

sleep 3 & spinner $! "Extract Packer from zip file"
unzip packer_1.6.2_linux_amd64.zip > /dev/null 2>&1

sleep 3 & spinner $! "Removing zip file"
rm -f packer_1.6.2_linux_amd64.zip > /dev/null 2>&1

sleep 3 & spinner $! "Confirm correct version of Hashicorp Packer is installed"
packerversion=$(/usr/local/bin/hashicorp/packer/packer --version) > /dev/null 2>&1

if [ "$packerversion" == "1.6.2" ]; then
	sleep 3 & spinner $! "Packer [version 1.6.2] install. They call it a Royale with cheese..."
else
    echo -e "...Houston, we have a problem.." \e[101mLight red
    echo -e "Packer version is $packerversion, expected version 1.6.2" \e[101mLight red
    exit 1
fi

sleep 3 & spinner $! "Cloning Automationpro public packer github repo"
cd /usr/local/bin/hashicorp/packer > /dev/null 2>&1
git clone https://github.com/pauledavey/AutomationPro_Packer.git > /dev/null 2>&1
echo "Operation(s) Complete. You're welcome. Roadhouse.."
echo "--------------------------------------------"


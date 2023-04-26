#!/bin/bash
#Config environment for smartcontract on financial instruments
clear
echo '' 
echo '******************************** CONFIG ENVIRONMENT FOR SMART CONTRACT FOR FINANCIAL INSTRUMENT *********************************************************'
echo ''

WORK_SPACE="$1"
PROJECT_NAME='venom-financial-instruments'
PROJECT_NAME_INSTRUMENT="$2"
function usage()
{
  echo ''
  echo 'Usage: ./000_config_venom_environment.sh "$WORK_SPACE" "PROJECT_NAME_INSTRUMENT"'
  echo "Brief: install and config doker, node, yarn, npm, locklift and wokspace at default $WORK_SPACE/$PROJECT_NAME"
  echo ' 1.# chmod a+x 000_config_venom_environment.sh'
  echo ' 2.# WORK_SPACE="/mnt/usb/venon/venom-financial-instruments' #work space should have the word venom-financial-instruments
  echo ' 4.# PROJECT_NAME_INSTRUMENT="companyShares"'
  echo ' 3.# ./000_config_venom_environment.sh "$WORK_SPACE" "$PROJECT_NAME_INSTRUMENT"'
  echo '' 
}

echo "executing... ./000_config_venom_environment.sh \"$WORK_SPACE\" \"$PROJECT_NAME_INSTRUMENT\""

if ! [[ "${WORK_SPACE}" =~ .*"${PROJECT_NAME}".* ]] ; then 
  echo "Error: I need a work space to build project $PROJECT_NAME with $PROJECT_NAME in path"
  echo "       eq. WORK_SPACE/$PROJECT_NAME/companyShares"
  usage
  exit 1
fi

if [ -z "${WORK_SPACE}" ]; then 
  echo "Error: I need a work space to build project $PROJECT_NAME"
  echo "       eq. WORK_SPACE/$PROJECT_NAME/companyShares"
  usage
  exit 1
fi
if [ -d "$WORK_SPACE/$PROJECT_NAME_INSTRUMENT" ]; then
  echo "Error: The project exists. If you want to update. It is recommended to use an auxiliary worksapace and update to the new code from there to prevent applyng changes to existing code."
  usage
  exit 1
fi
#Install require packages
sudo apt update
#sudo apt upgrade 
sudo apt install gcc g++ make tree
sudo apt install ca-certificates curl gnupg
#config Docker
if ! [[ $(docker --version) =~ '23.'.* ]]; then 
 #sudo apt purge docker docker-engine docker.io containerd runc
 curl -fsSL https://get.docker.com -o get-docker.sh
 sudo chmod a+x get-docker.sh
 #sudo sh ./get-docker.sh --dry-run
 sudo sh ./get-docker.sh 
 #sudo rm get-docker.sh
fi


#Config Node
if ! [[ $(node -v) =~ 'v19'.* ]]; then 
 curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - && sudo apt install -y nodejs
fi

#Install Yarn package managet
if ! [[ $(yarn -v) =~ '1.22.'.* ]]; then 
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update && sudo apt install yarn
  yarn -V
fi

#Setting up the venom smart contract development environment
sudo npm install -g locklift
if ! [ -d  "$workSpace/${PROJECT_NAME_INSTRUMENT}" ]; then 
  echo "Initial project ......"
  sudo locklift init --path ${HOME}/$WORK_SPACE/${PROJECT_NAME_INSTRUMENT}
fi


echo "SUMMARY________________________________"
echo " node -v ..................: $(node -v)"
echo " yarn -v ..................: $(yarn -v)"
echo " npm -v  ..................: $(npm -v) "
echo " docker --version .........: $(docker --version )"
echo " locklift --version........: $(locklift --version)"
echo " PAHT TO PROJECT...........: cd ${HOME}/$WORK_SPACE/${PROJECT_NAME_INSTRUMENT}"
echo " Tree project..............: tree --gitignore ${HOME}/$WORK_SPACE/${PROJECT_NAME_INSTRUMENT}"
echo "_______________________________________"
echo " "
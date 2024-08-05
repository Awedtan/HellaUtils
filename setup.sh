#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y git curl chromium
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
sleep 5
source ~/.bashrc
export NVM_DIR=$HOME/.nvm;
source $NVM_DIR/nvm.sh;
nvm install 18.19.1
npm install -g pm2 ts-node
git clone https://github.com/Awedtan/HellaBot.git
git clone https://github.com/Awedtan/HellaAPI.git
(cd HellaBot && npm i)
#node node_modules/puppeteer/install.mjs
(cd ../HellaAPI && npm i)
echo "Setup complete!"
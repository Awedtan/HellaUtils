#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y git curl chromium
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
sleep 5
source ~/.bashrc
export NVM_DIR=$HOME/.nvm;
source $NVM_DIR/nvm.sh;
nvm install 18
npm install -g pm2 ts-node
git clone https://github.com/Awedtan/HellaBot.git
cd HellaBot
npm install --save
node node_modules/puppeteer/install.js
ls

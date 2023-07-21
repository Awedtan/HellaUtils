#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y git curl chromium
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.bashrc
source ~/.bashrc
source ~/.bashrc
nvm install 18
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
npm install -g pm2 ts-node
git clone https://github.com/Awedtan/HellaBot.git
cd HellaBot
npm install --save
node node_modules/puppeteer/install.js
git clone https://github.com/Kengxxiao/ArknightsGameData.git
ls

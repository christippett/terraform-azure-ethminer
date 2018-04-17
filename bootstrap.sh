#!/bin/bash
set +ex

# Install NVIDIA GPU drivers on N-series VMs running Linux
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/n-series-driver-setup
CUDA_REPO_PKG=cuda-repo-ubuntu1604_9.1.85-1_amd64.deb
wget -O /tmp/${CUDA_REPO_PKG} http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/${CUDA_REPO_PKG}
sudo dpkg -i /tmp/${CUDA_REPO_PKG}
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
rm -f /tmp/${CUDA_REPO_PKG}

# Install software dependencies
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo add-apt-repository -y ppa:ethereum/ethereum-dev
sudo apt-get update
sudo apt-get install software-properties-common supervisor cuda-drivers ethereum screen htop -y

# Download and install Ethminer
wget -O /tmp/ethminer.tar.gz https://github.com/ethereum-mining/ethminer/releases/download/v0.13.0rc7/ethminer-0.13.0rc7-Linux.tar.gz
mkdir -p /tmp/ethminer
tar -xzf /tmp/ethminer.tar.gz -C /tmp/ethminer
sudo chmod a+x /tmp/ethminer/bin/ethminer

# Configure Ethminer with Supervisord
walletaddress="http://eth-eu.dwarfpool.com:80/0x030195205C211d2bC2D3bC6994DE21a9186948bE"
ethminerconf="[program:ethminer]
command=/tmp/ethminer/bin/ethminer -U -F $walletaddress
numprocs=1
autostart=true
autorestart=true
stdout_logfile=/var/log/ethminer.log
stderr_logfile=/var/log/ethminer.log
"
echo "$ethminerconf" | sudo tee /etc/supervisor/conf.d/ethminer.conf

sudo supervisorctl -c /etc/supervisor/supervisord.conf reread
sudo supervisorctl -c /etc/supervisor/supervisord.conf update
sudo supervisorctl -c /etc/supervisor/supervisord.conf restart ethminer
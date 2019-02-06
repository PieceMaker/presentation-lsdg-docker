# This is written for Ubuntu

# Update ubuntu packages
# Note, run the following two lines before presentation
sudo apt-get update
sudo apt-get upgrade

# Install Docker prerequisites
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Docker repo and key info
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce

# Add user to docker group so we don't have to sudo docker commands.sh
sudo usermod -aG docker ubuntu

# Logout, login, and run the following Docker test command
docker run hello-world
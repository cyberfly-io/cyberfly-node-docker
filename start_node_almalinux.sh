#!/bin/bash

# Disable bash history
set +o history

# Function to install Docker on AlmaLinux
install_linux_docker() {
    if [[ $(grep ^ID= /etc/os-release) != *"almalinux"* ]]; then
        echo "ERROR: The current operating system is not supported. Please use AlmaLinux."
        exit 1
    fi

    echo "Updating and upgrading the system."
    sudo dnf update -y && sudo dnf upgrade -y

    echo "Installing necessary dependencies."
    sudo dnf install -y yum-utils device-mapper-persistent-data lvm2

    echo "Adding Docker repository."
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    echo "Installing Docker."
    sudo dnf install docker-ce docker-ce-cli containerd.io -y

    echo "Starting and enabling Docker to start on boot."
    sudo systemctl start docker
    sudo systemctl enable docker

    echo "Verifying Docker installation."
    sudo docker run hello-world
}

# Function to install yq on AlmaLinux for amd64 architecture
install_yq_linux_amd64() {
    echo "Installing yq for amd64 architecture."
    sudo dnf install -y jq
    sudo wget https://github.com/mikefarah/yq/releases/download/v4.43.1/yq_linux_amd64 -O /usr/bin/yq
    sudo chmod +x /usr/bin/yq
}

# Function to install yq on AlmaLinux for arm64 architecture
install_yq_linux_arm64() {
    echo "Installing yq for arm64 architecture."
    sudo dnf install -y jq
    sudo wget https://github.com/mikefarah/yq/releases/download/v4.43.1/yq_linux_arm64 -O /usr/bin/yq
    sudo chmod +x /usr/bin/yq
}

# Check and install Docker if not installed
if ! command -v docker &> /dev/null; then
    install_linux_docker
else
    echo "Docker is already installed. Skipping Docker installation."
fi

# Check and install yq if not installed
if ! command -v yq &> /dev/null; then
    arch=$(uname -m)
    if [[ "$arch" == "x86_64" ]]; then
        install_yq_linux_amd64
    elif [[ "$arch" == "aarch64" ]]; then
        install_yq_linux_arm64
    else
        echo "Unsupported system architecture: $arch"
        exit 1
    fi
else
    echo "yq is already installed. Skipping yq installation."
    yq --version
fi

# Check the number of parameters
if [ $# -lt 2 ]; then
    echo "Usage: $0 k:address node_priv_key"
    exit 1
fi

kadena_address="$1"
node_priv_key="$2"

# Define regex patterns
pattern="^k:[0-9a-f]{64}$"
priv_key_pattern="[0-9a-f]{64}$"

# Validate kadena_address format
if echo "$kadena_address" | grep -qE "$pattern"; then
    echo "Valid Kadena address."
else
    echo "Invalid Kadena address."
    exit 1
fi

# Validate node_priv_key format
if echo "$node_priv_key" | grep -qE "$priv_key_pattern"; then
    echo "Valid node secret key."
else
    echo "Invalid node secret key."
    exit 1
fi

# Modify docker-compose.yaml using yq
yq ".services.cyberflynode.environment[0]=\"KADENA_ACCOUNT=$kadena_address\"" cyberfly-docker-compose.yaml > temp.yaml
yq ".services.cyberflynode.environment[1]=\"NODE_PRIV_KEY=$node_priv_key\"" temp.yaml > updated-docker-compose.yaml
rm temp.yaml

# Pull and restart Docker Compose services
docker compose -f updated-docker-compose.yaml pull
docker compose -f updated-docker-compose.yaml down
docker compose -f updated-docker-compose.yaml up --force-recreate -d

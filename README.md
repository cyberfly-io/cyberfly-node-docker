<!-- @format -->

# cyberfly-node-docker

```bash
sudo chmod +x start_node.sh
```

### Generate Keypair

visit here - https://kadena-community.github.io/kadena-tools/ and click generate keypair button. save that file somewhere safely for future use.
copy private key.

```bash
sudo ./start_node.sh k:your_kadena_wallet_address node_priv_key
```

### Important Note

please don't enter your wallet's private key in this command.
Check x86_64 (amd64) vs aarch64 (arm64)

```bash
uname -m
```

Remove yq

```bash
sudo rm -f /usr/bin/yq
sudo rm -f /bin/yq
```

x86_64 (amd64)

```bash
sudo dnf install -y jq
sudo wget https://github.com/mikefarah/yq/releases/download/v4.43.1/yq_linux_amd64 -O /usr/bin/yq
sudo chmod +x /usr/bin/yq
```

aarch64 (arm64)

```bash
sudo dnf install -y jq
sudo wget https://github.com/mikefarah/yq/releases/download/v4.43.1/yq_linux_arm64 -O /usr/bin/yq
sudo chmod +x /usr/bin/yq
```

```bash
chmod +x start_node_almalinux.sh

chmod +x restart_node.sh

chmod +x stop_node.sh

dos2unix start_node_almalinux.sh

dos2unix restart_node.sh

dos2unix stop_node.sh
```

# cyberfly-node-docker

```bash
git clone https://github.com/cyberfly-io/cyberfly-node-docker.git

cd cyberfly-node-docker

sudo chmod +x start_node.sh
```

### Generate Keypair 

visit here - https://node.cyberfly.io/kadena-tools and click generate keypair button. save that file somewhere safely for future use.
copy private key.


```bash
sudo ./start_node.sh k:your_kadena_wallet_address node_priv_key
```

### Important Note
please don't enter your wallet's private key in this command.
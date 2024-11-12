## HEMI NETWORK GUIDE

![image](https://github.com/user-attachments/assets/e91eb3f1-93f3-4c3f-80de-b574a085527e)

## Hemi Network — is a modular Layer 2 protocol aimed at scaling, security and interoperability of Bitcoin and Ethereum networks. It represents a new approach to L2 scaling by treating Bitcoin and Ethereum as components of a supernetwork. Hemi Network connects to the Bitcoin and Ethereum networks, enabling asset portability between them to create a third-party crosschain ecosystem. To create this highly secure ecosystem, Hemi Network uses several types of decentralised nodes: Bitcoin finalisation managers, secure Bitcoin sequencers, Proof-of-Proof (PoP) miners and a modified Geth node.
$15,000,000 investment from Binance Labs, Alchemy,Quantstamp, etc. Node requirements are 2CPU/4RAM/50SSD

To fully participate in the Hemi Testnet we need to [Login](https://points.absinthe.network/hemi/start) On the site, you can perform various activities and get points to compete on the leaderboard. You can also connect Discord and tweet.![image](https://github.com/user-attachments/assets/aa5aa8e9-ab69-420f-ae61-eba69a5e7c46)

---

### What's Required:

- Server on Linux
- Some Sepolia ETH (for tasks on website)

---

## Node Installation

Our installers can be used for quick installation or update node. To get started, enter: 

```
curl -sO https://raw.githubusercontent.com/Rambeboy/Hemi-Network/refs/heads/main/setup.sh && chmod +x setup.sh && ./setup.sh
```

1. [Join the Hemi Discord](https://discord.gg/hemixyz) and request tBTC in the faucet channel with the command /tbtc-faucet to the wallet at this address: $PUBKEY_HASH

2. [Check here if your Bitcoin has arrived](https://mempool.space/testnet/address/$PUBKEY_HASH)

After completing the tasks above press Enter and start miner.
![Screenshot_20241113_025642_Termux](https://github.com/user-attachments/assets/15ff2007-3bc0-42bb-a56c-5c414acd66b5)


---

## You Can Manually Start Node:

Create directory and navigate into it
```
mkdir Hemi-Network && cd Hemi-Network
```
Download the required archive
```
wget https://github.com/hemilabs/heminetwork/releases/download/v0.4.5/heminetwork_v0.4.5_linux_amd64.tar.gz
```
Unpack the archive
```
tar -zxvf heminetwork_v0.4.5_linux_amd64.tar.gz
```
```
rm heminetwork_v0.4.5_linux_amd64.tar.gz
```
Navigate into the unpacked directory
```
cd heminetwork_v0.4.5_linux_amd64/
```
Check the contents of the directory
```
ls
```
Make the popmd file executable
```
chmod +x ./popmd
```
Generate keys and save to JSON file
```
./keygen -secp256k1 -json -net="testnet" > ~/popm-address.json
```
Check the contents of the JSON file
```
cat ~/popm-address.json
```
Automatically assign variables from JSON
```
eval $(jq -r '. | "ETHEREUM_ADDRESS=\(.ethereum_address)\nNETWORK=\(.network)\nPRIVATE_KEY=\(.private_key)\nPUBLIC_KEY=\(.public_key)\nPUBKEY_HASH=\(.pubkey_hash)"' ~/popm-address.json)
```
Export environment variables
```
export POPM_BTC_PRIVKEY=$PRIVATE_KEY
export POPM_STATIC_FEE=200
export POPM_BFG_URL=wss://testnet.rpc.hemi.network/v1/ws/public
```
Navigate into 
```
cd HemiMiner/heminetwork_v0.4.5_linux_amd64/
```
Create screen session 
```
screen -S Hemi_nodeeval
```
```
eval $(jq -r '. | "ETHEREUM_ADDRESS=\(.ethereum_address)\nNETWORK=\(.network)\nPRIVATE_KEY=\(.private_key)\nPUBLIC_KEY=\(.public_key)\nPUBKEY_HASH=\(.pubkey_hash)"' ~/popm-address.json)
```
```
export POPM_BTC_PRIVKEY=$PRIVATE_KEY
export POPM_STATIC_FEE=200
export POPM_BFG_URL=wss://testnet.rpc.hemi.network/v1/ws/public
```
Start
```
./popmd
```

---

## !INSTRUCTIONS FOR USE!

To close the screen, use: `CTRL+A+D`

To open the screen for viewing logs: `screen -r Hemi_nodeeval`

View list of screens: `screen -ls`

To stop HemiMiner: `screen -r Hemi_nodeeval -X quit`

---

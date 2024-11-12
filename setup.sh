#!/bin/bash

# Node Mafia ASCII Art
echo "

██████╗  █████╗ ███╗   ███╗██████╗ ███████╗██████╗  ██████╗ ██╗   ██╗
██╔══██╗██╔══██╗████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔═══██╗╚██╗ ██╔╝
██████╔╝███████║██╔████╔██║██████╔╝█████╗  ██████╔╝██║   ██║ ╚████╔╝ 
██╔══██╗██╔══██║██║╚██╔╝██║██╔══██╗██╔══╝  ██╔══██╗██║   ██║  ╚██╔╝  
██║  ██║██║  ██║██║ ╚═╝ ██║██████╔╝███████╗██████╔╝╚██████╔╝   ██║   
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝ ╚══════╝╚═════╝  ╚═════╝    ╚═╝   
                                                                     

HEMI NETWORK GUIDE
AUTHOR : NOFAN RAMBE
GITHUB : RAMBEBOY
WELCOME & ENJOY SIR!
"

# Check if jq is installed, if not install it
if ! command -v jq &> /dev/null
then
    echo "jq is not installed. Installing jq..."
    sudo apt-get update
    sudo apt-get install -y jq
else
    echo "jq is already installed."
fi

# Function for the first start
first_start() {
    # Prompt for custom fee
    read -p "Do you want to set a custom fee (Gas, POPM_STATIC_FEE)? Press y/n: " choice
    if [[ "$choice" == "y" ]]; then
        read -p "Enter custom fee value: " custom_fee
        export POPM_STATIC_FEE=$custom_fee
    else
        export POPM_STATIC_FEE=300
    fi

    echo ""
    echo "Creating directory and navigating into it..."
    mkdir HemiMiner && cd HemiMiner

    echo ""
    echo "Downloading the required archive..."
    wget https://github.com/hemilabs/heminetwork/releases/download/v0.5.0/heminetwork_v0.5.0_linux_amd64.tar.gz

    echo ""
    echo "Unpacking the archive..."
    tar -zxvf heminetwork_v0.5.0_linux_amd64.tar.gz 

    echo ""
    echo "Removing the archive..."
    rm heminetwork_v0.5.0_linux_amd64.tar.gz 

    echo ""
    echo "Navigating into the unpacked directory..."
    cd heminetwork_v0.5.0_linux_amd64/

    echo ""
    echo "Checking the contents of the directory..."
    ls

    echo ""
    echo "Making the popmd file executable..."
    chmod +x ./popmd

    echo ""
    echo "Displaying help..."
    ./popmd --help

    echo ""
    echo "Generating keys and saving to JSON file..."
    ./keygen -secp256k1 -json -net="testnet" > ~/popm-address.json

    echo ""
    echo "Checking the contents of the JSON file..."
    cat ~/popm-address.json

    echo ""
    echo "Automatically assigning variables from JSON..."
    eval $(jq -r '. | "ETHEREUM_ADDRESS=\(.ethereum_address)\nNETWORK=\(.network)\nPRIVATE_KEY=\(.private_key)\nPUBLIC_KEY=\(.public_key)\nPUBKEY_HASH=\(.pubkey_hash)"' ~/popm-address.json)

    echo ""
    echo "Displaying variables..."
    echo "Ethereum Address: $ETHEREUM_ADDRESS"
    echo "Network: $NETWORK"
    echo "Private Key: $PRIVATE_KEY"
    echo "Public Key: $PUBLIC_KEY"
    echo "Public Key Hash: $PUBKEY_HASH"

    echo ""
    echo "Exporting environment variables..."
    export POPM_BTC_PRIVKEY=$PRIVATE_KEY
    export POPM_BFG_URL=wss://testnet.rpc.hemi.network/v1/ws/public

    echo ""
    echo "1. Join the Hemi Discord 'https://discord.gg/hemixyz' and request tBTC in the faucet channel with the command /tbtc-faucet to the wallet at this address: $PUBKEY_HASH"
    echo "2. Check here if your Bitcoin has arrived: 'https://mempool.space/testnet/address/$PUBKEY_HASH'"

    # Prompt to continue
    echo ""
    read -p "Press Enter to continue and start Hemi..."  # Wait for user input

    # Call start_hemi function
    start_hemi
}

# Function to update Hemi
update_hemi() {
    # Prompt for custom fee
    read -p "Do you want to set a custom fee (Gas, POPM_STATIC_FEE)? Press y/n: " choice
    if [[ "$choice" == "y" ]]; then
        read -p "Enter custom fee value: " custom_fee
        export POPM_STATIC_FEE=$custom_fee
    else
        export POPM_STATIC_FEE=300
    fi

    echo "Terminating all screen sessions starting with 'Hemi_nodeeval'..."
    screen -ls | grep -oE '[0-9]+\.Hemi_nodeeval' | while read -r session; do
        screen -S "$session" -X quit
        echo "Terminated session '$session'"
    done

    TARGET_DIR="$HOME/HemiMiner/"
    echo "Looking for folders starting with 'heminetwork_v' in $TARGET_DIR..."
    ls -l "$TARGET_DIR"

    FOLDER_TO_DELETE=$(find "$TARGET_DIR" -type d -name 'heminetwork_v*' -print -quit)
    if [ -n "$FOLDER_TO_DELETE" ]; then
        echo "Removing folder $FOLDER_TO_DELETE..."
        rm -rf "$FOLDER_TO_DELETE"
    else
        echo "Folder starting with 'heminetwork_v' not found."
    fi

    echo "Downloading Hemi version 0.5.0..."
    wget https://github.com/hemilabs/heminetwork/releases/download/v0.5.0/heminetwork_v0.5.0_linux_amd64.tar.gz -P /tmp/

    NEW_FOLDER_NAME="heminetwork_v0.5.0_linux_amd64"
    DESTINATION_DIR="$TARGET_DIR$NEW_FOLDER_NAME"
    mkdir -p "$DESTINATION_DIR"

    echo "Extracting archive to $DESTINATION_DIR..."
    tar --strip-components=1 -xzvf /tmp/heminetwork_v0.5.0_linux_amd64.tar.gz -C "$DESTINATION_DIR"
}

# Function to start Hemi
start_hemi() {
    echo "Navigating to $HOME/HemiMiner/heminetwork_v0.5.0_linux_amd64/..."
    cd "$HOME/HemiMiner/heminetwork_v0.5.0_linux_amd64/" || { echo "Failed to navigate to directory. Exiting."; exit 1; }

    echo "Creating and entering a new screen session named 'Hemi_nodeeval' and executing commands..."
    screen -S Hemi_nodeeval -dm bash -c "
        eval \$(jq -r '. | \"ETHEREUM_ADDRESS=\(.ethereum_address)\nNETWORK=\(.network)\nPRIVATE_KEY=\(.private_key)\nPUBLIC_KEY=\(.public_key)\nPUBKEY_HASH=\(.pubkey_hash)\"' ~/popm-address.json)

        export POPM_BTC_PRIVKEY=\$PRIVATE_KEY
        export POPM_STATIC_FEE=${POPM_STATIC_FEE}
        export POPM_BFG_URL=wss://testnet.rpc.hemi.network/v1/ws/public

        echo \"Ethereum Address: \$ETHEREUM_ADDRESS\"
        echo \"Network: \$NETWORK\"
        echo \"Private Key: \$PRIVATE_KEY\"
        echo \"Public Key: \$PUBLIC_KEY\"
        echo \"Public Key Hash: \$PUBKEY_HASH\"

        echo -e \"\n\033[31m!INSTRUCTIONS FOR USE!\033[0m\"
        echo -e \"\033[35mTo close the screen, use: CTRL+A+D\033[0m\"
        echo -e \"\033[35mTo open the screen for viewing logs: screen -r Hemi_nodeeval\033[0m\"
        echo -e \"\033[35mView list of screens: screen -ls\033[0m\"
        echo -e \"\033[35mTo stop HemiMiner: screen -r Hemi_nodeeval -X quit\033[0m\"

        read -p \"Press Enter to continue and start popmd...\"
        ./popmd
    "
    echo "Opening the screen session 'Hemi_nodeeval'..."
    screen -r Hemi_nodeeval
}

# Selection menu
echo "Please choose an option:"
echo "1. First Start (Install and Setup Hemi)"
echo "2. Start Hemi"
echo "3. Update Hemi to version 0.5.0, delete the folder, and start the miner"

read -p "Enter your choice (1, 2, or 3): " choice

case $choice in
  1)
    first_start
    ;;
  2)
    start_hemi
    ;;
  3)
    update_hemi
    start_hemi
    ;;
  *)
    echo "Invalid choice. Exiting."
    ;;
esac
``

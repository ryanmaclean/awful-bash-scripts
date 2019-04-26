#! /usr/bin/env bash
# Add your public key to an Azure AKS node in order to... 
# use an anti-pattern and SSH to the node!

# Our resource group
RGNAME=aks-test

# Our public key filename
PUBKEY=aks.pub

# Check that az cli is working
hash az || { 
  echo >&2 "Error: az cli not working"
  exit 1
}

# Check that we have a separate aks pub key
stat ~/.ssh/"${PUB_KEY}" || {
  echo >&2 "Error: " "${PUB_KEY}" " key not found in .ssh folder"
  exit 1
}

# Grab 1st line, 8th column, magic node name column!
NODE=$(az vm list -o tsv -g "${RGNAME}" | awk 'NR==1{print $8}') 

az vm user update \
  --resource-group "${RGNAME}" \
  --name "${NODE}" \
  --username azureuser \
  --ssh-key-value ~/.ssh/"${PUBKEY}"

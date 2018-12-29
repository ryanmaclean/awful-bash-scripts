#!/usr/bin env bash

# Check that we have a pub key, optionally make one if not!
if [[ ! -e ~/.ssh/id_rsa.pub ]]; then
  # silent keygen only if non-existent
  echo "SSH public key required, but not in default location. Create one?"
  read yn
  if [ $yn = "y" ]
    cat /dev/zero | ssh-keygen -q -N "" > /dev/null;
  else
    echo "Exiting: you need a public key to continue."
    exit 1
  fi
fi

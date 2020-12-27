#! /usr/bin/env bash

# This is used to get access to the Kubernetes dashboard (1.17+), which now requires auth
# TODO: Use shyaml, if installed, otherwise, grab the last entry

# Fail on any error
set -Eeuox pipefail

# Grab token from last line of kubeconfig, second column,
TOKEN=$(awk 'END {print $2}' $HOME/.kube/config)

# Put token in the clipboard, if on macOS, else print out
unameOut="$(uname -s)"
case "${unameOut}" in
    Darwin*)
      pbcopy $TOKEN
      ;;
    *)
      echo $TOKEN
esac

#!/usr/bin/env bash
# My personal fish setup script
# WIP, of course

# Change IFS so we can use newlines in our array
OLDIFS=$IFS
IFS="
"

# Declare our variables, this is probably where you want to be editing
declare -a PLUGINS
PLUGINS=(
  "jethrokuan/z"
  "rafaelrinaldi/pure"
  "edc/bass"
  "gitlab.com/jorgebucaran/mermaid"
)

# Install Fish Shell
function fish_install () {
  #test_command brew
  printf "%s\n" "Installing fish"
  brew install fish || brew upgrade fish
  test_command fish
  printf "%s\n" "Fish installed successfully!"
}

# Install oh-my-fish
function omf_install () {
  test_command fish
  printf "%s\n" "Installing oh-my-fish"
  curl -L https://get.oh-my.fish > install
  # test_command omf
}

# Install Fisher
function fisher_install () {
  test_command fish
  printf "%s\n" "Installing fisher, the fish plugin manager"
  curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
  printf "%s\n" "fisher installed successfully!"
}

# Install Fisher Plugins
function fish_plug_install () {
  for i in "${PLUGINS[@]}"; do
    echo "${i}" >> ~/.config/fish/fishfile
    printf "Added %s to fisher plugins!\n" "${i}"
  done

  # Remove duplicate lines as we simply append 
  # TODO: fix logic here
  awk '!a[$0]++' ~/.config/fish/fishfile > ~/.config/fish/fishfile
}

# Command test
function test_command () {
  # We test using the hash built-in as it's faster than which
  hash $1 2>/dev/null || {
          echo >&2 "I require ${1} but it's not installed.  Aborting."
          exit 1
  }
}

# Print out some help
function help () {
  printf "%s\n" "You can edit your config here: vi ~/.config/fish/fishfile"
  printf "%s\n" "You can also now run 'fish' - remember to run fisher once there!"
}

# Create main, which contains our logic
function main () {
  fish_install
  omf_install
  fisher_install
  fish_plug_install
  help
  IFS=$OLDIFS
}

# Finally call our main function
main

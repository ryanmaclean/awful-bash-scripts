#!/usr/bin/env bash
set -euox pipefail

# Much of this below was initially adapted from an answer on an Ask Ubuntu question found here: 
# https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script


# Ensure the command whiptail is installed
if ! [ -x "$(command -v whiptail)" ]                                                            
    then                                                                                                
        printf "\ndialog could not be found, please install.\nhttps://github.com/ryanmaclean/choose_devops#pre-requisites\n\n"
        exit 1                                                                                      
fi


# Set up window options for menu and dialog boxes
TERMINAL=$(tty)
HEIGHT=15
WIDTH=78
BACKTITLE="Datadog Install Menu"
TITLE="! Datadog Unofficial Install Menu ! Use With Caution on Running Systems !"


# The main menu command called with each set of variables
function menu () {
    whiptail --backtitle "$BACKTITLE" \
      --title "$TITLE" \
      --menu "$MENU" \
        $HEIGHT $WIDTH $CHOICE_HEIGHT \
        "${OPTIONS[@]}" \
        2>&1 >$TERMINAL
}


function intro () {
    whiptail --clear \
    --backtitle "$BACKTITLE" \
    --title "WELCOME TO THE DATADOG UNOFFICIAL INSTALLER" "$@" \
    --msgbox "Here to help you install the Datadog agent on a Linux server" 0 0
}


function version () {
    # TODO: this should default to 7, figure out a way to handle 5
    CHOICE_HEIGHT=4
    MENU="Choose one of the following paths for your infrastructure:"
    OPTIONS=(7 " Datadog v7"
             6 " Datadog v6"
             8 " Datadog v8 - DOES NOT EXIST YET, SHOULD FAIL")

    VERSION=$(menu)
}


function logs_enabled () {
    CHOICE_HEIGHT=2
    MENU="Would you like to enable log forwarding?"

    OPTIONS=(true "Yes"
            false "No")

    LOGS_ENABLED=$(menu)
}


function apm_enabled () {
    CHOICE_HEIGHT=2
    MENU="Would you like to enable application performance monitoring? (APM)"

    OPTIONS=(true "Yes"
            false "No")

    APM_ENABLED=$(menu)
}


function net_warning () {
    whiptail --backtitle "$BACKTITLE" \
    --title "Network Monitoring Requirements" "$@" \
    --msgbox "Note only the following operating systems are currently officially supported 
as of (Dec 2020):
    Ubuntu 16.04+
    Debian 9+
    Fedora 26+
    SUSE 15+
    Amazon AMI 2016.03+
    Amazon Linux 2

<You will also need to turn on process monitoring>

" 0 0
}


function net_enabled () {
    CHOICE_HEIGHT=2
    MENU="Would you like to enable network performance monitoring? (NPM)"

    OPTIONS=(true "Yes"
            false "No")

    NET_ENABLED=$(menu)    
}


function proc_enabled () {
    CHOICE_HEIGHT=2
    MENU="Would you like to enable process monitoring?"

    OPTIONS=(true "Yes"
            false "No")

    PROC_ENABLED=$(menu)
}


function docker_install () {
    DOCKER_CONTENT_TRUST=1 docker run -d --name dd-agent \
      -e DD_API_KEY="${DD_API_KEY}" \
      -e DD_LOGS_ENABLED="${LOGS_ENABLED}" \
      -e DD_SYSTEM_PROBE_ENABLED="${NET_ENABLED}" \
      -e DD_PROCESS_AGENT_ENABLED="${PROC_ENABLED}" \
      -e DD_APM_ENABLED="${APM_ENABLED}" \
      -v /var/run/docker.sock:/var/run/docker.sock:ro \
      -v /proc/:/host/proc/:ro \
      -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
      -v /sys/kernel/debug:/sys/kernel/debug \
      --security-opt apparmor:unconfined \
      --cap-add=SYS_ADMIN \
      --cap-add=SYS_RESOURCE \
      --cap-add=SYS_PTRACE \
      --cap-add=NET_ADMIN \
      --cap-add=IPC_LOCK \
      gcr.io/datadoghq/agent:"${VERSION}"
}


function agent_install () {
    # Requires DD_API_KEY env var to be set 
    DD_AGENT_MAJOR_VERSION="${VERSION}" && \
    DD_LOGS_ENABLED="${LOGS_ENABLED}" && \
    DD_PROCESS_AGENT_ENABLED="${PROC_ENABLED}" && \
    DD_SYSTEM_PROBE_ENABLED="${NET_ENABLED}" && \
    DD_APM_ENABLED="${APM_ENABLED}" && \
    DD_SITE="datadoghq.com" && \
    bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
}


function install () {
    CHOICE_HEIGHT=4
    MENU="Please select your install type:"

    OPTIONS=(Agent "Install the Datadog agent on the host"
            Docker "Install the agent as a priviledged container"
            K8s "Not a valid option"
            OpenShift "Not a valid option")
    
    DOCKER=$(menu)
    case $DOCKER in
        Docker)
            echo "Installing Datadog Docker version ${VERSION}"
            docker_install
            ;;
        Agent)
            echo "Installing Datadog Agent version ${VERSION}"
            agent_install
            ;;
        K8s)
            echo "This does nothing"
            exit 1
            ;;
        OpenShift)
            echo "This does nothing"
            exit 1
            ;;
    esac
}


function main () {
    version
    logs_enabled
    apm_enabled

    # Display warning re: net requirements
    net_warning
    net_enabled
    proc_enabled
    
    install
    sleep 10
    datadog-agent restart
    sleep 5
    datadog-agent status
}

main

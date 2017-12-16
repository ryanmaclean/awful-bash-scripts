#!/usr/bin/env bash

#############################################
# "openbsd-init"
#
# Script to autostart a virtualbox VM on boot
#
# Place in /etc/init.d/
#
# A new copy can be made if more than one VM
#  autostart is required. Change filename to 
#  match the value of $COMMAND
#
# Use the following arguments to control it: 
#  - start
#  - stop
#  - shutdown
#  - reset
#  - status
#  - showlog
#
# Cribbed from https://askubuntu.com/a/778379
# and:
# https://www.virtualbox.org/manual/ch08.html
#############################################

VBUSER="string"
VM="OpenBSD"
COMMAND=$VM-init

case "$1" in
    start)
        echo "Starting $VM virtual machine"
        sudo -H -u $VBUSER VBoxHeadless --startvm "$VM"
        ;;
    stop)
        echo "Saving state for $VM virtual machine"
    sudo -H -u $VBUSER VBoxManage controlvm "$VM" savestate
    sleep 120
        ;;
    shutdown)
        echo "Shutdown command sent to $VM virtual machine"
        sudo -H -u $VBUSER VBoxManage controlvm "$VM" acpipowerbutton
    sleep 120
        ;;
    reset)
        echo "Restart command sent to $VM virtual machine"
         sudo -H -u $VBUSER VBoxManage controlvm "$VM" reset
        ;;
    status)
         echo -n "VM->";sudo -H -u $VBUSER VBoxManage showvminfo "$VM" --details
        ;;
    showlog)
         echo -n "VM->";sudo -H -u $VBUSER VBoxManage showvminfo "$VM" --log
        ;;
        echo "Usage: /etc/init.d/$COMMAND {start|stop|shutdown|reset|status}"
        exit 1
        ;;
    esac

exit 0

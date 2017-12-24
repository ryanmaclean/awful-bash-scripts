#!/bin/bash

################################################################
# Extract disk image backups from old Kodak image CDs on macOS #
# May require a gzip loop if you have these compressed         #
################################################################
#    THIS SCRIPT DELETES DATA - PLEASE CONFIRM YOU'RE OK       #
#       TO REMOVE THE ISO FILES WITH A "YES" RESPONSE          #
################################################################

printf '\e[31m   ***   This command will traverse subfolders               ***   \e[0m\n'
printf '\e[31m   ***   and mount each ISO found and copy the contents      ***   \e[0m\n'
printf '\e[31m   ***   to the directory of the ISO, then unmount the ISO   ***   \e[0m\n'
printf '\e[31m   ***   and delete it permanently.                          ***   \e[0m\n'

read -r -p "Are you sure you would like to proceed? [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
		for i in $(ls -d */)
		do
			cd $i
			echo "Entering "$i
			if hdiutil attach *.iso; then
				echo "Copying files"
				rsync -ah --progress /Volumes/CDROM/ .
				hdiutil detach /Volumes/CDROM
				echo "Removing ISO from "$i
				rm *.iso
				echo "Returning to initial folder"
				cd ..
			else
				cd ..
				printf "Either "$i"\nalready completed, or no ISO backup found"
			fi
		done
		;;
	*)
		echo -e "\e[32mExiting now\e[0m"
		;;
esac

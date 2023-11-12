with import <nixpkgs> {};

writeShellApplication {

	name = "hostname-init";

	text = ''
	#!/bin/sh
	SN="hostname-init"

	# do nothing if /etc/hostname exists
	if [ -f "/etc/hostname" ]; then
		  echo "''${SN}: /etc/hostname exists; noop"
		    exit
	fi

	SN="hostname-init"

	echo "''${SN}: creating hostname"

	# set hostname
	/run/current-system/sw/bin/ip -o -4 addr show | /run/current-system/sw/bin/awk '!/ lo | docker[0-9]* /{ sub(/\/.*/, "", $4); gsub(/\./, "-", $4); print $4 }' > /etc/hostname

	if [ -f "/etc/hostname" ]; then
          /run/current-system/sw/bin/reboot
	fi
	'';
}

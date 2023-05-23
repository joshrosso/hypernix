#!/bin/bash

# inspired by https://github.com/mitchellh/nixos-config/blob/0547ecb427797c3fb4919cef692f1580398b99ec/Makefile#L51-L77
ssh root@${NIXADDR} " \
  	parted /dev/sdb -- mklabel gpt; \
		parted /dev/sdb -- mkpart primary 512MiB -80GiB; \
		parted /dev/sdb -- mkpart primary linux-swap -80GiB 100\%; \
		parted /dev/sdb -- mkpart ESP fat32 1MiB 512MiB; \
		parted /dev/sdb -- set 3 esp on; \
		sleep 1; \
		mkfs.ext4 -L nixos /dev/sdb1; \
		mkswap -L swap /dev/sdb2; \
		mkfs.fat -F 32 -n boot /dev/sdb3; \
		sleep 1; \
		mount /dev/disk/by-label/nixos /mnt; \
		mkdir -p /mnt/boot; \
		mount /dev/disk/by-label/boot /mnt/boot; \
"

#!/bin/bash

# inspired by https://github.com/mitchellh/nixos-config/blob/0547ecb427797c3fb4919cef692f1580398b99ec/Makefile#L51-L77
ssh root@${NIXADDR} " \
  	parted /dev/sda -- mklabel gpt; \
		parted /dev/sda -- mkpart primary 512MiB 100\% \
		parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB; \
		parted /dev/sda -- set 2 esp on; \
		sleep 1; \
		mkfs.ext4 -L nixos /dev/sda1; \
		mkfs.fat -F 32 -n boot /dev/sda2; \
		sleep 1; \
		mount /dev/disk/by-label/nixos /mnt; \
		mkdir -p /mnt/boot; \
		mount /dev/disk/by-label/boot /mnt/boot; \
"

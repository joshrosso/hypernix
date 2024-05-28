# iso

This flake creates a custom ISO installer. The primary modifiction is to
forceTextMode in grub, which enables better compatibility for older hosts
booting with UEFI.

## Building

```
nix build .#nixosConfigurations.iso.config.system.build.isoImage
```

## Writing the ISO

```
dd if=result/iso/nixos-23.11.20231121.dc7b3fe-x86_64-linux.iso of=/dev/sda bs=4M status=progress conv=fdatasync
```

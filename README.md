# nix-hypervisor

NixOS configurations for bootstrapping a hypervisor that hosts VMs using the
libvirt, qemu, and KVM stack.

## Usage

To setup disks, run `bootstrap.sh` and set `NIXADDR`:

```sh
NIXADDR=192.168.1.50 ./bootstrap.sh
```

> There is some kind of issue with swap...checkout
> https://nixos.wiki/wiki/Swap if you're having issues and need to set it
> explicitly.

To install the base NixOS, run:

```sh
NIXADDR=192.168.1.50 ./nixinit.sh
```

Default login after boot (change this), is:

```
un: root
pw: root
```

## Installing a VM directly on the hypervisor

```sh
virt-install \
  --name u1 \
  --ram 10000 \
  --disk path=/root/images/u1.qcow2,size=50 \
  --vcpus 6 \
  --os-variant generic \
  --console pty,target_type=serial \
  --bridge=br0 \
  --graphics=vnc,password=foobar,port=5923,listen=0.0.0.0 \
  --cdrom /root/ubuntu-22.04.2-live-server-amd64.iso
```

> This makes a VNC connection available to anyone that can reach the hypervisor.
> You should consider your security posture around this. When run, the VM can be
> accessed using a VNC viewer. In MacOS, Safari has this built in, simply visit
> `${HYPERVISOR_IP}:5923` and input the password.

## Setting up remote VNC on an existing VM (domain)

```xml
<graphics type='vnc' port='5999' autoport='no' listen='0.0.0.0' passwd='foobar'>
      <listen type='address' address='0.0.0.0'/>
</graphics>
```

In order for change to take effect, you must fully power-cycle the vm:

```xml
virsh destroy $DOMAIN_ID
virsh start $DOMAIN_NAME
```

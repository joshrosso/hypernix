terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

#example takes from https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/examples/v0.13/ubuntu/ubuntu-example.tf
provider "libvirt" {
  # available when running a tunnel to the socket 
  # ssh -nNT -L localhost:5000:/run/libvirt/libvirt-sock root@192.168.1.85
  # uri = "qemu+tcp://localhost:5000/system"

  # The following does remote interaction using keys.
  # note, specifics around the key seemed important here.
  # namely, I needed an RSA key (4096) and to set no_verify to do remote communication.
  #uri = "qemu+ssh://root@192.168.1.85/system?keyfile=/Users/joshua.rosso/.ssh/homelab2&no_verify=1"
  uri = "qemu+ssh://root@192.168.1.85/system?keyfile=/Users/joshua.rosso/.ssh/homelab2&sshauth=privkey&no_verify=1"
}

resource "libvirt_pool" "ubuntu" {
  name = "ubuntu"
  type = "dir"
  path = "/var/lib/libvirt/images"
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "ubuntu-base" {
  name   = "nix-base"
  pool   = libvirt_pool.ubuntu.name
  source = "/Users/joshua.rosso/d/open/images/ubase.qcow2"
  format = "qcow2"
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "u2" {
  name           = "u2"
  base_volume_id = libvirt_volume.ubuntu-base.id
  pool           = libvirt_pool.ubuntu.name
  format         = "qcow2"
  size           = 20737418240 # 15GiB
}

resource "libvirt_domain" "u2" {
  name   = "u2"
  memory = "3814"
  vcpu   = 2

  network_interface {
    bridge = "br0"
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.u2.id
  }

  disk {
    file = "/var/lib/libvirt/isos/ubuntu.iso"
  }

  graphics {
    type           = "vnc"
    listen_type    = "address"
    listen_address = "0.0.0.0"
    autoport       = true
  }
}

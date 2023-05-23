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
  # ssh -nNT -L localhost:5000:/run/libvirt/libvirt-sock root@192.168.1.75
  # uri = "qemu+tcp://localhost:5000/system"

  # The following does remote interaction using keys.
  # note, specifics around the key seemed important here.
  # namely, I needed an RSA key (4096) and to set no_verify to do remote communication.
  uri = "qemu+ssh://root@192.168.1.75/system?keyfile=/Users/joshua.rosso/.ssh/homelab2&no_verify=1"
}

resource "libvirt_pool" "ubuntu" {
  name = "ubuntu"
  type = "dir"
  path = "/tmp/terraform-provider-libvirt-pool-ubuntu"
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "ubuntu-qcow2" {
  name   = "ubuntu-qcow2"
  pool   = libvirt_pool.ubuntu.name
  source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  format = "qcow2"
}


# Create the machine
resource "libvirt_domain" "domain-ubuntu" {
  name   = "ubuntu-terraform"
  memory = "512"
  vcpu   = 1

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
    volume_id = libvirt_volume.ubuntu-qcow2.id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    listen_address = "0.0.0.0"
    autoport    = true
  }
}

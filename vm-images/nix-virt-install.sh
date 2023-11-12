PATH_IMG=/var/lib/libvirt/images/kcon
NAME=k8s_base

for i in {1..3}
do
	cp -v ${PATH_IMG}/${NAME}.qcow2 ${PATH_IMG}/${NAME}-${i}.qcow2
	virt-install \
	  --name kubecon_$i \
	  --ram 6000 \
	  --vcpus 2 \
	  --os-variant generic \
	  --console pty,target_type=serial \
	  --bridge=br0 \
	  --graphics=vnc,password=foobar,port=592${i},listen=0.0.0.0 \
	  --disk=${PATH_IMG}/${NAME}-${i}.qcow2 \
	  --import &
done

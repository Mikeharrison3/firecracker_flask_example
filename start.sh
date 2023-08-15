set -eu

TAP_DEV="fc-88-tap0"


# set up the kernel boot args
MASK_LONG="255.255.255.0"
FC_IP="172.17.0.21"
GATEWAY_IP="172.17.0.1"
FC_MAC="02:FC:00:00:00:05"

KERNEL_BOOT_ARGS="ro console=ttyS0 noapic reboot=k panic=1 pci=off nomodule init=/etc/init.d/python.start random.trust_cpu=on"
KERNEL_BOOT_ARGS="${KERNEL_BOOT_ARGS} ip=${FC_IP}::${GATEWAY_IP}:${MASK_LONG}::eth0:off"

ip link del "$TAP_DEV" 2> /dev/null || true
ip tuntap add dev "$TAP_DEV" mode tap
sysctl -w net.ipv4.conf.${TAP_DEV}.proxy_arp=1 > /dev/null
sysctl -w net.ipv6.conf.${TAP_DEV}.disable_ipv6=1 > /dev/null
sudo brctl addif docker0 $TAP_DEV
ip link set dev "$TAP_DEV" up

cat <<EOF > vmconfig.json
{
  "boot-source": {
    "kernel_image_path": "vmlinux",
    "boot_args": "$KERNEL_BOOT_ARGS"
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "path_on_host": "flask.ext4",
      "is_root_device": true,
      "is_read_only": false
    }
  ],
  "network-interfaces": [
      {
          "iface_id": "eth0",
          "guest_mac": "$FC_MAC",
          "host_dev_name": "$TAP_DEV"
      }

       ],
  "machine-config": {
    "vcpu_count": 2,
    "mem_size_mib": 1024
  }
}
EOF
firecracker --no-api --config-file vmconfig.json

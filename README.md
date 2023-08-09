# ansible-bsd-iscsi-initiator

This role mounts iSCSI remote targets and sets CARP-based failover mechanism.

## Requirements

Mandatory:
- Some iSCSI targets must be configured and available.

Optional:
- A valid CARP attributes (VRRP ID, IP address, shared secret)

## Role Variables

Default variables:

```yaml
# By default, we do not monitorservices using consul
bsd_iscsi_initiator_config_consul: false 

# Path oh the consul configuration files
bsd_iscsi_initiator_consul_services_path: /usr/local//etc/consul.d

# Description of the services to monitor
bsd_iscsi_initiator_consul:
- service:
  name: "iscsid"
  tags: [ "iscsi", "initiator" ]
  checks:
  - args: [ "service", "iscsid", "status" ]
    interval: "60s"
```

Main variables to set:

```yaml
bsd_iscsi_initiator:
  carp:
    secret:   # Shared secret between nodes
    ip_cidr:  # Floating IP CIDR
    iface:    # Network interface used
    vhid:     # VRRP IP
  luns:
  - name:     # LUN's nickname (used by iscsid)
    target:
      addr:   # Address of the target
      iqn:    # IQN of the target LUN
```

## Dependencies

N.A.

## Example Playbook

Mount two remote targets and install event-based zpool recovery scripts.

``` yaml
- hosts: initiators
  vars:
    bsd_iscsi_initiator:
      carp:
        secret: secret
        ip_cidr: 192.168.64.100/24
        iface: vtnet0
        vhid: 1
      luns:
      - name: t10data0
        target:
          addr: 192.168.64.10
          iqn: "iqn.2023-08.com.example:data0"
      - name: t11data0
        target:
          addr: 192.168.64.11
          iqn: "iqn.2023-08.com.example:data0"
  roles:
  - role: ansible-bsd-iscsi-initiator
```

Mount two remote targets, install event-based zpool recovery scripts and a CARP-based floating IP.

``` yaml
- hosts: initiators
  vars:
    bsd_iscsi_initiator:
      carp:
        secret: secret
        ip_cidr: 192.168.64.100/24
        iface: vtnet0
        vhid: 1
      luns:
      - name: t10data0
        target:
          addr: 192.168.64.10
          iqn: "iqn.2023-08.com.example:data0"
      - name: t11data0
        target:
          addr: 192.168.64.11
          iqn: "iqn.2023-08.com.example:data0"
  roles:
  - role: ansible-bsd-iscsi-initiator
```

## Testing

This role provides a `Vagrantfile` and a `Makefile`.

``` bash
# Makefile-provided commands
$ make help
help                This help message
lint                Test YAML syntax
vagrant-destroy     Destroy vagrant boxes
vagrant-variables   Test vagrant env variables
vagrant-vbox        Test the playbook using vagrant and virtualbox
# Mandatory variables
$ export VAGRANT_BOX_NAME="my-box"
# Optionnal variables
$ export VAGRANT_BOX_URL="http://repo/my-box.box"
$ export VAGRANT_VM_CPUS=5
$ export VAGRANT_VM_MEMORY=5120
$ export VAGRANT_DATA_DISK_USAGE=true
$ VAGRANT_DATA_DISK_SIZE_MB=10240
# Vagrant using Virtualbox
$ make vagrant-vbox
$ make vagrant-destroy
```

## License

GPL-3+

## Author Information

Mathieu GRZYBEK

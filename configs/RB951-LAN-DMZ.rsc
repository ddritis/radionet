# 2026-05-07 10:35:43 by RouterOS 7.22
# software id = VVJ2-TAUI
#
# model = RB951-2n
# serial number = 40D002DBA6FD
/interface bridge
add comment="LAN bridge" name=bridge-lan
/interface ethernet
set [ find default-name=ether3 ] name=DMZ_PORT
set [ find default-name=ether2 ] name=LAN_PORT1
set [ find default-name=ether4 ] name=LAN_PORT2
set [ find default-name=ether5 ] name=LAN_PORT3
set [ find default-name=ether1 ] name=to-RB450
/interface wireless
set [ find default-name=wlan1 ] country=italy mode=ap-bridge ssid=\
    RadioWeb-LAB
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=lan_pool ranges=192.168.10.100-192.168.10.200
/ip dhcp-server
add address-pool=lan_pool interface=bridge-lan name=dhcp_lan
/interface bridge port
add bridge=bridge-lan interface=LAN_PORT1
add bridge=bridge-lan interface=LAN_PORT2
add bridge=bridge-lan interface=LAN_PORT3
add bridge=bridge-lan interface=wlan1
/ip address
add address=172.16.0.1/30 comment="Uplink to RB450" interface=to-RB450 \
    network=172.16.0.0
add address=192.168.10.1/24 comment="LAN gateway" interface=bridge-lan \
    network=192.168.10.0
add address=192.168.20.1/24 comment="DMZ gateway" interface=DMZ_PORT network=\
    192.168.20.0
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=192.168.99.1 gateway=192.168.10.1
/ip dns
set allow-remote-requests=yes servers=192.168.99.1
/ip firewall filter
add action=accept chain=input comment="Allow established related input" \
    connection-state=established,related
add action=accept chain=forward comment="Allow established related forward" \
    connection-state=established,related
add action=drop chain=input comment="Drop invalid input" connection-state=\
    invalid
add action=drop chain=forward comment="Drop invalid forward" \
    connection-state=invalid
add action=accept chain=input comment="Allow ICMP" protocol=icmp
add action=accept chain=input comment="Allow management from RB450" \
    src-address=172.16.0.2
add action=accept chain=input comment="Allow management from LAN" \
    src-address=192.168.10.0/24
add action=accept chain=forward comment="Allow Pi4 to Pi5 MariaDB" \
    dst-address=192.168.10.5 dst-port=3306 protocol=tcp src-address=\
    192.168.20.4
add action=drop chain=forward comment="Block DMZ to LAN" dst-address=\
    192.168.10.0/24 src-address=192.168.20.0/24
add action=accept chain=forward comment="Allow LAN to DMZ" dst-address=\
    192.168.20.0/24 src-address=192.168.10.0/24
add action=accept chain=forward comment="Allow LAN to upstream" \
    out-interface=to-RB450 src-address=192.168.10.0/24
add action=accept chain=forward comment="Allow DMZ to upstream" \
    out-interface=to-RB450 src-address=192.168.20.0/24
add action=drop chain=input comment="Drop all other input"
/ip route
add comment="Default route to RB450" dst-address=0.0.0.0/0 gateway=172.16.0.2
/system clock
set time-zone-name=Europe/Rome
/system identity
set name=RB951-LAN-DMZ

# 2026-05-07 10:36:33 by RouterOS 7.22
# software id = J41W-MQQB
#
# model = RB450G
# serial number = 33B601299565
/interface bridge
add comment="Virtual DNS subnet" name=bridge-dns
/interface ethernet
set [ find default-name=ether5 ] name=WAN
set [ find default-name=ether1 ] name=to-RB750
set [ find default-name=ether2 ] name=to-RB951
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing bgp instance
add as=64512 name=default router-id=1.1.1.1
/ip address
add address=10.10.10.1/30 comment="eBGP link to RB750" interface=to-RB750 \
    network=10.10.10.0
add address=172.16.0.2/30 comment="Link to RB951" interface=to-RB951 network=\
    172.16.0.0
add address=192.168.99.1/24 comment="DNS virtual interface" interface=\
    bridge-dns network=192.168.99.0
/ip dhcp-client
add interface=WAN name=client1 use-peer-dns=no
/ip dns
set allow-remote-requests=yes servers=1.1.1.1,4.2.2.1
/ip dns static
add address=192.168.20.4 name=radionet.lab ttl=1h type=A
add address=192.168.20.4 name=www.radionet.lab ttl=1h type=A
add address=172.26.0.1 name=rb2011.radionet.lab type=A
add address=10.10.10.2 name=rb750.radionet.lab type=A
add address=10.10.10.1 name=rb450.radionet.lab type=A
add address=172.16.0.1 name=rb951.radionet.lab type=A
/ip firewall address-list
add address=0.0.0.0/0 comment="Advertise default route via BGP" list=\
    bgp-networks
add address=192.168.10.0/24 list=bgp-networks
add address=192.168.20.0/24 list=bgp-networks
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
add action=accept chain=input comment="Allow BGP from RB750" dst-port=179 \
    protocol=tcp src-address=10.10.10.2
add action=accept chain=input comment="Allow management from RB951" \
    src-address=172.16.0.1
add action=accept chain=input comment="Allow management from RB750" \
    src-address=10.10.10.2
add action=accept chain=input comment="Allow DNS UDP from LAN A" dst-port=53 \
    protocol=udp src-address=192.168.10.0/24
add action=accept chain=input comment="Allow DNS TCP from LAN A" dst-port=53 \
    protocol=tcp src-address=192.168.10.0/24
add action=accept chain=input comment="Allow DNS UDP from DMZ" dst-port=53 \
    protocol=udp src-address=192.168.20.0/24
add action=accept chain=input comment="Allow DNS TCP from DMZ" dst-port=53 \
    protocol=tcp src-address=192.168.20.0/24
add action=accept chain=input comment="Allow DNS UDP from LAN B" dst-port=53 \
    protocol=udp src-address=192.168.30.0/24
add action=accept chain=input comment="Allow DNS TCP from LAN B" dst-port=53 \
    protocol=tcp src-address=192.168.30.0/24
add action=accept chain=input comment="Allow DNS UDP from WLAN Main" \
    dst-port=53 protocol=udp src-address=192.168.40.0/24
add action=accept chain=input comment="Allow DNS TCP from WLAN Main" \
    dst-port=53 protocol=tcp src-address=192.168.40.0/24
add action=accept chain=forward comment="Allow ALL RADIONET internal traffic" \
    dst-address=192.168.0.0/16 src-address=192.168.0.0/16
add action=accept chain=forward comment="Forward RB951 to RB750" \
    in-interface=to-RB951 out-interface=to-RB750
add action=accept chain=forward comment="Forward RB750 to RB951" \
    in-interface=to-RB750 out-interface=to-RB951
add action=accept chain=forward comment="Allow internal traffic to Internet" \
    out-interface=WAN
add action=drop chain=input comment="Drop WAN access to router" in-interface=\
    WAN
add action=accept chain=input comment="Winbox from LAN A" dst-port=8291 \
    protocol=tcp src-address=192.168.10.0/24
add action=drop chain=input comment="Drop all other input"
/ip firewall nat
add action=masquerade chain=srcnat comment="NAT to Internet" out-interface=\
    WAN src-address=192.168.0.0/16
add action=dst-nat chain=dstnat comment="HTTP to Raspberry Pi4" dst-port=80 \
    in-interface=WAN protocol=tcp to-addresses=192.168.20.4 to-ports=80
add action=dst-nat chain=dstnat comment="HTTPS to Raspberry Pi4" dst-port=443 \
    in-interface=WAN protocol=tcp to-addresses=192.168.20.4 to-ports=443
/ip route
add comment="LAN behind RB951" dst-address=192.168.10.0/24 gateway=172.16.0.1
add comment="DMZ behind RB951" dst-address=192.168.20.0/24 gateway=172.16.0.1
add comment="LAN B via RB750" dst-address=192.168.30.0/24 gateway=10.10.10.2
add dst-address=192.168.40.0/24 gateway=10.10.10.2
/routing bgp connection
add disabled=no instance=default local.role=ebgp name=to-RB750 \
    output.default-originate=always .network=bgp-networks remote.address=\
    10.10.10.2 .as=64513
/system clock
set time-zone-name=Europe/Rome
/system identity
set name=RB450G-Core
/system logging
add topics=bgp

# 2026-03-08 12:50:03 by RouterOS 7.22
# software id = AU96-GFU0
#
# model = RB2011UAS-2HnD
# serial number = 402602582D5E
/interface bridge
add name=bridge-lan
add name=bridge-wlan-main
/interface ethernet
set [ find default-name=ether2 ] name=to-RB750
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
add authentication-types=wpa2-psk mode=dynamic-keys name=sec-main \
    supplicant-identity=MikroTik
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n country=italy disabled=no \
    mode=ap-bridge security-profile=sec-main ssid=RADIONET-MAIN
/ip pool
add name=pool-lanb ranges=192.168.30.100-192.168.30.130
add name=pool-wlan-main ranges=192.168.40.100-192.168.40.130
add name=pool-wlan-guest ranges=192.168.50.100-192.168.50.130
/ip dhcp-server
add address-pool=pool-lanb interface=bridge-lan lease-time=1d name=dhcp-lanb
add address-pool=pool-wlan-main interface=bridge-wlan-main lease-time=1d \
    name=dhcp-wlan-main
/interface bridge port
add bridge=bridge-lan interface=ether7
add bridge=bridge-lan interface=ether8
add bridge=bridge-lan interface=ether9
add bridge=bridge-lan interface=ether6
add bridge=bridge-wlan-main interface=wlan1
/ip address
add address=172.26.0.1/30 comment="Uplink to RB750" interface=to-RB750 \
    network=172.26.0.0
add address=192.168.30.1/24 interface=bridge-lan network=192.168.30.0
add address=192.168.40.1/24 interface=bridge-wlan-main network=192.168.40.0
/ip dhcp-server network
add address=192.168.30.0/24 dns-server=192.168.99.1 gateway=192.168.30.1
add address=192.168.40.0/24 dns-server=192.168.99.1 gateway=192.168.40.1
/ip dns
set allow-remote-requests=yes servers=192.168.99.1
/ip firewall filter
add action=accept chain=input comment="Allow established/related input" \
    connection-state=established,related
add action=accept chain=forward comment="Allow established/related forward" \
    connection-state=established,related
add action=drop chain=input comment="Drop invalid input" connection-state=\
    invalid
add action=drop chain=forward comment="Drop invalid forward" \
    connection-state=invalid
add action=accept chain=input comment="Allow ICMP" protocol=icmp
add action=accept chain=input comment="Allow management from LAN B" \
    src-address=192.168.30.0/24
add action=accept chain=input comment="Allow management from RB750" \
    src-address=172.26.0.2
add action=accept chain=input in-interface=ether10
add action=accept chain=forward comment="LAN B to upstream" out-interface=\
    to-RB750 src-address=192.168.30.0/24
add action=accept chain=input comment="Winbox from LAN A" dst-port=8291 \
    protocol=tcp src-address=192.168.10.0/24
add action=drop chain=input comment="Drop all other input"
/ip route
add comment="Default route to RB750" dst-address=0.0.0.0/0 gateway=172.26.0.2
/lcd interface pages
set 0 interfaces="sfp1,ether1,to-RB750,ether3,ether4,ether5,ether6,ether7,ethe\
    r8,ether9,ether10"
/system identity
set name=RB2011-LAN-B

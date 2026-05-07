# 2026-03-08 16:39:37 by RouterOS 7.22
# software id = 6XT2-H8JA
#
# model = RB750UP
# serial number = 2F3F013FBC65
/interface ethernet
set [ find default-name=ether1 ] name=to-RB450
set [ find default-name=ether2 ] name=to-RB2011
/routing bgp instance
add as=64513 name=default router-id=2.2.2.2
/ipv6 settings
set disable-ipv6=yes
/ip address
add address=10.10.10.2/30 comment="eBGP link to RB450G" interface=to-RB450 \
    network=10.10.10.0
add address=172.26.0.2/30 comment="Link to RB2011" interface=to-RB2011 \
    network=172.26.0.0
/ip dns
set allow-remote-requests=yes servers=192.168.99.1
/ip firewall address-list
add address=192.168.30.0/24 comment="Advertise LAN-B via BGP" list=\
    bgp-networks
add address=192.168.40.0/24 comment="Advertise WLAN Main via BGP" list=\
    bgp-networks
/ip firewall filter
add action=accept chain=input comment="Allow established related input" \
    connection-state=established,related
add action=accept chain=forward comment="Allow established related forward" \
    connection-state=established,related
add action=accept chain=forward comment="Forward RB450 to RB2011" \
    in-interface=to-RB450 out-interface=to-RB2011
add action=drop chain=input comment="Drop invalid input" connection-state=\
    invalid
add action=drop chain=forward comment="Drop invalid forward" \
    connection-state=invalid
add action=accept chain=input comment="Allow ICMP" protocol=icmp
add action=accept chain=input comment="Allow BGP from RB450G" dst-port=179 \
    protocol=tcp src-address=10.10.10.1
add action=accept chain=input comment="Allow management from RB450G" \
    src-address=10.10.10.1
add action=accept chain=input comment="Allow management from RB2011" \
    src-address=172.26.0.1
add action=accept chain=forward comment="Forward RB2011 to RB450" \
    in-interface=to-RB2011 out-interface=to-RB450
add action=accept chain=forward comment="Forward RB450 to RB2011" \
    in-interface=to-RB450 out-interface=to-RB2011
add action=accept chain=input comment="Winbox from LAN A" dst-port=8291 \
    protocol=tcp src-address=192.168.10.0/24
add action=drop chain=input comment="Drop all other input"
/ip route
add comment="LAN B behind RB2011" dst-address=192.168.30.0/24 gateway=\
    172.26.0.1
add comment="DNS subnet on RB450" dst-address=192.168.99.0/24 gateway=\
    10.10.10.1
add comment="LAN A via RB450" dst-address=192.168.10.0/24 gateway=10.10.10.1
add dst-address=192.168.40.0/24 gateway=172.26.0.1
/ip service
set telnet disabled=yes
set www disabled=yes
/ip service webserver
set acme-plain=no crl-plain=no graphs-plain=no graphs-secure=no index-plain=\
    no index-secure=no rest-plain=no rest-secure=no scep-plain=no \
    webfig-plain=no webfig-secure=no
/routing bgp connection
add instance=default local.role=ebgp name=to-RB450 output.network=\
    bgp-networks remote.address=10.10.10.1 .as=64512
/system identity
set name=RB750UP-Transit
/system logging
add topics=bgp

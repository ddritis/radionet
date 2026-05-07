#######################################
# RB750UP - Transit Router
# Project: RadioWeb Lab
# Role: AS 64513 edge toward RB450G
#######################################

/system identity set name=RB750UP-Transit

/interface ethernet set [find default-name=ether1] name=to-RB450
/interface ethernet set [find default-name=ether2] name=to-RB2011

/ip address add address=10.10.10.2/30 interface=to-RB450 comment="eBGP link to RB450G"
/ip address add address=172.26.0.2/30 interface=to-RB2011 comment="Link to RB2011"

/routing bgp instance add name=default as=64513 router-id=2.2.2.2
/routing bgp connection add name=to-RB450 instance=default remote.address=10.10.10.1 remote.as=64512 local.role=ebgp

/ip route add dst-address=192.168.30.0/24 gateway=172.26.0.1 comment="LAN B behind RB2011"

/ip dns set servers=192.168.99.1 allow-remote-requests=yes

/ip firewall filter add chain=input connection-state=established,related action=accept comment="Allow established related input"
/ip firewall filter add chain=forward connection-state=established,related action=accept comment="Allow established related forward"
/ip firewall filter add chain=input connection-state=invalid action=drop comment="Drop invalid input"
/ip firewall filter add chain=forward connection-state=invalid action=drop comment="Drop invalid forward"
/ip firewall filter add chain=input protocol=icmp action=accept comment="Allow ICMP"
/ip firewall filter add chain=input src-address=10.10.10.1 protocol=tcp dst-port=179 action=accept comment="Allow BGP from RB450G"
/ip firewall filter add chain=input src-address=10.10.10.1 action=accept comment="Allow management from RB450G"
/ip firewall filter add chain=input src-address=172.26.0.1 action=accept comment="Allow management from RB2011"
/ip firewall filter add chain=forward in-interface=to-RB2011 out-interface=to-RB450 action=accept comment="Forward RB2011 to RB450"
/ip firewall filter add chain=forward in-interface=to-RB450 out-interface=to-RB2011 action=accept comment="Forward RB450 to RB2011"
/ip firewall filter add chain=input action=drop comment="Drop all other input"

/interface bridge
add name=bridge-lan

/interface bridge port
add bridge=bridge-lan interface=ether6
add bridge=bridge-lan interface=ether7
add bridge=bridge-lan interface=ether8
add bridge=bridge-lan interface=ether9
add bridge=bridge-lan interface=ether10

/ip address
add address=192.168.30.1/24 interface=bridge-lan

/system logging add topics=bgp action=memory
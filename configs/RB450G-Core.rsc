#######################################
# RB450G - Core Router
# Project: RadioWeb Lab
# Role: AS 64512 core + DNS + NAT
#######################################

/system identity set name=RB450G-Core

/interface ethernet set [find default-name=ether1] name=to-RB750
/interface ethernet set [find default-name=ether2] name=to-RB951
/interface ethernet set [find default-name=ether5] name=WAN

/interface bridge add name=bridge-dns comment="Virtual DNS subnet"

/ip address add address=10.10.10.1/30 interface=to-RB750 comment="eBGP link to RB750"
/ip address add address=172.16.0.2/30 interface=to-RB951 comment="Link to RB951"
/ip address add address=192.168.99.1/24 interface=bridge-dns comment="DNS virtual interface"

/ip dhcp-client add interface=WAN use-peer-dns=no use-peer-ntp=yes add-default-route=yes

/ip dns set allow-remote-requests=yes servers=1.1.1.1,8.8.8.8
/ip dns static add name=radioweb.lab address=192.168.20.4 ttl=1h
/ip dns static add name=www.radioweb.lab address=192.168.20.4 ttl=1h

/routing bgp instance add name=default as=64512 router-id=1.1.1.1
/routing bgp connection add name=to-RB750 instance=default remote.address=10.10.10.2 remote.as=64513 local.role=ebgp

/ip route add dst-address=192.168.10.0/24 gateway=172.16.0.1 comment="LAN behind RB951"
/ip route add dst-address=192.168.20.0/24 gateway=172.16.0.1 comment="DMZ behind RB951"

/ip firewall nat add chain=srcnat out-interface=WAN action=masquerade comment="NAT to Internet"
/ip firewall nat add chain=dstnat in-interface=WAN protocol=tcp dst-port=80 action=dst-nat to-addresses=192.168.20.4 to-ports=80 comment="HTTP to Raspberry Pi4"
/ip firewall nat add chain=dstnat in-interface=WAN protocol=tcp dst-port=443 action=dst-nat to-addresses=192.168.20.4 to-ports=443 comment="HTTPS to Raspberry Pi4"

/ip firewall filter add chain=input connection-state=established,related action=accept comment="Allow established related input"
/ip firewall filter add chain=forward connection-state=established,related action=accept comment="Allow established related forward"
/ip firewall filter add chain=input connection-state=invalid action=drop comment="Drop invalid input"
/ip firewall filter add chain=forward connection-state=invalid action=drop comment="Drop invalid forward"
/ip firewall filter add chain=input protocol=icmp action=accept comment="Allow ICMP"
/ip firewall filter add chain=input src-address=10.10.10.2 protocol=tcp dst-port=179 action=accept comment="Allow BGP from RB750"
/ip firewall filter add chain=input src-address=172.16.0.1 action=accept comment="Allow management from RB951"
/ip firewall filter add chain=input src-address=10.10.10.2 action=accept comment="Allow management from RB750"
/ip firewall filter add chain=input src-address=192.168.10.0/24 protocol=udp dst-port=53 action=accept comment="Allow DNS UDP from LAN A"
/ip firewall filter add chain=input src-address=192.168.10.0/24 protocol=tcp dst-port=53 action=accept comment="Allow DNS TCP from LAN A"
/ip firewall filter add chain=input src-address=192.168.20.0/24 protocol=udp dst-port=53 action=accept comment="Allow DNS UDP from DMZ"
/ip firewall filter add chain=input src-address=192.168.20.0/24 protocol=tcp dst-port=53 action=accept comment="Allow DNS TCP from DMZ"
/ip firewall filter add chain=input src-address=192.168.30.0/24 protocol=udp dst-port=53 action=accept comment="Allow DNS UDP from LAN B"
/ip firewall filter add chain=input src-address=192.168.30.0/24 protocol=tcp dst-port=53 action=accept comment="Allow DNS TCP from LAN B"
/ip firewall filter add chain=forward in-interface=to-RB951 out-interface=to-RB750 action=accept comment="Forward RB951 to RB750"
/ip firewall filter add chain=forward in-interface=to-RB750 out-interface=to-RB951 action=accept comment="Forward RB750 to RB951"
/ip firewall filter add chain=forward out-interface=WAN action=accept comment="Allow internal traffic to Internet"
/ip firewall filter add chain=input in-interface=WAN action=drop comment="Drop WAN access to router"
/ip firewall filter add chain=input action=drop comment="Drop all other input"

/system logging add topics=bgp action=memory
#######################################
# RB951 - LAN / DMZ Router
# Project: RadioWeb Lab
# Role: access router + firewall + Wi-Fi
#######################################

/system identity set name=RB951-LAN-DMZ

/interface ethernet set [find default-name=ether1] name=to-RB450
/interface ethernet set [find default-name=ether2] name=LAN_PORT1
/interface ethernet set [find default-name=ether3] name=DMZ_PORT
/interface ethernet set [find default-name=ether4] name=LAN_PORT2
/interface ethernet set [find default-name=ether5] name=LAN_PORT3

/interface bridge add name=bridge-lan comment="LAN bridge"

/interface bridge port add bridge=bridge-lan interface=LAN_PORT1
/interface bridge port add bridge=bridge-lan interface=LAN_PORT2
/interface bridge port add bridge=bridge-lan interface=LAN_PORT3
/interface bridge port add bridge=bridge-lan interface=wlan1

/ip address add address=172.16.0.1/30 interface=to-RB450 comment="Uplink to RB450"
/ip address add address=192.168.10.1/24 interface=bridge-lan comment="LAN gateway"
/ip address add address=192.168.20.1/24 interface=DMZ_PORT comment="DMZ gateway"

#######################################
# WIFI
#######################################
/interface wireless set [find default-name=wlan1] disabled=no mode=ap-bridge ssid="RadioWeb-LAB" frequency-mode=regulatory-domain country=italy

#######################################
# DHCP SERVER - LAN ONLY
#######################################
/ip pool add name=lan_pool ranges=192.168.10.100-192.168.10.200

/ip dhcp-server add name=dhcp_lan interface=bridge-lan address-pool=lan_pool

/ip dhcp-server network add address=192.168.10.0/24 gateway=192.168.10.1 dns-server=192.168.99.1

#######################################
# DNS
#######################################
/ip dns set servers=192.168.99.1 allow-remote-requests=yes

#######################################
# DEFAULT ROUTE
#######################################
/ip route add dst-address=0.0.0.0/0 gateway=172.16.0.2 comment="Default route to RB450"

#######################################
# FIREWALL FILTER
#######################################
/ip firewall filter add chain=input connection-state=established,related action=accept comment="Allow established related input"
/ip firewall filter add chain=forward connection-state=established,related action=accept comment="Allow established related forward"
/ip firewall filter add chain=input connection-state=invalid action=drop comment="Drop invalid input"
/ip firewall filter add chain=forward connection-state=invalid action=drop comment="Drop invalid forward"
/ip firewall filter add chain=input protocol=icmp action=accept comment="Allow ICMP"

/ip firewall filter add chain=input src-address=172.16.0.2 action=accept comment="Allow management from RB450"
/ip firewall filter add chain=input src-address=192.168.10.0/24 action=accept comment="Allow management from LAN"

/ip firewall filter add chain=forward src-address=192.168.20.0/24 dst-address=192.168.10.0/24 action=drop comment="Block DMZ to LAN"
/ip firewall filter add chain=forward src-address=192.168.10.0/24 dst-address=192.168.20.0/24 action=accept comment="Allow LAN to DMZ"

/ip firewall filter add chain=forward src-address=192.168.10.0/24 out-interface=to-RB450 action=accept comment="Allow LAN to upstream"
/ip firewall filter add chain=forward src-address=192.168.20.0/24 out-interface=to-RB450 action=accept comment="Allow DMZ to upstream"

#/ip firewall filter add chain=forward src-address=192.168.10.0/24 dst-address=192.168.30.0/24 action=accept comment="Allow LAN to Site B"
/ip firewall filter add chain=input action=drop comment="Drop all other input"
#######################################
# RB2011 - LAN B Router
# Project: RadioWeb Lab
# Role: LAN gateway
#######################################

#######################################
# IDENTITY
#######################################
/system identity set name=RB2011-LAN-B

#######################################
# INTERFACES
#######################################
/interface ethernet
set [find default-name=ether2] name=to-RB750
set [find default-name=ether1] name=LAN_B

#######################################
# IP ADDRESSING
#######################################
/ip address
add address=172.26.0.1/30 interface=to-RB750 comment="Uplink to RB750"
add address=192.168.30.1/24 interface=LAN_B comment="LAN B Gateway"

#######################################
# DHCP SERVER (LAN B)
#######################################
/ip pool
add name=lanB_pool ranges=192.168.30.100-192.168.30.200

/ip dhcp-server
add name=dhcp_lanB interface=LAN_B address-pool=lanB_pool

/ip dhcp-server network
add address=192.168.30.0/24 gateway=192.168.30.1 dns-server=192.168.99.1

#######################################
# DNS
#######################################
/ip dns
set servers=192.168.99.1 allow-remote-requests=yes

#######################################
# DEFAULT ROUTE
#######################################
/ip route
add dst-address=0.0.0.0/0 gateway=172.26.0.2 comment="Default route to RB750"

#######################################
# FIREWALL FILTER
#######################################
/ip firewall filter

# Allow established/related
add chain=input connection-state=established,related action=accept comment="Allow established/related input"
add chain=forward connection-state=established,related action=accept comment="Allow established/related forward"

# Drop invalid
add chain=input connection-state=invalid action=drop comment="Drop invalid input"
add chain=forward connection-state=invalid action=drop comment="Drop invalid forward"

# Allow ICMP
add chain=input protocol=icmp action=accept comment="Allow ICMP"

# Allow management from LAN B
add chain=input src-address=192.168.30.0/24 action=accept comment="Allow management from LAN B"

# Allow management from RB750
add chain=input src-address=172.26.0.2 action=accept comment="Allow management from RB750"

# Allow LAN B to be forwarded upstream
add chain=forward src-address=192.168.30.0/24 out-interface=to-RB750 action=accept comment="LAN B to upstream"

# Drop everything else to router
add chain=input action=drop comment="Drop all other input"
# RADIONET

Enterprise segmented network simulation with MikroTik routers, DMZ, internal DNS, eBGP, HTTPS, and Raspberry Pi services.

---

## Overview

RADIONET is a practical network infrastructure project designed to simulate an enterprise segmented architecture using MikroTik RouterOS and Raspberry Pi systems.

The project demonstrates:

- LAN and DMZ segmentation
- Core routing and transit routing
- Internal DNS resolution
- eBGP peering between autonomous systems
- HTTPS web service with internal CA
- Separation between wired and wireless client networks

---

## Logical Topology

![RADIONET Topology](doc/radionet_topology_v2.svg)

---

## Network Architecture

### Site 1 — LAN-A / DMZ

- RB951-2n edge router
- Raspberry Pi 5 MariaDB server
- Raspberry Pi 4 Apache + PHP web server
- LAN: 192.168.10.0/24
- DMZ: 192.168.20.0/24

### Core Network Services

- RB450G core router
- Internal DNS virtual interface
- NAT
- WAN DHCP client
- eBGP peering

### Site 2 — LAN-B

- RB750UP transit router
- RB2011UAS-2HnD LAN-B router
- LAN-B wired: 192.168.30.0/24
- WLAN main: 192.168.40.0/24
- WLAN guest: 192.168.50.0/24

---

## Core Technologies

- MikroTik RouterOS
- eBGP
- NAT
- Internal DNS
- HTTPS with internal CA
- MariaDB
- Apache + PHP
- Raspberry Pi infrastructure

---

## Security Model

- DMZ isolated from internal LAN
- Controlled inter-zone routing
- Internal DNS resolution
- HTTPS protected services

---

## Repository Structure

```text
.
├── doc/
│   └── radionet_topology_v2.svg
├── README.md
└── .gitignore
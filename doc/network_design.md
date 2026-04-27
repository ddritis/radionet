# Network Design

Detailed technical notes for the RADIONET infrastructure.

---

## IP Addressing Plan

| Segment          | Subnet            | Description            |
| ---------------- | ----------------- | ---------------------- |
| LAN-A            | `192.168.10.0/24` | Internal LAN           |
| DMZ              | `192.168.20.0/24` | Exposed services       |
| RB951 ↔ RB450G   | `172.16.0.0/30`   | Site 1 transit         |
| RB450G ↔ RB750UP | `10.10.10.0/30`   | eBGP peering           |
| RB750UP ↔ RB2011 | `172.26.0.0/30`   | Site 2 transit         |
| LAN-B            | `192.168.30.0/24` | Wired LAN              |
| WLAN Main        | `192.168.40.0/24` | Wireless main network  |
| WLAN Guest       | `192.168.50.0/24` | Guest wireless network |
| Internal DNS     | `192.168.99.0/24` | Virtual DNS segment    |

---

## Routing Architecture

| Router  | ASN   | Neighbor     | Advertised Networks |
| ------- | ----- | ------------ | ------------------- |
| RB450G  | 64512 | `10.10.10.2` | LAN-A, DMZ          |
| RB750UP | 64513 | `10.10.10.1` | LAN-B               |

---

## WAN Access

The external WAN uplink is provided by smartphone USB-C Ethernet tethering.

* smartphone acts as DHCP server
* RB450G receives WAN parameters dynamically
* default route is learned automatically
* NAT is performed at WAN edge

---

## Traffic Flow Example

```text id="m8yy5t"
Internet (smartphone tethering)
    ↓
RB450G (NAT + DNS + WAN edge)
    ↓
RB750UP (Transit routing)
    ↓
RB2011 (Site 2 access router)
    ↓
LAN / WLAN clients
```

---

## Security Notes

* DMZ isolated from LAN
* controlled inter-zone routing
* internal DNS only for trusted segments
* HTTPS protected services with internal CA

---

## Design Goal

RADIONET was designed to reproduce a simplified enterprise infrastructure using real hardware and RouterOS features while preserving clear segmentation principles.

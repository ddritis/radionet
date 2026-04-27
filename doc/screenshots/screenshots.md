## HTTPS validation

![Homepage HTTPS](screenshot_010_homepage_HTTPS.png)

*Homepage served over HTTPS using a locally trusted certificate.*

![Secure connection](screenshot_020_connection_secure.png)

*Browser confirms trusted TLS connection for internal domain access.*

![Security details](screenshot_030_security_details.png)

*TLS encryption details visible from browser security panel.*

![Certificate details](screenshot_040_radionet.lab.png)

*Server certificate issued for www.radionet.lab with SAN support.*

---

## Certificate Authority

![Local CA](screenshot_050_radionet_CA.png)

*Local certification authority used to sign internal server certificates.*

![Windows certificate manager](screenshot_080_Windows_cert_manager.png)

*Root CA imported into Windows trusted certificate store.*

---

## MikroTik routing and firewall

![RB450 configuration](screenshot_060_Winbox_RB450G.png)

*RB450 core router managing static routes and DNS records.*

![RB951 firewall](screenshot_070_Winbox_RB951.png)

*RB951 firewall enforcing LAN and DMZ segmentation.*

---

## Raspberry Pi servers

![Raspberry Pi 5](screenshot_090_RaspberryPi5_Fastfetch.png)

*Raspberry Pi 5 used for certificate generation and CA services.*

![Raspberry Pi 4](screenshot_091_RaspberryPi4_Fastfetch.png)

*Raspberry Pi 4 hosting HTTPS web services.*

![Network sockets](screenshot_092_RaspberryPi4_network_connections.png)

*Service bindings showing local database isolation and active listeners.*
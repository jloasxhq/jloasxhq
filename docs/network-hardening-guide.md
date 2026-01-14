# Network Hardening Guide

**Author:** Josh Merritt, CTO @ QUX Technologies
**Last Updated:** January 2026

---

## Table of Contents

1. [Introduction](#introduction)
2. [Network Architecture](#network-architecture)
3. [Firewall Hardening](#firewall-hardening)
4. [Router & Switch Security](#router--switch-security)
5. [VPN Security](#vpn-security)
6. [Wireless Security](#wireless-security)
7. [DNS Security](#dns-security)
8. [TLS/SSL Configuration](#tlsssl-configuration)
9. [Network Monitoring](#network-monitoring)
10. [Segmentation Strategies](#segmentation-strategies)
11. [Cloud Network Security](#cloud-network-security)
12. [Incident Response](#incident-response)
13. [Compliance Mapping](#compliance-mapping)
14. [Hardening Checklists](#hardening-checklists)

---

## Introduction

Network hardening is the process of securing network infrastructure by reducing the attack surface, eliminating vulnerabilities, and implementing defense-in-depth strategies. This guide provides practical guidance for securing enterprise networks.

### Core Principles

1. **Defense in Depth** - Multiple layers of security controls
2. **Least Privilege** - Minimum necessary access
3. **Zero Trust** - Never trust, always verify
4. **Segmentation** - Isolate critical assets
5. **Visibility** - Monitor everything

### Threat Landscape

| Threat | Description | Mitigation |
|--------|-------------|------------|
| Reconnaissance | Network scanning, enumeration | IDS/IPS, port security |
| Man-in-the-Middle | Traffic interception | Encryption, certificate pinning |
| DDoS | Service disruption | Rate limiting, CDN, scrubbing |
| Lateral Movement | Internal propagation | Segmentation, micro-segmentation |
| Data Exfiltration | Unauthorized data transfer | DLP, egress filtering |
| Credential Theft | Password/token compromise | MFA, network access control |

---

## Network Architecture

### Secure Architecture Principles

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SECURE NETWORK ARCHITECTURE                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│                         ┌─────────────┐                             │
│                         │  INTERNET   │                             │
│                         └──────┬──────┘                             │
│                                │                                     │
│                         ┌──────▼──────┐                             │
│                         │   EDGE FW   │  ← DDoS Protection          │
│                         └──────┬──────┘                             │
│                                │                                     │
│              ┌─────────────────┼─────────────────┐                  │
│              │                 │                 │                   │
│       ┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼──────┐          │
│       │     DMZ     │   │   WAF/LB    │   │  VPN GW     │          │
│       │ (Mail/DNS)  │   │             │   │             │          │
│       └──────┬──────┘   └──────┬──────┘   └──────┬──────┘          │
│              │                 │                 │                   │
│              └─────────────────┼─────────────────┘                  │
│                                │                                     │
│                         ┌──────▼──────┐                             │
│                         │ INTERNAL FW │  ← East-West Filtering      │
│                         └──────┬──────┘                             │
│                                │                                     │
│         ┌──────────────────────┼──────────────────────┐             │
│         │                      │                      │              │
│  ┌──────▼──────┐        ┌──────▼──────┐       ┌──────▼──────┐      │
│  │  CORPORATE  │        │ APPLICATION │       │   DATABASE  │      │
│  │   NETWORK   │        │    TIER     │       │    TIER     │      │
│  │  (Users)    │        │  (Servers)  │       │  (Data)     │      │
│  └─────────────┘        └─────────────┘       └─────────────┘      │
│                                                                      │
│  ┌─────────────┐        ┌─────────────┐       ┌─────────────┐      │
│  │ MANAGEMENT  │        │    OT/IOT   │       │  SENSITIVE  │      │
│  │   NETWORK   │        │   NETWORK   │       │   ENCLAVE   │      │
│  │  (Admin)    │        │ (Isolated)  │       │   (CUI)     │      │
│  └─────────────┘        └─────────────┘       └─────────────┘      │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Zone Definitions

| Zone | Purpose | Security Level | Access |
|------|---------|----------------|--------|
| Internet | External connectivity | Untrusted | N/A |
| DMZ | Public-facing services | Semi-trusted | Limited inbound |
| Corporate | End-user workstations | Internal | Authenticated users |
| Application | Business applications | Protected | Service accounts |
| Database | Data storage | Restricted | Application tier only |
| Management | Network administration | Highly restricted | Admins only |
| Sensitive | CUI/PII/PHI | Maximum | Need-to-know |

### Traffic Flow Rules

```
ALLOWED FLOWS:
Internet → DMZ (specific ports)
DMZ → Application (specific services)
Application → Database (database ports)
Corporate → Application (authenticated)
Management → All (authenticated + MFA)

DENIED FLOWS:
Internet → Internal (all)
Database → Internet (all)
Corporate → Database (direct)
Any → Management (unauthenticated)
```

---

## Firewall Hardening

### Rule Management Best Practices

1. **Default Deny** - Block all, permit by exception
2. **Rule Documentation** - Every rule needs justification
3. **Regular Review** - Quarterly rule audits minimum
4. **Change Control** - Formal change management process
5. **Testing** - Validate rules before production

### Firewall Rule Template

```
┌────────────────────────────────────────────────────────────────┐
│ RULE: [ID]                                                      │
├────────────────────────────────────────────────────────────────┤
│ Source:        [IP/Network/Group]                              │
│ Destination:   [IP/Network/Group]                              │
│ Service:       [Port/Protocol]                                 │
│ Action:        [Allow/Deny]                                    │
│ Logging:       [Yes/No]                                        │
│ Schedule:      [Always/Time-based]                             │
│ Justification: [Business reason]                               │
│ Owner:         [Responsible party]                             │
│ Review Date:   [Next review]                                   │
│ Ticket:        [Change ticket #]                               │
└────────────────────────────────────────────────────────────────┘
```

### Essential Firewall Rules

**Inbound (Internet → DMZ)**
```
# Web Traffic
ALLOW TCP Internet → Web_Servers:443 (HTTPS)
ALLOW TCP Internet → Web_Servers:80 (HTTP→HTTPS redirect only)

# Email (if applicable)
ALLOW TCP Internet → Mail_Server:25 (SMTP)
ALLOW TCP Internet → Mail_Server:587 (Submission)
ALLOW TCP Internet → Mail_Server:993 (IMAPS)

# VPN
ALLOW UDP Internet → VPN_Gateway:51820 (WireGuard)
ALLOW UDP Internet → VPN_Gateway:1194 (OpenVPN)

# Deny all else
DENY ALL Internet → DMZ LOG
```

**Outbound (Internal → Internet)**
```
# Permitted outbound
ALLOW TCP Internal → Internet:443 (HTTPS)
ALLOW TCP Internal → Internet:80 (HTTP)
ALLOW UDP Internal → DNS_Servers:53 (DNS)
ALLOW TCP Internal → Internet:22 (SSH - restricted)

# Block dangerous outbound
DENY TCP Internal → Internet:23 (Telnet)
DENY TCP Internal → Internet:3389 (RDP)
DENY TCP Internal → Internet:445 (SMB)
DENY TCP Internal → Internet:137-139 (NetBIOS)

# Default deny with logging
DENY ALL Internal → Internet LOG
```

### iptables/nftables Hardening

```bash
# Flush existing rules
iptables -F
iptables -X

# Set default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Anti-spoofing
iptables -A INPUT -s 10.0.0.0/8 -i eth0 -j DROP
iptables -A INPUT -s 172.16.0.0/12 -i eth0 -j DROP
iptables -A INPUT -s 192.168.0.0/16 -i eth0 -j DROP
iptables -A INPUT -s 127.0.0.0/8 -i eth0 -j DROP

# Rate limiting
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j DROP

# Log dropped packets
iptables -A INPUT -j LOG --log-prefix "IPT_DROP: " --log-level 4
iptables -A INPUT -j DROP
```

### UFW Quick Hardening

```bash
# Reset and enable
ufw --force reset
ufw default deny incoming
ufw default deny outgoing

# Allow specific services
ufw allow in 22/tcp comment 'SSH'
ufw allow in 443/tcp comment 'HTTPS'
ufw allow out 53 comment 'DNS'
ufw allow out 443/tcp comment 'HTTPS'
ufw allow out 80/tcp comment 'HTTP'

# Enable logging
ufw logging on

# Enable firewall
ufw enable
```

---

## Router & Switch Security

### Router Hardening Checklist

**Access Control**
- [ ] Change default credentials
- [ ] Disable unused interfaces
- [ ] Implement ACLs on VTY lines
- [ ] Use SSH instead of Telnet
- [ ] Configure authentication timeout
- [ ] Limit concurrent sessions

**Services**
- [ ] Disable CDP/LLDP on external interfaces
- [ ] Disable HTTP server (use HTTPS only)
- [ ] Disable unused services (finger, echo, etc.)
- [ ] Disable source routing
- [ ] Disable proxy ARP
- [ ] Disable IP directed broadcast

**Routing**
- [ ] Authenticate routing protocols (MD5/SHA)
- [ ] Filter routing updates
- [ ] Implement BCP38 (anti-spoofing)
- [ ] Configure route filtering

### Cisco IOS Hardening

```
! Disable unnecessary services
no ip http server
no ip http secure-server
no cdp run
no ip source-route
no ip finger
no ip bootp server
no service tcp-small-servers
no service udp-small-servers
no ip identd

! Enable security features
service password-encryption
security passwords min-length 12
login block-for 120 attempts 3 within 60

! Configure SSH
ip ssh version 2
ip ssh time-out 60
ip ssh authentication-retries 3
crypto key generate rsa modulus 4096

! Logging
logging buffered 16384
logging console critical
logging trap informational
logging source-interface Loopback0

! NTP with authentication
ntp authenticate
ntp authentication-key 1 md5 [key]
ntp trusted-key 1
ntp server [ip] key 1

! Banner
banner login ^
*********************************************************************
* UNAUTHORIZED ACCESS PROHIBITED                                      *
* This system is for authorized users only. All activity is logged.  *
*********************************************************************
^

! VTY hardening
line vty 0 4
 access-class VTY_ACCESS in
 transport input ssh
 exec-timeout 5 0
 login local
```

### Switch Hardening

**Port Security**
```
! Enable port security
interface range GigabitEthernet0/1-24
 switchport mode access
 switchport port-security
 switchport port-security maximum 2
 switchport port-security violation shutdown
 switchport port-security aging time 60
 spanning-tree portfast
 spanning-tree bpduguard enable
```

**VLAN Security**
```
! Native VLAN hardening
vlan 999
 name NATIVE_UNUSED

interface range GigabitEthernet0/1-24
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30

! Disable DTP
interface range GigabitEthernet0/1-24
 switchport nonegotiate
```

**DHCP Snooping**
```
ip dhcp snooping
ip dhcp snooping vlan 10,20,30

interface GigabitEthernet0/1
 ip dhcp snooping trust  ! Uplink to DHCP server

interface range GigabitEthernet0/2-24
 ip dhcp snooping limit rate 10
```

**Dynamic ARP Inspection**
```
ip arp inspection vlan 10,20,30

interface GigabitEthernet0/1
 ip arp inspection trust  ! Uplink

interface range GigabitEthernet0/2-24
 ip arp inspection limit rate 100
```

---

## VPN Security

### VPN Protocol Comparison

| Protocol | Security | Performance | Use Case |
|----------|----------|-------------|----------|
| WireGuard | Excellent | Excellent | Modern deployments |
| OpenVPN | Excellent | Good | Cross-platform |
| IPsec/IKEv2 | Excellent | Good | Site-to-site, mobile |
| L2TP/IPsec | Good | Fair | Legacy compatibility |
| PPTP | Poor | Good | **AVOID - Broken** |

### WireGuard Hardening

```ini
# /etc/wireguard/wg0.conf

[Interface]
Address = 10.200.0.1/24
ListenPort = 51820
PrivateKey = [SERVER_PRIVATE_KEY]

# Firewall rules on startup
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# DNS for clients
DNS = 10.200.0.1

[Peer]
# Client 1
PublicKey = [CLIENT_PUBLIC_KEY]
AllowedIPs = 10.200.0.2/32
PresharedKey = [PRESHARED_KEY]  # Additional layer of security
```

**WireGuard Best Practices:**
- Use PresharedKey for post-quantum resistance
- Rotate keys periodically
- Implement AllowedIPs strictly
- Use separate keys per device
- Monitor handshake timestamps

### OpenVPN Hardening

```
# server.conf

# Network
port 1194
proto udp
dev tun

# Certificates
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh4096.pem
tls-crypt /etc/openvpn/tls-crypt.key

# Security
cipher AES-256-GCM
auth SHA512
tls-version-min 1.3
tls-cipher TLS-AES-256-GCM-SHA384

# Hardening
remote-cert-tls client
verify-client-cert require
tls-verify "/etc/openvpn/verify.sh"

# Prevent downgrade attacks
ncp-ciphers AES-256-GCM

# Logging
log-append /var/log/openvpn/openvpn.log
verb 3
mute 20

# Performance
sndbuf 0
rcvbuf 0
push "sndbuf 0"
push "rcvbuf 0"

# Client restrictions
max-clients 100
client-to-client
duplicate-cn
```

### IPsec/IKEv2 Configuration

**strongSwan (ipsec.conf)**
```
config setup
    charondebug="ike 2, knl 2, cfg 2"
    uniqueids=yes

conn %default
    keyexchange=ikev2
    ike=aes256gcm16-prfsha384-ecp384!
    esp=aes256gcm16-ecp384!
    dpdaction=clear
    dpddelay=300s
    rekey=no
    left=%any
    leftid=@vpn.example.com
    leftcert=server.crt
    leftsendcert=always
    leftsubnet=0.0.0.0/0
    right=%any
    rightid=%any
    rightauth=eap-mschapv2
    rightsourceip=10.10.10.0/24
    rightdns=10.10.10.1
    eap_identity=%identity
    auto=add
```

---

## Wireless Security

### Wireless Security Standards

| Standard | Security | Status |
|----------|----------|--------|
| WEP | None | **DEPRECATED** |
| WPA | Weak | **DEPRECATED** |
| WPA2-Personal | Good | Legacy |
| WPA2-Enterprise | Excellent | Recommended |
| WPA3-Personal | Excellent | Recommended |
| WPA3-Enterprise | Excellent | Best |

### WPA3-Enterprise Configuration

**FreeRADIUS Configuration**
```
# /etc/freeradius/3.0/sites-available/default

server default {
    listen {
        type = auth
        ipaddr = *
        port = 1812
    }

    authorize {
        filter_username
        preprocess
        eap {
            ok = return
        }
        expiration
        logintime
    }

    authenticate {
        eap
    }
}
```

**EAP Configuration**
```
# /etc/freeradius/3.0/mods-available/eap

eap {
    default_eap_type = tls
    timer_expire = 60
    ignore_unknown_eap_types = no
    cisco_accounting_username_bug = no

    tls-config tls-common {
        private_key_file = /etc/freeradius/certs/server.key
        certificate_file = /etc/freeradius/certs/server.crt
        ca_file = /etc/freeradius/certs/ca.crt
        dh_file = /etc/freeradius/certs/dh4096.pem
        ca_path = /etc/freeradius/certs
        cipher_list = "ECDHE+AESGCM"
        cipher_server_preference = yes
        tls_min_version = "1.2"
        tls_max_version = "1.3"
        ecdh_curve = "secp384r1"
    }

    tls {
        tls = tls-common
    }

    peap {
        tls = tls-common
        default_eap_type = mschapv2
        virtual_server = "inner-tunnel"
    }
}
```

### Wireless Best Practices

1. **Network Isolation**
   - Separate SSIDs for corporate, guest, IoT
   - VLAN segmentation
   - Client isolation on guest networks

2. **Authentication**
   - WPA3-Enterprise with EAP-TLS (certificate-based)
   - RADIUS server with MFA integration
   - Certificate-based authentication for managed devices

3. **Access Point Hardening**
   - Change default credentials
   - Disable WPS
   - Enable management frame protection (802.11w)
   - Disable unused features
   - Regular firmware updates

4. **Monitoring**
   - Wireless IDS/IPS
   - Rogue AP detection
   - Client tracking
   - Signal strength monitoring

---

## DNS Security

### DNS Hardening

**BIND9 Security Configuration**
```
// /etc/bind/named.conf.options

options {
    directory "/var/cache/bind";

    // Disable recursion for external
    recursion no;
    allow-recursion { localhost; internal_nets; };

    // Disable zone transfers
    allow-transfer { none; };

    // Hide version
    version "not disclosed";

    // Disable additional section processing
    minimal-responses yes;

    // Rate limiting
    rate-limit {
        responses-per-second 10;
        window 5;
    };

    // DNSSEC validation
    dnssec-validation auto;

    // Query logging
    querylog yes;
};

// ACL for internal networks
acl internal_nets {
    10.0.0.0/8;
    172.16.0.0/12;
    192.168.0.0/16;
    localhost;
};
```

### DNSSEC Implementation

```bash
# Generate zone signing key (ZSK)
dnssec-keygen -a ECDSAP384SHA384 -n ZONE example.com

# Generate key signing key (KSK)
dnssec-keygen -a ECDSAP384SHA384 -n ZONE -f KSK example.com

# Sign zone
dnssec-signzone -A -3 $(head -c 1000 /dev/random | sha1sum | cut -b 1-16) \
    -N INCREMENT -o example.com -t db.example.com
```

### DNS over HTTPS/TLS

**Configure DNS-over-TLS (Unbound)**
```yaml
# /etc/unbound/unbound.conf

server:
    interface: 127.0.0.1
    interface: ::1
    port: 53

    # TLS configuration
    tls-service-key: "/etc/unbound/server.key"
    tls-service-pem: "/etc/unbound/server.crt"
    tls-port: 853

    # Security
    hide-identity: yes
    hide-version: yes
    harden-glue: yes
    harden-dnssec-stripped: yes
    harden-referral-path: yes

    # Privacy
    qname-minimisation: yes
    aggressive-nsec: yes

    # Performance
    prefetch: yes
    prefetch-key: yes

forward-zone:
    name: "."
    forward-tls-upstream: yes
    forward-addr: 1.1.1.1@853#cloudflare-dns.com
    forward-addr: 1.0.0.1@853#cloudflare-dns.com
```

---

## TLS/SSL Configuration

### TLS Best Practices

| Setting | Recommended | Avoid |
|---------|-------------|-------|
| Protocol | TLS 1.3, TLS 1.2 | SSLv2, SSLv3, TLS 1.0, TLS 1.1 |
| Key Exchange | ECDHE | RSA, DH |
| Cipher | AES-256-GCM, ChaCha20-Poly1305 | DES, 3DES, RC4 |
| Hash | SHA-384, SHA-256 | MD5, SHA-1 |
| Certificate | RSA 4096 or ECDSA P-384 | RSA < 2048 |

### Nginx TLS Configuration

```nginx
# /etc/nginx/snippets/ssl-hardened.conf

# Protocols
ssl_protocols TLSv1.3 TLSv1.2;

# Ciphers (TLS 1.2)
ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305';
ssl_prefer_server_ciphers on;

# TLS 1.3 ciphers (automatic in modern OpenSSL)
ssl_conf_command Ciphersuites TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256;

# Key exchange
ssl_ecdh_curve secp384r1;
ssl_dhparam /etc/nginx/dhparam4096.pem;

# Session
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:50m;
ssl_session_tickets off;

# OCSP Stapling
ssl_stapling on;
ssl_stapling_verify on;
resolver 1.1.1.1 8.8.8.8 valid=300s;
resolver_timeout 5s;

# HSTS
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

# Additional security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
```

### Certificate Management

**Let's Encrypt with Certbot**
```bash
# Install
apt install certbot python3-certbot-nginx

# Obtain certificate
certbot certonly --nginx -d example.com -d www.example.com \
    --rsa-key-size 4096 \
    --must-staple \
    --staple-ocsp

# Auto-renewal
certbot renew --dry-run

# Cron job
echo "0 3 * * * /usr/bin/certbot renew --quiet --post-hook 'systemctl reload nginx'" | crontab -
```

**Certificate Pinning Considerations**
```
# HPKP is deprecated - use Certificate Transparency instead
# Monitor CT logs for unauthorized certificates

# Alternative: DNS CAA records
example.com. IN CAA 0 issue "letsencrypt.org"
example.com. IN CAA 0 issuewild ";"
example.com. IN CAA 0 iodef "mailto:security@example.com"
```

---

## Network Monitoring

### Essential Monitoring Points

```
┌─────────────────────────────────────────────────────────────────┐
│                    MONITORING ARCHITECTURE                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │
│   │   NetFlow   │    │   SNMP      │    │   Syslog    │        │
│   │  Collector  │    │  Polling    │    │   Server    │        │
│   └──────┬──────┘    └──────┬──────┘    └──────┬──────┘        │
│          │                  │                  │                 │
│          └──────────────────┼──────────────────┘                │
│                             │                                    │
│                      ┌──────▼──────┐                            │
│                      │    SIEM     │                            │
│                      │  Platform   │                            │
│                      └──────┬──────┘                            │
│                             │                                    │
│          ┌──────────────────┼──────────────────┐                │
│          │                  │                  │                 │
│   ┌──────▼──────┐    ┌──────▼──────┐    ┌──────▼──────┐        │
│   │  Dashboards │    │   Alerts    │    │  Forensics  │        │
│   └─────────────┘    └─────────────┘    └─────────────┘        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Critical Metrics

| Category | Metric | Alert Threshold |
|----------|--------|-----------------|
| Availability | Interface status | Down > 30s |
| Availability | Ping latency | > 100ms |
| Performance | Bandwidth utilization | > 80% |
| Performance | Packet loss | > 1% |
| Security | Failed logins | > 5/minute |
| Security | Firewall denies | > 100/minute |
| Security | IDS alerts | Any critical |
| Security | New connections | Anomaly detection |

### IDS/IPS Configuration (Suricata)

```yaml
# /etc/suricata/suricata.yaml

vars:
  address-groups:
    HOME_NET: "[10.0.0.0/8,172.16.0.0/12,192.168.0.0/16]"
    EXTERNAL_NET: "!$HOME_NET"

  port-groups:
    HTTP_PORTS: "80,443,8080,8443"
    SSH_PORTS: "22"

af-packet:
  - interface: eth0
    threads: auto
    cluster-type: cluster_flow
    defrag: yes

outputs:
  - eve-log:
      enabled: yes
      filetype: regular
      filename: eve.json
      types:
        - alert:
            tagged-packets: yes
        - anomaly:
            enabled: yes
        - http:
            extended: yes
        - dns:
            query: yes
            answer: yes
        - tls:
            extended: yes
        - files:
            force-magic: yes
        - ssh
        - flow

rule-files:
  - suricata.rules
  - /etc/suricata/rules/*.rules
```

### Log Management

**Rsyslog Configuration**
```
# /etc/rsyslog.d/50-network.conf

# Template for network logs
template(name="NetworkLogFormat" type="string"
    string="%TIMESTAMP% %HOSTNAME% %syslogtag%%msg%\n")

# Firewall logs
:msg, contains, "IPT_" /var/log/firewall.log;NetworkLogFormat
& stop

# Switch/router logs
:fromhost-ip, isequal, "10.0.0.1" /var/log/network/router.log;NetworkLogFormat
& stop

# Remote logging (TLS)
action(type="omfwd" target="siem.example.com" port="6514" protocol="tcp"
    StreamDriver="gtls"
    StreamDriverMode="1"
    StreamDriverAuthMode="x509/name")
```

---

## Segmentation Strategies

### Micro-Segmentation

```
┌─────────────────────────────────────────────────────────────────┐
│                    MICRO-SEGMENTATION                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Traditional Flat Network:                                      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  [Web] [App] [DB] [User] [Admin] [IoT] - All connected  │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                  │
│  Micro-Segmented Network:                                       │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐           │
│  │   Web   │  │   App   │  │   DB    │  │  Users  │           │
│  │ Segment │◄─┼─►Segment │◄─┼─►Segment │  │ Segment │           │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘           │
│       │            │            │            │                   │
│       └────────────┴────────────┴────────────┘                  │
│                         │                                        │
│              Controlled by Policy Engine                         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### VLAN Design

| VLAN ID | Name | Subnet | Purpose |
|---------|------|--------|---------|
| 10 | MGMT | 10.10.10.0/24 | Network management |
| 20 | SERVERS | 10.10.20.0/24 | Production servers |
| 30 | USERS | 10.10.30.0/24 | End-user workstations |
| 40 | VOICE | 10.10.40.0/24 | VoIP phones |
| 50 | GUEST | 10.10.50.0/24 | Guest WiFi |
| 60 | IOT | 10.10.60.0/24 | IoT devices |
| 100 | DMZ | 10.10.100.0/24 | Public-facing servers |
| 999 | QUARANTINE | 10.10.99.0/24 | Compromised devices |

### Zero Trust Implementation

**Principles:**
1. Verify explicitly - Always authenticate and authorize
2. Least privilege - Just-in-time and just-enough access
3. Assume breach - Minimize blast radius, segment access

**Components:**
- Identity-aware proxy
- Software-defined perimeter
- Continuous verification
- Encrypted communications
- Micro-segmentation

---

## Cloud Network Security

### AWS Security Groups

```hcl
# Terraform example

resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Web server security group"
  vpc_id      = aws_vpc.main.id

  # HTTPS from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  # HTTP redirect only
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP redirect"
  }

  # Egress to app tier only
  egress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
    description     = "To app tier"
  }

  tags = {
    Name = "web-sg"
  }
}
```

### Network ACLs vs Security Groups

| Feature | Security Group | Network ACL |
|---------|---------------|-------------|
| Level | Instance | Subnet |
| State | Stateful | Stateless |
| Rules | Allow only | Allow and Deny |
| Evaluation | All rules | Ordered |
| Default | Deny all inbound | Allow all |

### VPC Flow Logs

```hcl
resource "aws_flow_log" "main" {
  vpc_id                   = aws_vpc.main.id
  traffic_type             = "ALL"
  log_destination_type     = "cloud-watch-logs"
  log_destination          = aws_cloudwatch_log_group.flow_logs.arn
  iam_role_arn             = aws_iam_role.flow_logs.arn
  max_aggregation_interval = 60

  tags = {
    Name = "vpc-flow-logs"
  }
}
```

---

## Incident Response

### Network Incident Categories

| Category | Examples | Response |
|----------|----------|----------|
| Intrusion | Unauthorized access | Isolate, investigate, remediate |
| DoS/DDoS | Traffic flood | Upstream filtering, rate limiting |
| Data Breach | Exfiltration | Contain, preserve evidence |
| Malware | Worm propagation | Quarantine, scan, clean |
| Insider | Unauthorized activity | Monitor, restrict, investigate |

### Incident Response Playbook

```
┌─────────────────────────────────────────────────────────────────┐
│                  NETWORK INCIDENT RESPONSE                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. DETECTION                                                    │
│     ├─ SIEM alert received                                      │
│     ├─ Validate alert (true positive?)                          │
│     └─ Assign severity level                                    │
│                                                                  │
│  2. CONTAINMENT                                                  │
│     ├─ Isolate affected systems (VLAN quarantine)               │
│     ├─ Block malicious IPs at firewall                          │
│     ├─ Disable compromised accounts                             │
│     └─ Preserve evidence (packet captures, logs)                │
│                                                                  │
│  3. ERADICATION                                                  │
│     ├─ Identify root cause                                      │
│     ├─ Remove malware/backdoors                                 │
│     ├─ Patch vulnerabilities                                    │
│     └─ Update firewall rules                                    │
│                                                                  │
│  4. RECOVERY                                                     │
│     ├─ Restore from clean backups                               │
│     ├─ Verify system integrity                                  │
│     ├─ Monitor for re-infection                                 │
│     └─ Gradual return to production                             │
│                                                                  │
│  5. LESSONS LEARNED                                              │
│     ├─ Document incident timeline                               │
│     ├─ Identify improvements                                    │
│     ├─ Update playbooks                                         │
│     └─ Conduct post-incident review                             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Emergency Isolation Commands

```bash
# Immediate host isolation (iptables)
iptables -I INPUT -s <compromised_ip> -j DROP
iptables -I OUTPUT -d <compromised_ip> -j DROP
iptables -I FORWARD -s <compromised_ip> -j DROP
iptables -I FORWARD -d <compromised_ip> -j DROP

# Block at switch (Cisco)
conf t
interface GigabitEthernet0/5
 shutdown
end

# Move to quarantine VLAN
conf t
interface GigabitEthernet0/5
 switchport access vlan 999
 no shutdown
end

# Capture traffic for forensics
tcpdump -i eth0 -w /evidence/capture_$(date +%Y%m%d_%H%M%S).pcap host <target_ip>
```

---

## Compliance Mapping

### Framework Alignment

| Control | NIST 800-53 | CIS Controls | CMMC | PCI DSS |
|---------|-------------|--------------|------|---------|
| Firewall | SC-7 | 4.4, 4.5 | SC.L2-3.13.1 | 1.1-1.4 |
| Segmentation | SC-7(21) | 12.1 | SC.L2-3.13.5 | 1.2 |
| IDS/IPS | SI-4 | 13.2, 13.3 | SI.L2-3.14.6 | 11.4 |
| Encryption | SC-8, SC-13 | 3.10 | SC.L2-3.13.8 | 4.1 |
| Logging | AU-2, AU-3 | 8.2-8.5 | AU.L2-3.3.1 | 10.1-10.3 |
| VPN | SC-8(1) | 3.10 | SC.L2-3.13.8 | 4.1 |
| Wireless | AC-18 | 15.1-15.7 | AC.L2-3.1.16 | 4.1.1 |

---

## Hardening Checklists

### Firewall Checklist

- [ ] Default deny policy configured
- [ ] Unused ports/services blocked
- [ ] Anti-spoofing rules enabled
- [ ] Logging enabled for denies
- [ ] Rate limiting configured
- [ ] Geographic blocking (if applicable)
- [ ] Regular rule review scheduled
- [ ] Change management process in place
- [ ] Backup configuration stored securely
- [ ] Firmware up to date

### Router/Switch Checklist

- [ ] Default credentials changed
- [ ] SSH enabled, Telnet disabled
- [ ] Unused ports disabled
- [ ] Port security enabled
- [ ] DHCP snooping enabled
- [ ] Dynamic ARP inspection enabled
- [ ] 802.1X configured (if applicable)
- [ ] Spanning tree protection enabled
- [ ] Routing protocol authentication
- [ ] Management VLAN isolated
- [ ] Logging configured
- [ ] NTP with authentication
- [ ] Firmware up to date

### Wireless Checklist

- [ ] WPA3-Enterprise or WPA2-Enterprise
- [ ] Strong RADIUS configuration
- [ ] Guest network isolated
- [ ] Rogue AP detection enabled
- [ ] WPS disabled
- [ ] Management interface secured
- [ ] Firmware up to date
- [ ] Client isolation enabled (guest)
- [ ] MAC filtering (additional layer)
- [ ] Signal strength optimized

### VPN Checklist

- [ ] Strong encryption (AES-256-GCM)
- [ ] Perfect forward secrecy enabled
- [ ] Certificate-based authentication
- [ ] MFA implemented
- [ ] Split tunneling disabled (if required)
- [ ] Kill switch enabled
- [ ] DNS leak protection
- [ ] Logging configured
- [ ] Regular key rotation
- [ ] Connection timeout configured

---

## Resources

### Standards & Frameworks

- [NIST SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) - Security Controls
- [CIS Controls](https://www.cisecurity.org/controls) - Security Best Practices
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks) - Hardening Guides
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

### Tools

| Tool | Purpose |
|------|---------|
| Nmap | Network scanning |
| Wireshark | Packet analysis |
| Suricata | IDS/IPS |
| Zeek | Network analysis |
| OpenVAS | Vulnerability scanning |
| Ansible | Configuration management |

### Learning Resources

- [SANS Reading Room](https://www.sans.org/reading-room/)
- [Cisco Security Guide](https://www.cisco.com/c/en/us/support/security/index.html)
- [AWS Security Best Practices](https://aws.amazon.com/security/)

---

## About the Author

Josh Merritt is the CTO of QUX Technologies, specializing in network security, CMMC compliance, and secure infrastructure design. With extensive experience in network engineering and security architecture, he builds and secures enterprise networks for privacy-focused applications.

---

*This guide is provided for educational purposes. Always test configurations in a lab environment before production deployment. Security requirements vary by organization and regulatory environment.*

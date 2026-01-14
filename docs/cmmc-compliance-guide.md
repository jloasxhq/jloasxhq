# CMMC 2.0 Compliance Guide

**Author:** Josh Merritt, CTO @ QUX Technologies
**Last Updated:** January 2026

---

## Table of Contents

1. [Introduction](#introduction)
2. [CMMC 2.0 Overview](#cmmc-20-overview)
3. [CMMC Levels](#cmmc-levels)
4. [The 14 Domains](#the-14-domains)
5. [Assessment Process](#assessment-process)
6. [Implementation Roadmap](#implementation-roadmap)
7. [Technical Controls](#technical-controls)
8. [Documentation Requirements](#documentation-requirements)
9. [Common Pitfalls](#common-pitfalls)
10. [Resources](#resources)

---

## Introduction

The Cybersecurity Maturity Model Certification (CMMC) is a unified cybersecurity standard for the Defense Industrial Base (DIB). It's designed to protect Federal Contract Information (FCI) and Controlled Unclassified Information (CUI) across the defense supply chain.

### Who Needs CMMC?

- Prime contractors to the Department of Defense
- Subcontractors handling FCI or CUI
- Any organization in the DoD supply chain
- Companies bidding on DoD contracts requiring CMMC

### Why CMMC Matters

- **Contractual Requirement:** Required for DoD contract eligibility
- **Supply Chain Security:** Protects sensitive defense information
- **Competitive Advantage:** Certified organizations stand out in bidding
- **Risk Reduction:** Structured approach to cybersecurity

---

## CMMC 2.0 Overview

CMMC 2.0 simplified the original 5-level model into 3 levels, aligning more closely with existing NIST standards.

### Key Changes from CMMC 1.0

| Aspect | CMMC 1.0 | CMMC 2.0 |
|--------|----------|----------|
| Levels | 5 levels | 3 levels |
| Practices | 171 practices | Aligned with NIST 800-171 |
| Assessment | All third-party | Self-assessment option for Level 1 |
| POA&Ms | Not allowed | Allowed with conditions |
| Waivers | Not available | Available for mission-critical cases |

### Timeline

- **2021:** CMMC 2.0 announced
- **2023:** Rulemaking process
- **2024-2025:** Phased implementation begins
- **2026+:** Full enforcement in contracts

---

## CMMC Levels

### Level 1: Foundational

**Purpose:** Protect Federal Contract Information (FCI)

| Attribute | Details |
|-----------|---------|
| Practices | 17 practices |
| Based On | FAR 52.204-21 |
| Assessment | Annual self-assessment |
| Affirmation | Senior official affirmation required |

**Who Needs Level 1:**
- Organizations handling only FCI
- Lower-tier subcontractors
- Commercial item contractors

### Level 2: Advanced

**Purpose:** Protect Controlled Unclassified Information (CUI)

| Attribute | Details |
|-----------|---------|
| Practices | 110 practices |
| Based On | NIST SP 800-171 Rev 2 |
| Assessment | Third-party (C3PAO) or self-assessment* |
| Frequency | Triennial assessment |

*Self-assessment allowed for non-critical CUI; third-party required for critical programs

**Who Needs Level 2:**
- Organizations handling CUI
- Most defense contractors
- Primary subcontractors

### Level 3: Expert

**Purpose:** Protect CUI against Advanced Persistent Threats (APTs)

| Attribute | Details |
|-----------|---------|
| Practices | 110+ practices (NIST 800-172 subset) |
| Based On | NIST SP 800-171 + NIST SP 800-172 |
| Assessment | Government-led (DIBCAC) |
| Frequency | Triennial assessment |

**Who Needs Level 3:**
- Highest priority programs
- Organizations facing nation-state threats
- Critical defense technologies

---

## The 14 Domains

CMMC organizes security practices into 14 domains aligned with NIST SP 800-171:

### 1. Access Control (AC)
**Practices:** 22 | **Focus:** Limiting system access

Key Requirements:
- Limit system access to authorized users
- Limit access to authorized transactions/functions
- Control remote access
- Limit unsuccessful login attempts
- Session timeouts and locks

### 2. Awareness and Training (AT)
**Practices:** 3 | **Focus:** Security awareness

Key Requirements:
- Security awareness training for all users
- Role-based training for privileged users
- Insider threat awareness

### 3. Audit and Accountability (AU)
**Practices:** 9 | **Focus:** Logging and monitoring

Key Requirements:
- Create and retain audit logs
- Ensure traceability to individual users
- Alert on audit process failures
- Correlate audit review and reporting
- Protect audit information

### 4. Configuration Management (CM)
**Practices:** 9 | **Focus:** Secure configurations

Key Requirements:
- Baseline configurations
- Security configuration settings
- Change management process
- Least functionality principle
- Software restrictions

### 5. Identification and Authentication (IA)
**Practices:** 11 | **Focus:** Identity verification

Key Requirements:
- Identify and authenticate users/devices
- Multi-factor authentication
- Replay-resistant authentication
- Identifier management
- Password requirements

### 6. Incident Response (IR)
**Practices:** 3 | **Focus:** Security incident handling

Key Requirements:
- Incident response capability
- Incident tracking and reporting
- Testing incident response

### 7. Maintenance (MA)
**Practices:** 6 | **Focus:** System maintenance security

Key Requirements:
- Controlled maintenance
- Maintenance tool controls
- Remote maintenance security
- Maintenance personnel oversight

### 8. Media Protection (MP)
**Practices:** 8 | **Focus:** Information media security

Key Requirements:
- Media protection policies
- Media access controls
- Media sanitization
- Media marking
- Media transport protection

### 9. Personnel Security (PS)
**Practices:** 2 | **Focus:** Personnel screening

Key Requirements:
- Screen individuals before access
- Protect CUI during personnel actions

### 10. Physical Protection (PE)
**Practices:** 6 | **Focus:** Physical security

Key Requirements:
- Limit physical access
- Manage physical access devices
- Escort visitors
- Maintain audit logs of physical access
- Control access to equipment

### 11. Risk Assessment (RA)
**Practices:** 3 | **Focus:** Risk identification

Key Requirements:
- Periodic risk assessments
- Vulnerability scanning
- Vulnerability remediation

### 12. Security Assessment (CA)
**Practices:** 4 | **Focus:** Security evaluation

Key Requirements:
- Assess security controls
- Plans of action and milestones
- Continuous monitoring
- System security plans

### 13. System and Communications Protection (SC)
**Practices:** 16 | **Focus:** Communications security

Key Requirements:
- Boundary protection
- Architectural design considerations
- Separation of user functionality
- Shared resource protection
- Network communications protection
- Cryptographic protections
- Session authenticity

### 14. System and Information Integrity (SI)
**Practices:** 7 | **Focus:** System integrity

Key Requirements:
- Flaw remediation
- Malicious code protection
- Security alerts and advisories
- System monitoring
- Input validation

---

## Assessment Process

### Level 1 Self-Assessment

```
┌─────────────────────────────────────────────────────┐
│                 Level 1 Process                      │
├─────────────────────────────────────────────────────┤
│  1. Implement 17 FAR 52.204-21 practices            │
│  2. Conduct self-assessment                          │
│  3. Document results in SPRS                         │
│  4. Senior official affirmation                      │
│  5. Annual reassessment                              │
└─────────────────────────────────────────────────────┘
```

### Level 2 Third-Party Assessment

```
┌─────────────────────────────────────────────────────┐
│              Level 2 C3PAO Process                   │
├─────────────────────────────────────────────────────┤
│  1. Prepare SSP and supporting documentation        │
│  2. Select accredited C3PAO                         │
│  3. Pre-assessment readiness review (optional)      │
│  4. Formal assessment (on-site + documentation)     │
│  5. Assessment report to CMMC-AB                    │
│  6. Certification decision                          │
│  7. POA&M closeout (if applicable)                  │
│  8. Triennial reassessment                          │
└─────────────────────────────────────────────────────┘
```

### Level 3 Government Assessment

```
┌─────────────────────────────────────────────────────┐
│              Level 3 DIBCAC Process                  │
├─────────────────────────────────────────────────────┤
│  1. Achieve Level 2 certification                   │
│  2. Implement NIST 800-172 enhanced controls        │
│  3. Request DIBCAC assessment                       │
│  4. Government-led assessment                       │
│  5. Certification decision                          │
│  6. Continuous monitoring requirements              │
└─────────────────────────────────────────────────────┘
```

### Supplier Performance Risk System (SPRS)

All assessments must be recorded in SPRS:
- **URL:** https://www.sprs.csd.disa.mil/
- **Score Range:** -203 to 110
- **Passing:** 110 (all controls implemented)
- **Minimum:** Varies by contract requirements

---

## Implementation Roadmap

### Phase 1: Gap Assessment (Weeks 1-4)

**Objective:** Understand current state vs. requirements

1. **Scope Definition**
   - Identify CUI boundaries
   - Map data flows
   - Define assessment scope

2. **Control Assessment**
   - Review each of 110 practices
   - Document current implementation status
   - Identify gaps

3. **Gap Analysis Report**
   - Prioritize gaps by risk
   - Estimate remediation effort
   - Create preliminary timeline

**Deliverables:**
- [ ] CUI data flow diagram
- [ ] Gap analysis spreadsheet
- [ ] Preliminary SSP outline

### Phase 2: Planning (Weeks 5-8)

**Objective:** Create actionable remediation plan

1. **Remediation Planning**
   - Define solutions for each gap
   - Estimate costs and resources
   - Identify dependencies

2. **Architecture Updates**
   - Design network segmentation
   - Plan encryption implementations
   - Define access control architecture

3. **Policy Development**
   - Draft required policies
   - Define procedures
   - Create templates

**Deliverables:**
- [ ] Remediation project plan
- [ ] Budget estimate
- [ ] Policy framework outline

### Phase 3: Implementation (Weeks 9-24)

**Objective:** Close gaps and implement controls

1. **Technical Controls**
   - Network segmentation
   - Encryption deployment
   - MFA implementation
   - SIEM/logging setup
   - Endpoint protection

2. **Administrative Controls**
   - Finalize policies
   - Conduct training
   - Implement procedures

3. **Physical Controls**
   - Access control systems
   - Visitor management
   - Media protection

**Deliverables:**
- [ ] Implemented technical controls
- [ ] Approved policies
- [ ] Completed training records

### Phase 4: Documentation (Weeks 20-28)

**Objective:** Create assessment-ready documentation

1. **System Security Plan (SSP)**
   - Document all 110 controls
   - Describe implementation details
   - Define shared responsibilities

2. **Supporting Documentation**
   - Network diagrams
   - Data flow diagrams
   - Policy documents
   - Procedures

3. **Evidence Collection**
   - Screenshots
   - Configuration exports
   - Audit logs
   - Training records

**Deliverables:**
- [ ] Complete SSP
- [ ] Evidence repository
- [ ] POA&M (if needed)

### Phase 5: Assessment (Weeks 28-32)

**Objective:** Achieve certification

1. **Pre-Assessment**
   - Internal assessment
   - Mock audit
   - Remediate findings

2. **C3PAO Assessment**
   - Document review
   - Technical testing
   - Interviews

3. **Certification**
   - Assessment report
   - POA&M closeout
   - Certificate issuance

---

## Technical Controls

### Network Segmentation

```
┌─────────────────────────────────────────────────────────────┐
│                    NETWORK ARCHITECTURE                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌─────────────┐         ┌─────────────────────────────┐  │
│   │  INTERNET   │────────▶│         FIREWALL            │  │
│   └─────────────┘         └──────────────┬──────────────┘  │
│                                          │                   │
│                    ┌─────────────────────┼────────────────┐ │
│                    │                     │                │ │
│         ┌─────────▼──────┐    ┌─────────▼──────┐        │ │
│         │      DMZ       │    │   CORPORATE    │        │ │
│         │  (Web/Email)   │    │    NETWORK     │        │ │
│         └────────────────┘    └───────┬────────┘        │ │
│                                       │                  │ │
│                            ┌──────────▼─────────┐       │ │
│                            │     CUI ENCLAVE    │       │ │
│                            │   (Segmented LAN)  │       │ │
│                            │   - Restricted     │       │ │
│                            │   - Monitored      │       │ │
│                            │   - Encrypted      │       │ │
│                            └────────────────────┘       │ │
│                                                          │ │
└─────────────────────────────────────────────────────────────┘
```

### Encryption Requirements

| Data State | Requirement | Recommended Solution |
|------------|-------------|---------------------|
| At Rest | FIPS 140-2 validated | AES-256 |
| In Transit | TLS 1.2+ | TLS 1.3 preferred |
| Removable Media | Encrypted | FIPS-validated full-disk encryption |
| Backups | Encrypted | AES-256 with key management |
| Email (CUI) | Encrypted | S/MIME or encrypted gateway |

### Multi-Factor Authentication

**Required For:**
- All remote access
- Privileged accounts
- Access to CUI systems
- Network devices

**Acceptable Factors:**

| Factor Type | Examples |
|-------------|----------|
| Something You Know | Password, PIN |
| Something You Have | Hardware token, smart card, phone |
| Something You Are | Fingerprint, facial recognition |

**Implementation Options:**
- Hardware tokens (YubiKey, RSA SecurID)
- Authenticator apps (Microsoft, Google, Duo)
- Smart cards (PIV/CAC)
- Push notifications
- FIDO2/WebAuthn

### Logging and Monitoring

**Required Log Sources:**
- Authentication events (success/failure)
- Privileged operations
- Access to CUI
- System events
- Network traffic (firewall, IDS)
- Email (if handling CUI)

**Retention Requirements:**
- Minimum: 1 year (contractual may require more)
- Recommended: 3 years
- Immutable storage preferred

**SIEM Capabilities:**
- Log aggregation
- Correlation rules
- Alerting
- Dashboards
- Incident investigation

### Endpoint Protection

| Capability | Level 1 | Level 2 | Level 3 |
|------------|---------|---------|---------|
| Antivirus/Antimalware | Required | Required | Required |
| EDR | Recommended | Required | Required |
| Host-based Firewall | Recommended | Required | Required |
| Full-Disk Encryption | — | Required | Required |
| Application Whitelisting | — | Recommended | Required |
| DLP | — | Recommended | Required |

---

## Documentation Requirements

### System Security Plan (SSP)

The SSP is the cornerstone of CMMC compliance. It must document:

**Required Sections:**
1. System identification and description
2. System environment
3. System interconnections
4. Security control implementation
5. Roles and responsibilities
6. Incident response procedures

**Per-Control Documentation:**
- Control description
- Implementation status
- Implementation details
- Responsible parties
- Related policies/procedures

### Required Policies

| Policy | Description |
|--------|-------------|
| Access Control Policy | User access management, authentication |
| Acceptable Use Policy | Appropriate system/data usage |
| Configuration Management Policy | Baseline configs, change control |
| Incident Response Policy | IR procedures, reporting |
| Media Protection Policy | Media handling, sanitization |
| Personnel Security Policy | Screening, termination |
| Physical Security Policy | Facility access, visitor control |
| Risk Assessment Policy | RA methodology, frequency |
| Security Awareness Policy | Training requirements |
| System & Communications Policy | Network security, encryption |

### Evidence Types

| Control Area | Evidence Examples |
|--------------|-------------------|
| Access Control | Screenshots, user lists, permission matrices |
| Training | Completion certificates, sign-in sheets |
| Audit | Log samples, SIEM dashboards, reports |
| Configuration | Config exports, hardening checklists |
| Encryption | Certificate details, encryption settings |
| Incident Response | IR plans, tabletop exercise records |
| Maintenance | Maintenance logs, vendor agreements |
| Physical | Photos, access logs, visitor logs |

---

## Common Pitfalls

### 1. Scope Creep

**Problem:** CUI spread throughout the environment

**Solution:**
- Define clear CUI boundaries
- Implement network segmentation
- Reduce CUI footprint where possible

### 2. Incomplete Documentation

**Problem:** Controls implemented but not documented

**Solution:**
- Document as you implement
- Use standardized templates
- Regular documentation reviews

### 3. Shared Responsibility Confusion

**Problem:** Unclear cloud provider vs. customer responsibilities

**Solution:**
- Obtain cloud provider attestations (FedRAMP)
- Document shared responsibility matrix
- Implement customer-responsible controls

### 4. Underestimating Level of Effort

**Problem:** Insufficient time/resources allocated

**Solution:**
- Realistic gap assessment
- Phased implementation approach
- Executive sponsorship

### 5. Ignoring Supply Chain

**Problem:** Subcontractors not compliant

**Solution:**
- Flow down requirements contractually
- Verify subcontractor compliance
- Limit CUI sharing with non-compliant parties

### 6. POA&M Abuse

**Problem:** Using POA&Ms to defer critical controls

**Solution:**
- POA&Ms only for partial implementations
- 180-day maximum closeout
- No POA&Ms for critical controls (encryption, MFA)

### 7. Assessment Shopping

**Problem:** Seeking lenient assessors

**Solution:**
- C3PAOs are accredited and monitored
- Focus on genuine compliance
- Build relationship with quality C3PAO

---

## Cost Considerations

### Typical Cost Factors

| Category | Small Org | Medium Org | Large Org |
|----------|-----------|------------|-----------|
| Gap Assessment | $10-25K | $25-50K | $50-100K |
| Remediation | $50-150K | $150-500K | $500K-2M |
| Documentation | $15-30K | $30-75K | $75-200K |
| C3PAO Assessment | $30-50K | $50-100K | $100-250K |
| Annual Maintenance | $25-50K | $50-150K | $150-500K |

### Cost Reduction Strategies

1. **Minimize CUI Scope**
   - Segment CUI systems
   - Reduce CUI footprint
   - Use CUI enclaves

2. **Leverage Existing Investments**
   - Align with existing frameworks (ISO 27001, SOC 2)
   - Use current tools where compliant

3. **Cloud Solutions**
   - FedRAMP-authorized services
   - Shared responsibility benefits
   - Reduced infrastructure costs

4. **Phased Implementation**
   - Prioritize critical controls
   - Spread costs over time
   - Start with self-assessment

---

## Resources

### Official Sources

- [CMMC Accreditation Body (Cyber-AB)](https://cyberab.org/)
- [NIST SP 800-171](https://csrc.nist.gov/publications/detail/sp/800-171/rev-2/final)
- [NIST SP 800-172](https://csrc.nist.gov/publications/detail/sp/800-172/final)
- [DoD CIO CMMC Page](https://dodcio.defense.gov/CMMC/)
- [SPRS](https://www.sprs.csd.disa.mil/)

### Assessment Resources

- [CMMC Assessment Guide](https://dodcio.defense.gov/CMMC/Documentation/)
- [NIST 800-171A (Assessment)](https://csrc.nist.gov/publications/detail/sp/800-171a/final)
- [Cyber-AB Marketplace (Find C3PAOs)](https://cyberab.org/Marketplace)

### Tools

| Tool | Purpose |
|------|---------|
| NIST OSCAL | Standardized control documentation |
| Microsoft Compliance Manager | M365 compliance tracking |
| AWS Artifact | AWS compliance reports |
| Tenable.io | Vulnerability scanning |
| Splunk | SIEM/logging |

### Templates

- NIST SSP Template
- CUI Marking Guide
- POA&M Template
- Incident Response Plan Template

---

## Glossary

| Term | Definition |
|------|------------|
| **C3PAO** | CMMC Third-Party Assessment Organization |
| **CUI** | Controlled Unclassified Information |
| **DIBCAC** | Defense Industrial Base Cybersecurity Assessment Center |
| **FCI** | Federal Contract Information |
| **FIPS** | Federal Information Processing Standards |
| **FedRAMP** | Federal Risk and Authorization Management Program |
| **NIST** | National Institute of Standards and Technology |
| **OSC** | Organization Seeking Certification |
| **POA&M** | Plan of Action and Milestones |
| **SPRS** | Supplier Performance Risk System |
| **SSP** | System Security Plan |

---

## Compliance Checklist

### Pre-Assessment Readiness

- [ ] CUI scope defined and documented
- [ ] Network segmentation implemented
- [ ] All 110 NIST 800-171 controls addressed
- [ ] SSP complete and current
- [ ] Policies approved and distributed
- [ ] Training completed and documented
- [ ] Evidence collected and organized
- [ ] POA&Ms documented (if applicable)
- [ ] SPRS score submitted
- [ ] C3PAO selected and scheduled

---

## About the Author

Josh Merritt is the CTO of QUX Technologies, specializing in CMMC compliance implementation, post-quantum cryptography, and secure infrastructure design. With expertise in network engineering and security architecture, he helps organizations achieve and maintain compliance with defense industry cybersecurity requirements.

---

*This guide is provided for educational purposes. Consult with qualified compliance professionals and legal counsel for specific implementation guidance. CMMC requirements are subject to change based on DoD rulemaking.*

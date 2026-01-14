# Post-Quantum Cryptography: A Practical Guide

**Author:** Josh Merritt, CTO @ QUX Technologies
**Last Updated:** January 2026

---

## Table of Contents

1. [Introduction](#introduction)
2. [The Quantum Threat](#the-quantum-threat)
3. [NIST PQC Standards](#nist-pqc-standards)
4. [Key Algorithms](#key-algorithms)
5. [Hybrid Cryptography](#hybrid-cryptography)
6. [Migration Strategies](#migration-strategies)
7. [Implementation Considerations](#implementation-considerations)
8. [Resources](#resources)

---

## Introduction

Post-Quantum Cryptography (PQC) refers to cryptographic algorithms designed to be secure against attacks by both classical and quantum computers. As quantum computing advances, the cryptographic foundations that secure our digital infrastructure face an existential threat.

### Why This Matters Now

- **Harvest Now, Decrypt Later (HNDL):** Adversaries are collecting encrypted data today with the intent to decrypt it once quantum computers become available
- **Crypto-Agility:** Transitioning cryptographic systems takes years—starting now is essential
- **Regulatory Pressure:** NIST, NSA, and CISA have issued guidance requiring PQC migration timelines

---

## The Quantum Threat

### Vulnerable Algorithms

| Algorithm | Type | Quantum Attack | Status |
|-----------|------|----------------|--------|
| RSA | Asymmetric | Shor's Algorithm | **Broken** |
| ECC (ECDSA, ECDH) | Asymmetric | Shor's Algorithm | **Broken** |
| DSA | Signatures | Shor's Algorithm | **Broken** |
| DH | Key Exchange | Shor's Algorithm | **Broken** |
| AES-128 | Symmetric | Grover's Algorithm | Weakened (use AES-256) |
| AES-256 | Symmetric | Grover's Algorithm | **Safe** |
| SHA-256 | Hash | Grover's Algorithm | **Safe** |

### Shor's Algorithm

Shor's algorithm can efficiently factor large integers and compute discrete logarithms on a quantum computer, breaking:

- **RSA:** Based on integer factorization
- **ECC:** Based on elliptic curve discrete logarithm problem (ECDLP)
- **DH/DSA:** Based on discrete logarithm problem (DLP)

### Grover's Algorithm

Grover's algorithm provides quadratic speedup for unstructured search, effectively halving the security level of symmetric algorithms:

- AES-128 → 64-bit security (insufficient)
- AES-256 → 128-bit security (adequate)

---

## NIST PQC Standards

In 2024, NIST finalized the first post-quantum cryptographic standards after an 8-year evaluation process:

### FIPS 203: ML-KEM (Kyber)
- **Purpose:** Key Encapsulation Mechanism (KEM)
- **Use Case:** Key exchange, establishing shared secrets
- **Security Basis:** Module Learning With Errors (MLWE)

### FIPS 204: ML-DSA (Dilithium)
- **Purpose:** Digital Signatures
- **Use Case:** Authentication, code signing, certificates
- **Security Basis:** Module Learning With Errors (MLWE)

### FIPS 205: SLH-DSA (SPHINCS+)
- **Purpose:** Digital Signatures (stateless hash-based)
- **Use Case:** Backup signature scheme, conservative option
- **Security Basis:** Hash functions only

### FIPS 206: FN-DSA (Falcon) - Coming Soon
- **Purpose:** Digital Signatures
- **Use Case:** Bandwidth-constrained environments
- **Security Basis:** NTRU lattices

---

## Key Algorithms

### ML-KEM (Kyber) - Key Encapsulation

Kyber is a lattice-based KEM selected for key exchange operations.

**Parameter Sets:**

| Parameter | Security Level | Public Key | Ciphertext | Shared Secret |
|-----------|---------------|------------|------------|---------------|
| ML-KEM-512 | NIST Level 1 (AES-128) | 800 bytes | 768 bytes | 32 bytes |
| ML-KEM-768 | NIST Level 3 (AES-192) | 1,184 bytes | 1,088 bytes | 32 bytes |
| ML-KEM-1024 | NIST Level 5 (AES-256) | 1,568 bytes | 1,568 bytes | 32 bytes |

**Recommended:** ML-KEM-768 for most applications (balanced security/performance)

### ML-DSA (Dilithium) - Digital Signatures

Dilithium is a lattice-based signature scheme selected for authentication.

**Parameter Sets:**

| Parameter | Security Level | Public Key | Signature | Secret Key |
|-----------|---------------|------------|-----------|------------|
| ML-DSA-44 | NIST Level 2 | 1,312 bytes | 2,420 bytes | 2,560 bytes |
| ML-DSA-65 | NIST Level 3 | 1,952 bytes | 3,293 bytes | 4,032 bytes |
| ML-DSA-87 | NIST Level 5 | 2,592 bytes | 4,595 bytes | 4,896 bytes |

**Recommended:** ML-DSA-65 for most applications

### SLH-DSA (SPHINCS+) - Hash-Based Signatures

SPHINCS+ provides a conservative, hash-based alternative with minimal security assumptions.

**Tradeoffs:**
- ✅ Security relies only on hash function security
- ✅ No lattice assumptions
- ❌ Larger signatures (7-50 KB)
- ❌ Slower signing

**Use Case:** High-security applications, root certificates, code signing

---

## Hybrid Cryptography

### What is Hybrid Cryptography?

Hybrid cryptography combines classical and post-quantum algorithms to provide security against both classical and quantum attacks. If either algorithm remains secure, the combined system remains secure.

### Why Hybrid?

1. **Defense in Depth:** PQC algorithms are relatively new; hybrid provides a safety net
2. **Regulatory Compliance:** Some standards still require classical algorithms
3. **Interoperability:** Gradual migration path for legacy systems
4. **Cryptographic Agility:** Easier to swap components as standards evolve

### Hybrid Patterns

#### Key Exchange (KEM)
```
Combined_Secret = KDF(ECDH_Secret || ML-KEM_Secret)
```

#### Digital Signatures
```
Valid = ECDSA_Verify(msg, sig_classical) AND ML-DSA_Verify(msg, sig_pqc)
```

### Recommended Hybrid Combinations

| Use Case | Classical | Post-Quantum | Combined Security |
|----------|-----------|--------------|-------------------|
| Key Exchange | X25519 | ML-KEM-768 | Level 3 |
| Key Exchange | P-384 | ML-KEM-1024 | Level 5 |
| Signatures | Ed25519 | ML-DSA-65 | Level 3 |
| Signatures | P-384 | ML-DSA-87 | Level 5 |

---

## Migration Strategies

### Phase 1: Assessment (Months 1-3)

1. **Cryptographic Inventory**
   - Identify all cryptographic assets
   - Document key sizes, algorithms, and use cases
   - Map data flows and trust boundaries

2. **Risk Assessment**
   - Classify data by sensitivity and lifespan
   - Identify HNDL-vulnerable data
   - Prioritize migration targets

3. **Dependency Analysis**
   - Audit third-party libraries
   - Check vendor PQC roadmaps
   - Identify hardware dependencies (HSMs, TPMs)

### Phase 2: Planning (Months 3-6)

1. **Architecture Design**
   - Design crypto-agile abstractions
   - Plan hybrid implementation
   - Define rollback procedures

2. **Testing Strategy**
   - Establish performance baselines
   - Plan interoperability testing
   - Define security validation criteria

### Phase 3: Implementation (Months 6-18)

1. **Infrastructure Updates**
   - Update TLS configurations
   - Deploy PQC-capable libraries
   - Upgrade HSMs/key management

2. **Application Migration**
   - Implement hybrid schemes
   - Update certificate chains
   - Migrate stored encrypted data (if necessary)

3. **Validation**
   - Security audits
   - Performance testing
   - Penetration testing

### Phase 4: Operations (Ongoing)

1. **Monitoring**
   - Track algorithm usage
   - Monitor for vulnerabilities
   - Performance metrics

2. **Maintenance**
   - Regular library updates
   - Certificate rotation
   - Key management procedures

---

## Implementation Considerations

### Performance Impact

PQC algorithms have different performance characteristics than classical algorithms:

| Operation | RSA-2048 | ECC P-256 | ML-KEM-768 | ML-DSA-65 |
|-----------|----------|-----------|------------|-----------|
| Key Gen | 1x | 1x | ~1.5x | ~2x |
| Encrypt/Encaps | 1x | 1x | ~1.2x | N/A |
| Decrypt/Decaps | 1x | 1x | ~1.1x | N/A |
| Sign | N/A | 1x | N/A | ~2.5x |
| Verify | N/A | 1x | N/A | ~1.5x |

*Relative to classical equivalents; actual performance varies by implementation*

### Bandwidth Considerations

PQC algorithms have larger key and signature sizes:

| Algorithm | Public Key | Signature/Ciphertext |
|-----------|------------|---------------------|
| RSA-2048 | 256 bytes | 256 bytes |
| ECDSA P-256 | 64 bytes | 64 bytes |
| ML-KEM-768 | 1,184 bytes | 1,088 bytes |
| ML-DSA-65 | 1,952 bytes | 3,293 bytes |

**Mitigation Strategies:**
- Compress where possible
- Cache public keys
- Use certificate compression (RFC 8879)
- Consider Falcon for bandwidth-constrained scenarios

### Library Selection

**Recommended Libraries:**

| Language | Library | Notes |
|----------|---------|-------|
| C | liboqs | Reference implementation, wide algorithm support |
| C | pqcrypto | High-performance implementations |
| Rust | pqcrypto | Rust bindings for pqcrypto |
| Rust | oqs-rs | Rust bindings for liboqs |
| Go | circl | Cloudflare's cryptography library |
| Python | liboqs-python | Python bindings for liboqs |
| Java | Bouncy Castle | PQC support in recent versions |

### Hardware Security Modules (HSMs)

HSM support for PQC is evolving:

- **Thales Luna:** PQC support available
- **AWS CloudHSM:** Limited PQC support
- **Azure Dedicated HSM:** Roadmap includes PQC
- **YubiKey:** Investigating PQC support

**Recommendation:** Verify HSM PQC capabilities before procurement

---

## Security Considerations

### Side-Channel Attacks

PQC implementations may be vulnerable to:

- **Timing attacks:** Ensure constant-time implementations
- **Power analysis:** Use masking countermeasures
- **Cache attacks:** Avoid secret-dependent memory access

**Mitigation:** Use audited, hardened implementations from reputable sources

### Implementation Pitfalls

1. **Don't roll your own crypto** - Use standardized, audited libraries
2. **Don't skip hybrid** - PQC algorithms are still maturing
3. **Don't ignore key management** - Larger keys require updated procedures
4. **Don't forget backwards compatibility** - Plan for legacy system interaction

### Compliance & Standards

- **NIST SP 800-208:** Recommendation for Stateful Hash-Based Signatures
- **CNSA 2.0:** NSA guidance for National Security Systems
- **ETSI:** European PQC standards and recommendations
- **IETF:** TLS 1.3 PQC extensions (drafts)

---

## Resources

### Official Standards
- [NIST Post-Quantum Cryptography](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [FIPS 203 (ML-KEM)](https://csrc.nist.gov/pubs/fips/203/final)
- [FIPS 204 (ML-DSA)](https://csrc.nist.gov/pubs/fips/204/final)
- [FIPS 205 (SLH-DSA)](https://csrc.nist.gov/pubs/fips/205/final)

### Libraries & Tools
- [Open Quantum Safe (liboqs)](https://openquantumsafe.org/)
- [Cloudflare CIRCL](https://github.com/cloudflare/circl)
- [Bouncy Castle](https://www.bouncycastle.org/)

### Learning Resources
- [NIST PQC FAQ](https://csrc.nist.gov/projects/post-quantum-cryptography/faqs)
- [Quantum Computing Report](https://quantumcomputingreport.com/)
- [PQC Forum](https://groups.google.com/a/list.nist.gov/g/pqc-forum)

### Migration Guidance
- [CISA Post-Quantum Cryptography Initiative](https://www.cisa.gov/quantum)
- [NSA Cybersecurity Advisory on PQC](https://media.defense.gov/2022/Sep/07/2003071836/-1/-1/0/CSI_CNSA_2.0_FAQ_.PDF)

---

## Glossary

| Term | Definition |
|------|------------|
| **KEM** | Key Encapsulation Mechanism - method for securely transmitting symmetric keys |
| **MLWE** | Module Learning With Errors - mathematical problem underlying Kyber/Dilithium |
| **HNDL** | Harvest Now, Decrypt Later - threat model for long-lived data |
| **Crypto-Agility** | Ability to swap cryptographic algorithms without major system changes |
| **Hybrid Cryptography** | Combining classical and PQC algorithms for defense in depth |
| **Lattice-Based** | Cryptography based on hard problems in mathematical lattices |
| **Hash-Based** | Cryptography based solely on security of hash functions |

---

## About the Author

Josh Merritt is the CTO of QUX Technologies, specializing in post-quantum cryptography implementation, CMMC compliance, and secure infrastructure design. With experience spanning network engineering, full-stack development, and hardware prototyping, he focuses on building privacy-first systems prepared for the post-quantum era.

---

*This guide is provided for educational purposes. Always consult current standards and qualified security professionals when implementing cryptographic systems.*

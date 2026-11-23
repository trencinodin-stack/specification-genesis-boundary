# Security Policy

## Reporting a Vulnerability

If you discover a soundness defect, hidden global axiom, `coqchk -o` verification bypass, or policy-laundering flaw in `specification-genesis-boundary`, please **do not open a public issue**.

Submit reports through either of the following private channels:

1. **GitHub Private Vulnerability Reporting (Recommended):**
   - Go to the **Security** tab of this repository (`trencinodin-stack/specification-genesis-boundary`).
   - Click **Report a vulnerability**.
   - Fill out the form to submit a private report directly to maintainers.

2. **Email:**
   - Contact us at **security@arcstoneos.com**.

---

## What to Include

Please include, where applicable:
- A concise description of the formal soundness defect, counterexample, or policy admission flaw.
- Minimal reproduction steps or a standalone Coq `.v` snippet demonstrating the issue under Coq `8.18.0`.
- The affected release tag (e.g., `v0.1.0`) or git commit hash.
- Whether the issue involves:
  - Leakage of `Admitted`, `Axiom`, `Conjecture`, or `Parameter` into the global context (`Print Assumptions` not reporting `Closed under the global context`);
  - Failure of `coqchk -o` kernel validation or `Makefile` / CI assumption-count gates;
  - A flaw in `EvidencePolicy.admissible_claim` allowing unattested, self-attested, unpinned, or stale-binding `IntentAdequacy` claims to be admitted under `MechanizedProof`;
  - Type-signature drift in `Ledger.end_to_end_ledger_accounting` hiding external `conforms` or `faithful` premises;
  - Divergence between `tests/ExportVectors.v` (`VEC-01` through `VEC-08`) and downstream policy validators.

---

## Release Immutability & Versioning Protocol

`specification-genesis-boundary` operates as an immutable, axiom-free formal specification and policy reference library (`Print Assumptions == ∅`).

- **No Silent Theorem Mutation:** Reporting a defect does not authorize altering theorem statements, inductive definitions, or `VEC-01`..`VEC-08` truth-table semantics on an existing tag. Verified fixes are published as explicit versioned releases with updated SHA-256 manifests.
- **Preservation of Section-Scoped Premises:** Fixes must preserve closed global assumption accounting (`Closed under the global context`) while keeping external conformance and semantic-fidelity premises explicit in generalized theorem types.

---

## Scope & Bounded Claims

`specification-genesis-boundary` is a minimal, domain-agnostic Coq `8.18.0` formalization of the specification-genesis boundary and multi-axis evidence admission policy.

The repository explicitly does **not** claim:
- Solution of the genesis problem or automated verification of natural-language semantic adequacy;
- Metatheoretic soundness of the underlying Coq `8.18.0` kernel or `coqchk` binary;
- Empirical or probabilistic bounds on LLM autoformalization accuracy;
- Executable runtime monitors, memory/latency clamps, or physical actuator enforcement.

---

## Response Timeline

We will acknowledge receipt within **48 hours** and work with you on a coordinated resolution and disclosure timeline.
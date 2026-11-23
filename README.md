# `specification-genesis-boundary` (`v0.1.0`)

**Toolchain:** Coq 8.18.0 (Constructive Core, `Print Assumptions == ∅`, `coqchk -o`) | **License:** `MIT OR Apache-2.0`

- **Machine Ingestion:** [`MACHINEFIRST.md`](MACHINEFIRST.md) · [`machinefirst.txt`](machinefirst.txt) · [`MACHINEFIRST.sha256`](MACHINEFIRST.sha256) · [`llms.txt`](llms.txt) · [`AGENTS.md`](AGENTS.md)

## Overview & Scope Boundaries

`specification-genesis-boundary` is a minimal, domain-agnostic Coq 8.18.0 library formalizing the structural boundary between informal semantic intent, candidate formal specifications, and machine-checked derivations or implementations.

In automated verification and LLM-assisted autoformalization pipelines, a proof assistant can verify that a formal theorem follows from stated axioms or that a concrete implementation refines a formal specification (`Impl ⊑ Spec`). However, mechanical verification begins only after a vocabulary, ontology, and formal specification have been chosen. This library formalizes three core properties of that boundary:

* **Observation-Limited Indistinguishability:** Any deterministic translation or checking procedure operating solely on an observable representation `O` cannot simultaneously preserve semantic fidelity for two distinct requirements that produce identical observations (`observe l1 = observe l2`) while having incompatible intended behaviors.
* **Multi-Axis Epistemic Non-Laundering:** Provenance (human-authored vs. LLM-autoformalized), formal proof checking, claim scope, semantic adequacy attestation, and specification binding state operate on independent axes. Recording a successful formal proof check cannot silently upgrade the semantic-adequacy status of an unattested or mutated specification.
* **Explicit Assumption Accounting:** Core boundary and policy theorems remain completely closed under the global context (`Print Assumptions == ∅`), while end-to-end adequacy transfer theorems explicitly expose external conformance and semantic-fidelity premises in their generalized theorem types.

### Explicit Scope Exclusions (Non-Claims)

* **Does Not Solve the Genesis Problem:** Characterizes the boundary where modeled mechanical guarantees stop without establishing semantic adequacy; it does not verify natural-language truth, automate risk alignment, or certify real-world adequacy.
* **Does Not Prove Metatheoretic Kernel Soundness:** Assumes the soundness of the underlying Coq 8.18.0 kernel and `coqchk` verifier.
* **No Empirical or Probabilistic Claims:** Makes no statistical claims regarding LLM translation accuracy, multi-translator consensus, or empirical error rates.
* **No Runtime Monitor or Actuation Enforcement:** Does not provide an executable runtime monitor, resource or timing bounds, or physical actuator boundary.
* **Self-Referential Limitation:** Definitions in this library are human-authored formalizations and are themselves subject to the specification-genesis boundary.

## Build & Verification

```bash
make verify
```

Or via the pinned Coq `8.18.0` container:

```bash
docker run --rm -v "$PWD":/work -w /work \
  coqorg/coq@sha256:b0ddec11e839ab96fd514040d6f2a3a1f47b9e2a3999cc5c7f2527d1925f9126 \
  bash -lc 'eval "$(opam env --root=/home/coq/.opam --set-root)" && make verify'
```

## Prior-Art & Historical References

| Reference | Domain | Structural Contribution |
| :--- | :--- | :--- |
| Boehm, B. W. (1981). *Software Engineering Economics*. Prentice-Hall. | Software Engineering | Distinguishes verification ("building the product right") from validation ("building the right product"). |
| Hardy, N. (1988). "The Confused Deputy: (or why capabilities might have been invented)." *ACM SIGOPS Operating Systems Review*, 22(4), 36–38. | Capability Security | Identifies authority confusion when an interface conflates unprivileged input provenance with ambient authority. |
| Necula, G. C. (1997). "Proof-Carrying Code." *POPL '97*, 106–119. | Formal Verification | Establishes machine-checkable proof certificates relative to a consumer-defined safety policy, leaving policy adequacy external. |
| Zave, P., & Jackson, M. (1997). "Four Dark Corners of Requirements Engineering." *ACM TOSEM*, 6(1), 1–30. | Requirements Engineering | Separates environment domain knowledge ($W$), specification ($S$), and requirements ($R$), showing $W, S \vdash R$ requires external environment validation. |
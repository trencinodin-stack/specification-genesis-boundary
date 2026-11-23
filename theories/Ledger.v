From GenesisBoundary Require Import Boundary.

Section EndToEndTrustLedger.

  Variables (L O S W : Type).
  Variable observe : L -> O.
  Variable translate : O -> S.
  Variable intended : L -> W -> bool.
  Variable formal : S -> W -> bool.
  Variable implementation : W -> bool.
  Variable req : L.
  Variable world : W.

  (* Explicit external trust obligations discharged outside the proof kernel *)
  Hypothesis H_implementation_refines_spec :
    conforms S W formal implementation (translate (observe req)) world.

  Hypothesis H_genesis_semantic_fidelity :
    faithful L O S W observe translate intended formal req world.

  (* T7: End-to-End Trust Accounting Theorem
     Once this section closes, Print Assumptions reports Closed under the global
     context (zero hidden axioms), while the generalized theorem type exposes
     H_implementation_refines_spec and H_genesis_semantic_fidelity as explicit premises. *)
  Theorem end_to_end_ledger_accounting :
    implementation world = intended req world.
  Proof using H_implementation_refines_spec H_genesis_semantic_fidelity.
    exact (@assurance_requires_semantic_fidelity
             L O S W observe translate intended formal implementation
             req world
             H_implementation_refines_spec
             H_genesis_semantic_fidelity).
  Qed.

End EndToEndTrustLedger.

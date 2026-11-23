From GenesisBoundary Require Import Boundary EvidencePolicy Countermodels Ledger.

(* Verify exact generalized signature of the end-to-end ledger theorem *)
Definition ledger_signature_check :
  forall (L O S W : Type)
         (observe : L -> O)
         (translate : O -> S)
         (intended : L -> W -> bool)
         (formal : S -> W -> bool)
         (implementation : W -> bool)
         (req : L)
         (world : W),
    conforms S W formal implementation (translate (observe req)) world ->
    faithful L O S W observe translate intended formal req world ->
    implementation world = intended req world
  := end_to_end_ledger_accounting.

(* Must all 7 report: Closed under the global context *)
Print Assumptions indistinguishable_inputs_force_error.
Print Assumptions assurance_requires_semantic_fidelity.
Print Assumptions no_epistemic_laundering.
Print Assumptions formal_proof_preserved_when_scoped.
Print Assumptions spec_mutation_invalidates_adequacy.
Print Assumptions checked_spec_can_misrepresent_intent.
Print Assumptions end_to_end_ledger_accounting.

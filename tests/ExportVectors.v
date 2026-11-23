From GenesisBoundary Require Import EvidencePolicy.

(* VEC-01: FormalStatement + LLMAutoformalized + Unattested -> true *)
Compute admissible_claim
  (record_proof_check (mkClaim LLMAutoformalized Stated FormalStatement Unattested false true)).

(* VEC-02: IntentAdequacy + HumanAuthored + Unattested -> false *)
Compute admissible_claim
  (record_proof_check (mkClaim HumanAuthored Stated IntentAdequacy Unattested false true)).

(* VEC-03: IntentAdequacy + HumanAuthored + SelfAttested + Pinned Ref -> false *)
Compute admissible_claim
  (record_proof_check (mkClaim HumanAuthored Stated IntentAdequacy SelfAttested true true)).

(* VEC-04: IntentAdequacy + LLMAutoformalized + ThirdPartyAttested + Pinned Ref + Current -> true *)
Compute admissible_claim
  (record_proof_check (mkClaim LLMAutoformalized Stated IntentAdequacy ThirdPartyAttested true true)).

(* Note: Both missing references (VEC-05) and unpinned references (VEC-06)
   project onto has_pinned_genesis_ref = false in the abstract ClaimRecord model. *)

(* VEC-05: IntentAdequacy + ThirdPartyAttested + Missing Ref -> false *)
Compute admissible_claim
  (record_proof_check (mkClaim HumanAuthored Stated IntentAdequacy ThirdPartyAttested false true)).

(* VEC-06: IntentAdequacy + ThirdPartyAttested + Unpinned Ref -> false *)
Compute admissible_claim
  (record_proof_check (mkClaim HumanAuthored Stated IntentAdequacy ThirdPartyAttested false true)).

(* VEC-07: ImplementationRefinement + LLMAutoformalized + Unattested -> true *)
Compute admissible_claim
  (record_proof_check (mkClaim LLMAutoformalized Stated ImplementationRefinement Unattested false true)).

(* VEC-08: IntentAdequacy + ThirdPartyAttested + Pinned Ref + Stale Binding -> false *)
Compute admissible_claim
  (invalidate_binding
    (record_proof_check (mkClaim HumanAuthored Stated IntentAdequacy ThirdPartyAttested true true))).

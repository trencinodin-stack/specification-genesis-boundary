From GenesisBoundary Require Import EvidencePolicy.

Definition unattested_llm_claim : ClaimRecord :=
  mkClaim LLMAutoformalized Stated IntentAdequacy Unattested false true.

Definition self_attested_claim : ClaimRecord :=
  mkClaim HumanAuthored Tested IntentAdequacy SelfAttested true true.

Definition valid_third_party_claim : ClaimRecord :=
  mkClaim LLMAutoformalized Stated IntentAdequacy ThirdPartyAttested true true.

(* Negative controls: Coq must reject any proof that proof-checking promotes
   unattested or self-attested IntentAdequacy claims to admissible = true. *)
Fail Definition forged_unattested_promotion :
  admissible_claim (record_proof_check unattested_llm_claim) = true :=
  eq_refl.

Fail Definition forged_self_attested_promotion :
  admissible_claim (record_proof_check self_attested_claim) = true :=
  eq_refl.

(* Paired positive controls proving the negative controls fail due to policy
   rejection (false = true) rather than syntax/type errors. *)
Example unattested_remains_inadmissible :
  admissible_claim (record_proof_check unattested_llm_claim) = false :=
  eq_refl.

Example self_attested_remains_inadmissible :
  admissible_claim (record_proof_check self_attested_claim) = false :=
  eq_refl.

Example third_party_pinned_current_admissible :
  admissible_claim (record_proof_check valid_third_party_claim) = true :=
  eq_refl.

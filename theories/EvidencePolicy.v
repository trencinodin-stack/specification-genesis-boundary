From Coq Require Import Bool.Bool.

Inductive SpecOrigin : Type :=
  | HumanAuthored
  | LLMAutoformalized
  | HybridFormalized.

Inductive ProofLevel : Type :=
  | Stated
  | Tested
  | MechanizedProof.

Inductive ClaimScope : Type :=
  | FormalStatement
  | ImplementationRefinement
  | IntentAdequacy.

Inductive AdequacyStatus : Type :=
  | Unattested
  | SelfAttested
  | ThirdPartyAttested.

Record ClaimRecord : Type := mkClaim {
  claim_origin : SpecOrigin;
  claim_proof : ProofLevel;
  claim_scope : ClaimScope;
  claim_adequacy : AdequacyStatus;
  has_pinned_genesis_ref : bool;
  binding_current : bool
}.

(* Policy predicate: Determines whether a claim is admissible without
   committing Genesis Laundering.
   FormalStatement and ImplementationRefinement claims may hold MechanizedProof
   regardless of specification adequacy (honest relative proof).
   IntentAdequacy claims claiming MechanizedProof require ThirdPartyAttested
   adequacy, a pinned genesis reference, and a current specification binding. *)
Definition admissible_claim (c : ClaimRecord) : bool :=
  match claim_proof c with
  | Stated => true
  | Tested => true
  | MechanizedProof =>
      match claim_scope c with
      | FormalStatement => true
      | ImplementationRefinement => true
      | IntentAdequacy =>
          match claim_adequacy c with
          | ThirdPartyAttested =>
              andb (has_pinned_genesis_ref c) (binding_current c)
          | Unattested => false
          | SelfAttested => false
          end
      end
  end.

(* Abstract state transition modeling the outcome of a successful proof check:
   Updates claim_proof to MechanizedProof while leaving origin, scope,
   adequacy status, and binding state invariant. *)
Definition record_proof_check (c : ClaimRecord) : ClaimRecord :=
  mkClaim
    (claim_origin c)
    MechanizedProof
    (claim_scope c)
    (claim_adequacy c)
    (has_pinned_genesis_ref c)
    (binding_current c).

(* Abstract state transition modeling specification byte mutation:
   Invalidates binding_current without altering past proof or adequacy labels. *)
Definition invalidate_binding (c : ClaimRecord) : ClaimRecord :=
  mkClaim
    (claim_origin c)
    (claim_proof c)
    (claim_scope c)
    (claim_adequacy c)
    (has_pinned_genesis_ref c)
    false.

(* T3: No Epistemic Laundering via Proof Checking
   Recording a mechanized proof check on an IntentAdequacy claim whose
   adequacy is Unattested or SelfAttested never produces an admissible claim. *)
Theorem no_epistemic_laundering :
  forall (c : ClaimRecord),
    claim_scope c = IntentAdequacy ->
    claim_adequacy c <> ThirdPartyAttested ->
    admissible_claim (record_proof_check c) = false.
Proof.
  intros [origin proof scope adequacy pinned current].
  simpl.
  intros Hscope Hnot_third.
  subst scope.
  destruct adequacy.
  - reflexivity.
  - reflexivity.
  - exfalso. exact (Hnot_third eq_refl).
Qed.

(* T4: Formal-Only Proofs Remain Valid Without Adequacy Attestation
   An LLM-autoformalized or human-authored formal statement can legitimately
   hold MechanizedProof under FormalStatement scope without laundering adequacy. *)
Theorem formal_proof_preserved_when_scoped :
  forall (c : ClaimRecord),
    claim_scope c = FormalStatement ->
    admissible_claim (record_proof_check c) = true.
Proof.
  intros [origin proof scope adequacy pinned current].
  simpl.
  intro Hscope.
  subst scope.
  reflexivity.
Qed.

(* T5: Specification Mutation Invalidates Intent-Adequacy Admission
   Modifying the underlying specification invalidates IntentAdequacy
   admission even if ThirdPartyAttested was previously recorded. *)
Theorem spec_mutation_invalidates_adequacy :
  forall (c : ClaimRecord),
    claim_proof c = MechanizedProof ->
    claim_scope c = IntentAdequacy ->
    admissible_claim (invalidate_binding c) = false.
Proof.
  intros [origin proof scope adequacy pinned current].
  simpl.
  intros Hproof Hscope.
  subst proof scope.
  destruct adequacy.
  - reflexivity.
  - reflexivity.
  - destruct pinned; reflexivity.
Qed.

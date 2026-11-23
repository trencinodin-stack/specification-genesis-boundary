From Coq Require Import Bool.Bool.
From GenesisBoundary Require Import Boundary.

Definition lossy_observe (_ : bool) : unit := tt.
Definition constant_translate (_ : unit) : bool := true.
Definition ex_intended (b : bool) (_ : unit) : bool := b.
Definition ex_formal (s : bool) (_ : unit) : bool := s.
Definition toy_spec_accepted (s : bool) : Prop := s = true.

(* T6: Constructive Countermodel to Unrestricted Semantic Fidelity
   A specification accepted by a syntactic/formal check can misrepresent the
   intended requirement when observation collapses distinct inputs. *)
Theorem checked_spec_can_misrepresent_intent :
  exists l : bool,
    toy_spec_accepted (constant_translate (lossy_observe l)) /\
    ~ @faithful bool unit bool unit lossy_observe constant_translate ex_intended ex_formal l tt.
Proof.
  exists false.
  split.
  - unfold toy_spec_accepted, constant_translate, lossy_observe.
    reflexivity.
  - unfold faithful, constant_translate, lossy_observe, ex_intended, ex_formal.
    intro H.
    discriminate H.
Qed.

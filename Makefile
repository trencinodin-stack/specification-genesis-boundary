COQMAKEFILE := Makefile.coq

all: $(COQMAKEFILE)
	$(MAKE) -f $(COQMAKEFILE) all

$(COQMAKEFILE): _CoqProject
	coq_makefile -f _CoqProject -o $(COQMAKEFILE)

verify: all
	@echo "=== Checking pinned Coq 8.18.0 toolchain ==="
	@coqc --version | grep -q "8\.18\.0" || { echo "ERROR: Expected Coq 8.18.0"; coqc --version; exit 1; }
	@echo "=== Checking for forbidden axioms or admitted proofs ==="
	@! grep -rnE "\b(Admitted|Axiom|Conjecture|Parameter)\b" theories/
	@echo "=== Running coqchk -o kernel verification ==="
	coqchk -o -Q theories GenesisBoundary GenesisBoundary.Boundary GenesisBoundary.EvidencePolicy GenesisBoundary.Countermodels GenesisBoundary.Ledger
	@echo "=== Verifying Print Assumptions == Closed on all 7 exported theorems ==="
	@OUT=$$(coqc -Q theories GenesisBoundary -Q tests GenesisBoundaryTests tests/AuditAssumptions.v 2>&1) || { printf '%s\n' "$$OUT"; exit 1; }; \
	printf '%s\n' "$$OUT"; \
	COUNT=$$(printf '%s\n' "$$OUT" | grep -c "Closed under the global context"); \
	if [ "$$COUNT" -ne 7 ]; then \
		echo "ERROR: Expected 7 closed theorems, found $$COUNT"; \
		exit 1; \
	fi

clean:
	@if [ -f $(COQMAKEFILE) ]; then $(MAKE) -f $(COQMAKEFILE) clean; fi
	rm -f $(COQMAKEFILE) $(COQMAKEFILE).conf

.PHONY: all verify clean
